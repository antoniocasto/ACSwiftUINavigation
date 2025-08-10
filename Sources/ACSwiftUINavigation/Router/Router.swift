//
//  ACSwiftUINavigation.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/2025.
//

import Observation
import SwiftUI


/// # Router
/// 
/// An observable navigation controller designed to manage navigation flows within SwiftUI applications. 
/// The `Router` class accommodates advanced navigation scenarios, supporting push-based navigation, modal sheet presentation, 
/// full screen covers, and tab-based navigation hierarchies. 
///
/// `Router` is designed to enable advanced navigation patterns:
/// - Deep linking and cross-tab navigation
/// - Hierarchical navigation flows (parent-child router relationships)
/// - Managing navigation stack state and active modal presentations
/// - Programmatic tab selection
///
/// ## Features
/// - Observable (supports SwiftUI data-driven navigation)
/// - Handles push, sheet, and full screen navigation
/// - Supports tab-based navigation and tab selection
/// - Maintains parent-child router relationships for nested navigation flows
///
/// ## Usage
/// Instantiate a root `Router` at the entry point of your app. 
/// For nested navigation flows (e.g., inside a tab or child screen), use `makeChildRouter(for:)`.
/// Use `navigateToRoute(_:presentationStyle:)` to perform navigation programmatically, or bind to router properties in your SwiftUI `NavigationStack`, `.sheet`, or `.fullScreenCover`.
///
/// ## Example
/// ```swift
/// let rootRouter = Router()
/// rootRouter.navigateToRoute(ProfileRoute(userID: 123))
/// ```
@Observable
public final class Router {
    
    //MARK: - Initializer
    
    /// Initializes a new `Router` instance with the specified hierarchy level and optional tab identifier.
    ///
    /// - Parameters:
    ///   - level: The hierarchy depth of this router within the navigation stack. A value of `0` indicates the root router. Defaults to `0`.
    ///   - tabIdentifier: An optional tab identifier associated with this router instance, typically used for tab-based navigation flows. If not specified, the router is not associated with any particular tab.
    ///
    /// Use this initializer to create a router at a specific level in the navigation hierarchy, optionally associating it with a particular tab for deep linking or context-aware navigation.
    public init(level: Int = 0, tabIdentifier: Tab? = nil) {
        self.level = level
        self.tabIdentifier = tabIdentifier
    }
    
    //MARK: - Properties
    
    /// The current router level in the router heriarchy. Level 0 means the root Router.
    @ObservationIgnored
    private let level: Int
    
    /// Specifies which tab the router was built for. Useful for deep linking or cross tab navigation.
    @ObservationIgnored
    private let tabIdentifier: Tab?
    
    /// The parent Router in the same Router hieriarchy.
    @ObservationIgnored
    weak private(set) var parent: Router? = nil
    
    /// The currently selected tab in the level 0 (root) Router.
    public var selectedTab: Tab?
    
    /// Navigation stack for push presentation. Can contain any presentable destination of type Hashable.
    public var path = NavigationPath()
    
    /// The currently destination presented as a sheet cover.
    public var sheetItem: AnyIdentifiable?
    
    /// The currently destination presented as a s full screen cover.
    public var fullScreenItem: AnyIdentifiable?
    
    //MARK: - Methods - actions
    
    
    /// Creates and returns a child `Router` instance associated with the next hierarchy level.
    ///
    /// - Parameter tab: An optional tab identifier to associate with the child router.
    ///   If not provided, the child router inherits the parent's `tabIdentifier`.
    ///
    /// - Returns: A new `Router` instance with its parent set to the current router,
    ///   incremented hierarchy level, and the specified or inherited tab identifier.
    ///
    /// Use this method to instantiate routers for nested navigation flows, such as
    /// when handling navigation within a particular tab or context.
    public func makeChildRouter(for tab: Tab? = nil) -> Router {
        let child = Router(level: level + 1, tabIdentifier: tab ?? tabIdentifier)
        child.parent = self
        return child
    }
    
    /// Navigates to the specified route using the given presentation style.
    ///
    /// - Parameters:
    ///   - route: The destination conforming to `AppRoute` to navigate to.
    ///   - presentationStyle: An optional `PresentationStyle` (e.g., `.push`, `.sheet`, `.fullScreen`). 
    ///     If not specified, the method uses the route's default presentation style.
    ///
    /// This method handles navigation by determining the appropriate presentation style:
    /// - For `.push`, the route is appended to the push navigation stack.
    /// - For `.sheet`, the route is presented as a modal sheet.
    /// - For `.fullScreen`, the route is shown in a full screen cover.
    ///
    /// Use this method to perform programmatic navigation to a route, optionally overriding its presentation style.
    public func navigateToRoute(_ route: any AppRoute, presentationStyle: PresentationStyle? = nil) {
        let presentationStyle = presentationStyle ?? route.presentationStyle
        switch presentationStyle {
        case .push:
            push(route)
        case .sheet:
            presentSheet(route)
        case .fullScreen:
            presentFullScreen(route)
        }
    }
    
    private func push(_ route: any AppRoute) {
        path.append(route)
    }
    
    private func presentSheet(_ route: any AppRoute) {
        sheetItem = AnyIdentifiable(route)
    }
    
    private func presentFullScreen(_ route: any AppRoute) {
        fullScreenItem = AnyIdentifiable(route)
    }
    
    /// Selects a tab within the router hierarchy.
    ///
    /// - Parameter tab: The tab identifier to select.
    ///
    /// If called on the root (`level == 0`) router, this sets the `selectedTab` property directly.
    /// For nested routers, this propagates the tab selection to the root router and resets this router's navigation state.
    /// Use this method for deep linking or cross-tab navigation to programmatically switch tabs and reset local navigation.
    public func selectTab(_ tab: Tab) {
        if level == 0 {
            selectedTab = tab
            return
        }
        parent?.selectedTab = tab
        // Router navigation state cleanup.
        resetNavigation()
    }
    
    private func resetNavigation() {
        path.removeLast(path.count)
        sheetItem = nil
        fullScreenItem = nil
    }
}

public typealias Tab = any Hashable
