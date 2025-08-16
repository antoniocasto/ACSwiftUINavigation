//
//  DefaultNavigationRegistry.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 16/08/25.
//

import Foundation

/// An actor-based default implementation of a navigation registry for managing `RoutableFactory` instances.
///
/// `DefaultNavigationRegistry` maintains a mapping between object identifiers and corresponding `RoutableFactory`
/// instances. It provides thread-safe (concurrent) registration, lookup, and deletion operations using Swift's actor model.
/// It is intended to be used as a singleton, accessible via the `shared` property.
///
/// Use this registry to register, resolve, and remove navigation factories dynamically at runtime.
/// All operations are asynchronous and isolated to the actor context.
///
/// Example usage:
/// ```swift
/// await DefaultNavigationRegistry.shared.register(factory: MyFactory(), for: MyFactory.self)
/// let factory = await DefaultNavigationRegistry.shared.resolve(factoryType: MyFactory.self)
/// await DefaultNavigationRegistry.shared.deleteEntry(for: MyFactory.self)
/// await DefaultNavigationRegistry.shared.clear()
/// ```
///
/// - Note: This registry uses `ObjectIdentifier` as the key for uniquely identifying factory types.
///
/// - SeeAlso: `NavigationRegistry`, `RoutableFactory`
public final actor DefaultNavigationRegistry: NavigationRegistry {
    //MARK: - Properties
    
    private var registry: [ObjectIdentifier: any RoutableFactory] = [:]
    
    public static let shared = DefaultNavigationRegistry()
    
    //MARK: - Methods
    
    public func register(factory: any RoutableFactory, for key: any RoutableFactory.Type) async {
        registry[ObjectIdentifier(key)] = factory
    }
    
    public func resolve(factoryType key: any RoutableFactory.Type) async -> (any RoutableFactory)? {
        registry[ObjectIdentifier(key)]
    }
    
    public func deleteEntry(for key: any RoutableFactory.Type) async {
        registry[ObjectIdentifier(key)] = nil
    }
    
    public func clear() async {
        registry.removeAll()
    }
}
