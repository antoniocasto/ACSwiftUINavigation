//
//  NavigationRegistry.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 16/08/25.
//

import Foundation

/// A protocol defining a registry for managing navigation-related factories, allowing the registration,
/// resolution, removal, and clearing of factory instances by their types.
///
/// Types conforming to `NavigationRegistry` facilitate decoupled and type-safe navigation flows by
/// maintaining a mapping between protocol types and their corresponding factory instances. This enables
/// dynamic resolution and lifecycle management of factories used in navigation, such as view or coordinator factories.
public protocol NavigationRegistry {
    /// Registers a factory for a specific factory type.
    ///
    /// - Parameters:
    ///   - factory: The factory instance to register.
    ///   - type: The metatype of the factory protocol for which the factory should be registered.
    func register(factory: any RoutableFactory, for type: any RoutableFactory.Type) async
    
    /// Resolves and retrieves the factory instance for a given factory type, if it exists.
    ///
    /// - Parameter type: The metatype of the factory protocol to resolve.
    /// - Returns: The resolved factory instance conforming to `RoutableFactory`, or `nil` if not found.
    func resolve(factoryType type: any RoutableFactory.Type) async -> (any RoutableFactory)?
    
    /// Removes the registered factory entry for a specified factory type.
    ///
    /// - Parameter type: The metatype of the factory protocol whose registration should be removed.
    func deleteEntry(for type: any RoutableFactory.Type) async
    
    /// Clears all entries from the registry, removing all registered factory instances.
    func clear() async
}

public final actor DefaultNavigationRegistry: NavigationRegistry {
    //MARK: - Properties
    
    private var registry: [ObjectIdentifier: any RoutableFactory] = [:]
    
    //MARK: - Methods
    
    public func register(factory: any RoutableFactory, for type: any RoutableFactory.Type) async {
        registry[ObjectIdentifier(type)] = factory
    }
    
    public func resolve(factoryType type: any RoutableFactory.Type) async -> (any RoutableFactory)? {
        registry[ObjectIdentifier(type)]
    }
    
    public func deleteEntry(for type: any RoutableFactory.Type) async {
        registry[ObjectIdentifier(type)] = nil
    }
    
    public func clear() async {
        registry.removeAll()
    }
}
