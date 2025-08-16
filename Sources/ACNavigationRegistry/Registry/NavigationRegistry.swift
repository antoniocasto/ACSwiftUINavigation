//
//  NavigationRegistry.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 16/08/25.
//

import Foundation

/// A protocol for managing a registry of navigation factories identified by keys.
/// 
/// The `NavigationRegistry` protocol defines an interface for registering, resolving, 
/// deleting, and clearing factories that conform to the `RoutableFactory` protocol. 
/// Keys used for registration must conform to `Sendable`.
///
/// Types conforming to this protocol can be used to manage navigation destinations,
/// such as screens or flows, by associating them with unique registry keys.
///
/// - Note: The interface is fully asynchronous; all methods are marked `async`.
///
/// ## Associated Types
/// - `RegistryKey`: The type used to identify factories in the registry. Must conform to `Sendable`.
///
/// ## Methods
/// - `register(factory:for:)`: Registers a factory for a given key.
/// - `resolve(factoryType:)`: Looks up and returns a factory for a given key, if present.
/// - `deleteEntry(for:)`: Removes the factory associated with the given key.
/// - `clear()`: Removes all registry entries.
///
public protocol NavigationRegistry: AnyObject {
    associatedtype RegistryKey: Sendable
    
    func register(factory: any RoutableFactory, for key: RegistryKey) async
    
    func resolve(factoryType key: RegistryKey) async -> (any RoutableFactory)?
    
    func deleteEntry(for key: RegistryKey) async
    
    func clear() async
}
