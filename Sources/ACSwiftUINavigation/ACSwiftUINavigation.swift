//
//  ACSwiftUINavigation.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/2025.
//

import Observation
import SwiftUI

@Observable
public final class Router<Tab: Hashable> {
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
    public private(set) var selectedTab: Tab?
    
    /// Navigation stack for push presentation. Can contain any presentable destination of type Hashable.
    public private(set) var path = NavigationPath()
    
    /// The currently destination presented as a sheet cover.
    public private(set) var sheetItem: AnyIdentifiable?
    
    /// The currently destination presented as a s full screen cover.
    public private(set) var fullScreenItem: AnyIdentifiable?
    
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
    func makeChildRouter(for tab: Tab? = nil) -> Router {
        let child = Router(level: level + 1, tabIdentifier: tab ?? tabIdentifier)
        child.parent = self
        return child
    }
}
