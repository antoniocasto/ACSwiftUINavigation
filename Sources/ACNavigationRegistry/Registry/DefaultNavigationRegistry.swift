//
//  DefaultNavigationRegistry.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 16/08/25.
//

import Foundation
import ACSwiftUINavigation

/// An implementation of the `NavigationRegistry` protocol to manage navigation route builders at runtime.
///
/// `DefaultNavigationRegistry` provides a centralized, actor-isolated registry for registering, resolving,
/// and removing navigation routes and their associated builder closures. It ensures type safety and
/// thread safety by leveraging Swift's `actor` model, allowing safe usage across concurrent contexts.
///
/// Use the shared singleton instance via `DefaultNavigationRegistry.shared` to access the registry
/// throughout your application.
///
/// - Note: This registry associates builder closures with route types conforming to `AppRoute`.
///         Each route type may only be registered once. Attempting to register the same type again will trigger an assertion failure.
public final actor DefaultNavigationRegistry: NavigationRegistry {
    //MARK: - Properties
    
    private var registry: [ObjectIdentifier: Any] = [:]
    
    public static let shared = DefaultNavigationRegistry()
    
    //MARK: - Methods
    
    public func register<R: AppRoute>(builder: @Sendable @escaping (R.InputPayload) -> R, for routeType: R.Type) async {
        let key = ObjectIdentifier(routeType)
        assert(registry[key] == nil, "Error: Builder for \(R.Type.self) already registered in DefaultNavigationRegistry")
        registry[key] = { (input: R.InputPayload) -> R in
            builder(input)
        }
    }
    
    public func resolve<R: AppRoute>(routeType: R.Type, inputPayload: R.InputPayload) async -> R? {
        let key = ObjectIdentifier(routeType)
        let builder = registry[key] as? (R.InputPayload) -> R
        return builder?(inputPayload)
    }
    
    public func deleteEntry<R: AppRoute>(for routeType: R.Type) async {
        let key = ObjectIdentifier(routeType)
        assert(registry[key] != nil, "Error: Builder for \(R.Type.self) not registered in DefaultNavigationRegistry")
        registry.removeValue(forKey: key)
    }
    
    public func clear() async {
        registry.removeAll()
    }
}
