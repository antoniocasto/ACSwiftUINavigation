//
//  ACNavigationRegistry.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 16/08/25.
//

import ACSwiftUINavigation

/// A protocol representing a factory capable of producing routes conforming to `AppRoute`.
///
/// Conforming types define an associated type `T` that must conform to `AppRoute`
/// and implement the `makeAppRoute` method to produce an instance of that route.
///
/// - Note: This protocol requires conformers to be `Sendable` for use in concurrent contexts.
///
/// Example usage:
/// ```swift
/// struct MyRouteFactory: RoutableFactory {
///     func makeAppRoute() -> MyAppRoute {
///         // return a concrete AppRoute
///     }
/// }
/// ```
public protocol RoutableFactory: Sendable {
    associatedtype T: AppRoute
    
    /// Creates and returns an instance of the associated `AppRoute` type.
    ///
    /// - Returns: An instance of `T` conforming to `AppRoute`.
    func makeAppRoute() -> T
}
