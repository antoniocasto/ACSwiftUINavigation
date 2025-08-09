//
//  ACSwiftUINavigation.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/2025.
//

import Observation
import SwiftUI

@Observable
public final class Router {
    
    //MARK: - Initializer
    
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
    
    /// Pushes a new route onto the navigation stack.
    ///
    /// - Parameter route: The route to be pushed onto the navigation stack. Must conform to the `AppRoute` protocol.
    ///
    /// This method appends the specified route to the navigation `path`, causing a navigation action to occur.
    /// Use this to perform traditional push-style navigation within the current context.
    public func push(_ route: any AppRoute) {
        path.append(route)
    }
    
    /// Presents the specified route as a sheet.
    ///
    /// - Parameter route: The destination to be presented as a modal sheet. Must conform to the `AppRoute` protocol.
    ///
    /// This method sets the `sheetItem` property with an identifiable wrapper around the provided route,
    /// triggering the presentation of a sheet in the navigation UI. Use this to display modal content
    /// over the current view hierarchy.
    public func presentSheet(_ route: any AppRoute) {
        sheetItem = AnyIdentifiable(route)
    }
    
    /// Presents the specified route as a full screen cover.
    ///
    /// - Parameter route: The destination to be presented as a full screen cover. Must conform to the `AppRoute` protocol.
    ///
    /// This method sets the `fullScreenItem` property with an identifiable wrapper around the provided route,
    /// triggering the presentation of a full screen cover in the navigation UI. Use this to display modal content
    /// in a full screen overlay above the current view hierarchy.
    public func presentFullScreen(_ route: any AppRoute) {
        sheetItem = AnyIdentifiable(route)
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
