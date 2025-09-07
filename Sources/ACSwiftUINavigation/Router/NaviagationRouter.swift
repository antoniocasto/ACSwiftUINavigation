//
//  NavigationRouter.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/2025.
//

import Observation
import SwiftUI

/// `NavigationRouter` is an observable navigation coordinator for SwiftUI applications, managing hierarchical navigation flows and supporting  stack-based, tab-based and modal-based navigation patterns.
///
/// This class enables deep linking, cross-tab routing, and context-aware navigation by allowing each tab or presentation context to maintain its own independent navigation stack. 
/// Designed to be used as a shared environment object, the router manages navigation paths, modals, and selected tabs, supporting complex navigation flows in large applications.
///
/// ## Usage
/// - Use the root `NavigationRouter` (`level == 0`) to manage global navigation state, such as tab selection.
/// - Create child routers for each tab or modal flow using `makeChildRouter(for:)`, enabling each part of the UI to have its own navigation context.
/// - Trigger programmatic navigation using `navigateToRoute(_:presentationStyle:)`.
/// - Support deep linking or custom navigation flows state building with `selectTab(_:navigationRoutes:)` and `buildNavigationIfAny(routes:)`.
///
/// ## Features
/// - Hierarchical navigation coordination using a level-based structure.
/// - Support for tab-based navigation, with independent stacks per tab.
/// - Modal presentations (sheet and full screen).
/// - Deep linking and building of multi-level navigation stacks.
/// - Designed for SwiftUI, leveraging `@Observable` for reactive updates.
///
/// ## Example
/// ```swift
/// let rootRouter = NavigationRouter()
/// let homeRouter = rootRouter.makeChildRouter(for: .home)
/// homeRouter.navigateToRoute(MyHomeRoute())
/// rootRouter.selectTab(.profile, navigationRoutes: [ProfileRoute(), SettingsRoute()])
/// ```
@Observable
public final class NavigationRouter {
    //MARK: - Initializer
    
    /// Initializes a new `NavigationRouter` instance with the specified hierarchy level and optional tab identifier.
    ///
    /// - Parameters:
    ///   - level: The hierarchy depth of this router within the navigation stack. A value of `0` indicates the root router. Defaults to `0`.
    ///   - tabIdentifier: An optional tab identifier representing the tab where the navigation happens using this router instance, typically used for tab-based navigation flows. If not specified, the router is not associated with any particular tab.
    ///
    /// Use this initializer to create a router at a specific level in the navigation hierarchy, optionally associating it with a particular tab for deep linking or context-aware navigation.
    public init(level: Int = 0, tabIdentifier: TabValue? = nil) {
        self.level = level
        self.tabIdentifier = tabIdentifier
    }
    
    //MARK: - Properties
    
    /// Wether the current Router is related to the active navigation flow. It is used to make the active Router the current entity
    /// the only one responsible to handle deep links.
    @ObservationIgnored
    private var isActive = false
    
    /// The current router level in the router heriarchy. Level 0 means the root Router.
    @ObservationIgnored
    private let level: Int
    
    /// Specifies which tab the router was built for. Useful for deep linking or cross tab navigation.
    @ObservationIgnored
    private let tabIdentifier: TabValue?
    
    /// The parent Router in the same Router hieriarchy.
    @ObservationIgnored
    weak private(set) var parent: NavigationRouter? = nil
    
    /// Stores child routers corresponding to each tab identifier.
    @ObservationIgnored
    private var tabRouters: [AnyHashable: NavigationRouter] = [:]
    
    /// The currently selected tab in the level 0 (root) Router.
    public var selectedTab: AnyHashable?
    
    /// Navigation stack for push presentation. Can contain any presentable destination of type Hashable.
    public var path = NavigationPath()
    
    /// The currently destination presented as a sheet cover.
    public var sheetItem: AnyIdentifiable?
    
    /// The currently destination presented as a s full screen cover.
    public var fullScreenItem: AnyIdentifiable?
    
    //MARK: - Methods - actions
    
    /// Creates and returns a new child `NavigationRouter` instance, optionally associated with a specific tab.
    ///
    /// - Parameter tab: An optional tab identifier (`TabValue`) to associate with the child router. Passing a tab identifier allows the creation of navigation hierarchies in tab-based navigation flows, such that each tab can maintain its own independent navigation stack. If not specified, the child router will inherit the current router’s tab association (if any).
    ///
    /// - Returns: A new `NavigationRouter` instance representing a child in the navigation hierarchy. The child router’s `parent` property is automatically set to the current router. If a tab identifier is provided, the child router is registered in the parent router’s `tabRouters` dictionary using the tab as the key, enabling easy retrieval and tab-based navigation coordination.
    ///
    /// - Note: Use this method to create nested navigation contexts (such as for individual tabs or modal flows) within your SwiftUI application. When working with tab-based navigation, each tab should have its own child router created and registered with its respective tab identifier.
    public func makeChildRouter(for tab: TabValue? = nil) -> NavigationRouter {
        let childRouter = NavigationRouter(level: level + 1, tabIdentifier: tab ?? tabIdentifier)
        childRouter.parent = self
        
        // Each Router registers one or more children.
        if let tab = tab {
            tabRouters[AnyHashable(tab)] = childRouter
        }
        
        return childRouter
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
        path.append(AnyHashable(route))
    }
    
    private func presentSheet(_ route: any AppRoute) {
        sheetItem = AnyIdentifiable(route)
    }
    
    private func presentFullScreen(_ route: any AppRoute) {
        fullScreenItem = AnyIdentifiable(route)
    }
    
    /// Selects a tab and optionally builds a navigation flow for that tab.
    ///
    /// - Parameters:
    ///   - tab: The tab identifier to select. This identifier is typically used in tab-based navigation patterns to represent the desired active tab.
    ///   - routes: An array of routes (`[any AppRoute]`) representing the navigation sequence to execute for the newly selected tab. If provided, the navigation stack for the tab is configured to match the sequence of routes.
    ///
    /// This method programmatically switches to the specified tab and, if routes are provided, constructs the navigation stack for that tab.
    ///
    /// - If called on the root router (`level == 0`), it sets the selected tab and, if a child router exists for that tab, instructs the child router to build its navigation stack based on the provided routes.
    /// - For non-root routers, the call is delegated up the parent chain until it reaches the root router. After delegating, the current router’s own navigation state is reset.
    ///
    /// Use this method to perform cross-tab navigation, deep linking, or to restore navigation state when switching tabs.
    ///
    /// - Note: If no child router exists for the target tab, only tab selection will occur and no additional navigation will be performed.
    public func selectTab(_ tab: TabValue, navigationRoutes routes: [any AppRoute] = []) {
        if level == 0 {
            selectedTab = AnyHashable(tab)
            // Builds navigation flow on child Router
            childRouter(for: tab)?.buildNavigationIfAny(routes: routes)
            return
        }
        parent?.selectTab(tab, navigationRoutes: routes)
        // Current Router navigation state cleanup for level 1 Routers.
        resetNavigation()
    }
    
    /// Recursively builds and executes a navigation flow for the given array of routes.
    ///
    /// - Parameter routes: An array of routes (`[any AppRoute]`) representing the navigation sequence to execute for this router and its child routers.
    ///
    /// This method is typically used to programmatically construct a navigation path—including deep linking—by advancing through each route in the array:
    /// - If the current router is associated with a tab (`tabIdentifier` is not `nil`) and there is at least one route in the array, the method:
    ///   1. Removes and navigates to the first route using `navigateToRoute(_:)`.
    ///   2. Attempts to find a child router for the current tab. If none exists, the current router is used.
    ///   3. Recursively calls itself on the appropriate child router (or self) with the remaining routes.
    ///
    /// - Important: This method will only perform navigation if the router is associated with a tab and the routes array is not empty.
    /// - Note: This enables multi-level navigation, such as progressing through a stack of screens or handling deep links that span nested navigation hierarchies.
    func buildNavigationIfAny(routes: [any AppRoute]) {
        guard let tab = tabIdentifier,
              routes.count > 0 else { return }
        var routes = routes
        let routeToNavigate = routes.removeFirst()
        
        navigateToRoute(routeToNavigate)
        
        let routerToNavigate = childRouter(for: tab) ?? self
        routerToNavigate.buildNavigationIfAny(routes: routes)
    }
    
    private func resetNavigation() {
        path.removeLast(path.count)
        sheetItem = nil
        fullScreenItem = nil
    }
    
    private func childRouter(for tab: TabValue) -> NavigationRouter? {
        tabRouters[AnyHashable(tab)]
    }
    
    /// Sets the active state for the current `NavigationRouter` instance.
    ///
    /// - Parameter isActive: A Boolean value indicating whether this router should be marked as active (`true`) or inactive (`false`).
    ///
    /// Marking a router as active designates it as the primary handler for deep links.
    /// Only one router instance in the navigation hierarchy should typically be active at a time to ensure correct coordination deep link events.
    ///
    /// - Note: This method is intended for internal use by navigation controllers or coordination logic managing the router hierarchy. Directly setting the active state can affect which router responds to navigation or deep linking actions.
    public func setActive(_ isActive: Bool) {
        self.isActive = isActive
    }
}

public typealias TabValue = any Hashable
