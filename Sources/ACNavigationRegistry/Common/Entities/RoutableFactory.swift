//
//  ACNavigationRegistry.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 16/08/25.
//

import ACSwiftUINavigation

/// A protocol that defines a factory for creating routes conforming to `AppRoute`
/// and providing deep link URL representations for those routes.
///
/// Conformance to `RoutableFactory` enables a type to construct instances of a specific
/// route type and optionally provide a deep link URL string for navigation or sharing purposes.
/// The protocol is generic over an associated `AppRoute` type, allowing flexibility in route creation
/// and deep link handling strategies.
///
/// - Note: Conforming types must be `Sendable` to ensure thread safety when used in concurrent contexts.
///
/// - SeeAlso: `AppRoute`
public protocol RoutableFactory: Sendable {
    associatedtype T: AppRoute
    
    /// Creates and returns an instance of the associated `AppRoute` type.
    ///
    /// - Returns: An instance of `T` conforming to `AppRoute`.
    func makeAppRoute() -> T
    
    /// Returns the deep link URL string associated with the given route.
    ///
    /// - Parameter route: An instance of the associated `AppRoute` type.
    /// - Returns: A `String` representing the deep link URL for the given route, or `nil` if no deep link is available.
    func deepLinkUrlStringFor(_ route: T) -> String?
}
