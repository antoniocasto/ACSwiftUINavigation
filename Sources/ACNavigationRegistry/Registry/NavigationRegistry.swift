//
//  NavigationRegistry.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 16/08/25.
//

import Foundation
import ACSwiftUINavigation


/// A protocol defining a registry for managing navigation routes within an application.
///
/// `NavigationRegistry` allows dynamic registration, resolution, and management of navigation routes conforming to the `AppRoute` protocol. 
/// Implementers can register route builders, resolve routes with input payloads, delete specific route entries, or clear the registry entirely.
/// 
/// All methods are asynchronous and designed to be used in concurrent contexts.
public protocol NavigationRegistry: AnyObject {
    /// Registers a builder closure for a specific route type.
    ///
    /// - Parameters:
    ///   - builder: A closure that takes an input payload and returns an instance of the route.
    ///   - routeType: The type of the route being registered.
    /// - Note: The builder closure should be `@Sendable` to allow safe usage in concurrent environments.
    func register<R: AppRoute>(builder: @Sendable @escaping (R.InputPayload) -> R, for routeType: R.Type) async
    
    /// Resolves an instance of a registered route for the provided input payload.
    ///
    /// - Parameters:
    ///   - routeType: The type of the route to resolve.
    ///   - inputPayload: The payload to use for route creation.
    /// - Returns: An instance of the registered route if found; otherwise, nil.
    func resolve<R: AppRoute>(routeType: R.Type, inputPayload: R.InputPayload) async -> R?
    
    /// Deletes a registered builder entry for the specified route type.
    ///
    /// - Parameter routeType: The type of the route whose registration should be removed.
    func deleteEntry<R: AppRoute>(for routeType: R.Type) async
    
    /// Clears all registered route builders from the registry.
    func clear() async
}
