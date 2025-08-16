//
//  DeepLinkNavigationRegistry.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 16/08/25.
//

import Foundation

/// An actor that manages a registry of deep link navigation factories.
/// 
/// `DeepLinkNavigationRegistry` is responsible for storing and retrieving instances conforming
/// to `RoutableFactory`, keyed by a `String`. This allows for dynamic resolution of navigation
/// destinations based on deep link keys at runtime.
/// 
/// This registry is implemented as an actor to ensure safe concurrent access.
/// 
/// Use the shared singleton instance via `DeepLinkNavigationRegistry.shared`.
///
/// - Note: All operations on the registry (`register`, `resolve`, `deleteEntry`, and `clear`)
///   are asynchronous and must be awaited.
///
/// ## Usage
/// ```swift
/// await DeepLinkNavigationRegistry.shared.register(factory: myFactory, for: "profile")
/// let factory = await DeepLinkNavigationRegistry.shared.resolve(factoryType: "profile")
/// await DeepLinkNavigationRegistry.shared.deleteEntry(for: "profile")
/// await DeepLinkNavigationRegistry.shared.clear()
/// ```
public final actor DeepLinkNavigationRegistry: NavigationRegistry {
    //MARK: - Properties
    
    private var registry: [String: any RoutableFactory] = [:]
    
    public static let shared = DeepLinkNavigationRegistry()
    
    //MARK: - Methods
    
    public func register(factory: any RoutableFactory, for key: String) async {
        registry[key] = factory
    }
    
    public func resolve(factoryType key: String) async -> (any RoutableFactory)? {
        registry[key]
    }
    
    public func deleteEntry(for key: String) async {
        registry[key] = nil
    }
    
    public func clear() async {
        registry.removeAll()
    }
}
