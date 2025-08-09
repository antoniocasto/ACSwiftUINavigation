//
//  AppRoute.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import SwiftUI

/// A protocol that represents a navigational route within the application.
///
/// Conforming types must conform to `Identifiable` and `Hashable`,
/// allowing the route to be uniquely identified and easily stored or compared in collections.
///
/// - Important: This protocol is intended for use in navigation stacks,
///              enabling type-safe and declarative navigation in SwiftUI applications.
///
/// ## Requirements:
/// - Conformance to `Identifiable` for uniqueness.
/// - Conformance to `Hashable` for storage and comparison.
/// - Implementation of `buildView()` to provide the SwiftUI view for this route.
///
/// ### Functions
/// - `buildView()`:
///     Returns the main view associated with this route, type-erased to `AnyView`,
///     and constructed as a SwiftUI `ViewBuilder`.
///
/// ### Example
/// ```swift
/// struct SettingsRoute: AppRoute {
///     let id = UUID()
///     func buildView() -> AnyView {
///         AnyView(SettingsView())
///     }
/// }
/// ```
public protocol AppRoute: Identifiable, Hashable {
    @ViewBuilder
    func buildView() -> AnyView
}
