//
//  NavigationContainer.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import Observation
import SwiftUI

/// A container view that manages navigation state for its child views.
///
/// `NavigationContainer` provides a navigation stack using a custom `Router` instance.
/// It handles navigation paths, modal presentations (sheets and full screen covers),
/// and injects the router into the environment for use by descendant views.
///
/// Use this container to encapsulate navigation and modal flows within a specific scope,
/// optionally providing tab-specific navigation state.
///
/// - Note: All navigation destinations must conform to `AppRoute`,
///   and modal destinations must conform to both `AppRoute` and `Identifiable`.
///
/// - Parameters:
///   - Content: The type of view content to display within the container.
///
public struct NavigationContainer<Content: View>: View {
    //MARK: - Initializer
    
    /// Initializes a new `NavigationContainer` with a parent `Router`, an optional `Tab`, and the content to display.
    ///
    /// - Parameters:
    ///   - parent: The parent `Router` instance used to generate state for the current navigation container.
    ///   - tab: An optional `TabValue` specifying the tab context for the child router. Defaults to `nil`.
    ///   - content: A `ViewBuilder` closure that provides the content view to display inside the container.
    public init(parent: Router, tab: TabValue? = nil, @ViewBuilder content: () -> Content) {
        self._router = State(initialValue: parent.makeChildRouter(for: tab))
        self.content = content()
    }
    
    //MARK: - Properties
    
    /// The router containing the state for the current NavigationContainer
    @State var router: Router
    
    // The injected screen to be displayed.
    private let content: Content
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: AnyHashable.self) { destination in
                    AnyView(buildNavigationDestinationView(for: destination))
                }
        }
        .sheet(item: $router.sheetItem) { destination in
            NavigationContainer<AnyView>(parent: router) {
                AnyView(buildModalDestinationView(for: destination))
            }
        }
        .fullScreenCover(item: $router.fullScreenItem) { destination in
            NavigationContainer<AnyView>(parent: router) {
                AnyView(buildModalDestinationView(for: destination))
            }
        }
        .environment(router)
        .onAppear {
            router.setActive(true)
        }
        .onDisappear {
            router.setActive(false)
        }
    }
    
    //MARK: - Methods
    
    /// Builds the destination view for a given navigation route.
    ///
    /// This method is used by the `NavigationStack` to resolve a navigation destination based on the
    /// provided `AnyHashable` value. It attempts to cast the `AnyHashable`'s underlying value to an
    /// `AppRoute`-conforming type and invokes its `buildView()` method to generate the corresponding view.
    ///
    /// - Parameter destination: An `AnyHashable` value representing a navigation destination,
    ///   expected to wrap an object conforming to the `AppRoute` protocol.
    /// - Returns: The SwiftUI `View` associated with the provided navigation route.
    /// - Note: If the destination cannot be cast to `AppRoute`, this method triggers a runtime error.
    /// - Warning: Passing unsupported destination types will cause a fatal error.
    private func buildNavigationDestinationView(for destination: AnyHashable) -> any View {
        guard let route = destination.base as? any AppRoute
        else { fatalError("Implementation error: Unsupported destination type.") }
        return route.buildView()
    }
    
    /// Builds the modal destination view for a given modal route.
    ///
    /// This method is used by modal presentation APIs (such as `.sheet` or `.fullScreenCover`)
    /// to resolve the content view for a modal destination based on an `AnyIdentifiable` value.
    ///
    /// - Parameter destination: An `AnyIdentifiable` value representing the modal destination,
    ///   expected to conform to the `AppRoute` protocol.
    /// - Returns: The SwiftUI `View` associated with the provided modal route.
    /// - Note: If the destination cannot be cast to `AppRoute`, this method triggers a runtime error.
    /// - Warning: Only pass destination types that conform to `AppRoute`; passing unsupported types will cause a fatal error.
    private func buildModalDestinationView(for destination: AnyIdentifiable) -> any View {
        guard let route = destination.wrapped as? any AppRoute
        else { fatalError("Implementation error: Unsupported destination type.") }
        return route.buildView()
    }
}

#Preview {
    @Previewable @State var router = Router()
    NavigationContainer(parent: router) {
        Text("ContentView")
    }
}
