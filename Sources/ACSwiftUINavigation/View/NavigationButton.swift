//
//  NavigationButton.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import SwiftUI

/// A button that triggers navigation to a specified route using a router.
/// 
/// Use `NavigationButton` to integrate navigation actions into your view hierarchy. When tapped, this button uses the nearest `Router` environment object to present the provided route, supporting various presentation styles such as push, sheet, or full screen cover.
/// 
/// - Generic Parameter:
///   - Label: The type of view used for the button's label.
/// 
/// The label for the button can be fully customized using a view builder. Optionally, you can specify a custom presentation style, or allow the route's default style to be used.
///
/// Example usage:
/// ```swift
/// NavigationButton(route: MyRoute()) {
///     Label("Navigate", systemImage: "arrow.right")
/// }
/// ```
///
/// > Note: This button requires a `Router` instance to be present in the environment, typically provided at an appropriate level in your view hierarchy.
public struct NavigationButton<Label: View>: View {
    //MARK: - Initializer
    
    /// Creates a navigation button configured to navigate to the specified destination route.
    ///
    /// - Parameters:
    ///   - route: An object conforming to `AppRoute` that specifies the navigation target.
    ///   - presentationStyle: The presentation style to use for the navigation action (e.g., push, sheet, fullScreenCover). If not provided, the route's default style is used.
    ///   - label: A view builder that constructs the button's visual label.
    ///
    /// Use this initializer to create a `NavigationButton` that, when tapped, directs the router to present the given destination. The label parameter lets you customize the button's appearance.
    public init(route: any AppRoute,
                presentationStyle: PresentationStyle? = nil,
                @ViewBuilder label: () -> Label) {
        self.route = route
        self.presentationStyle = presentationStyle
        self.label = label()
    }
    
    //MARK: - Properties
    
    /// The inherited closest Router in the hierarchy.
    @Environment(Router.self) var router: Router
    
    private let route: any AppRoute
    private let presentationStyle: PresentationStyle?
    private let label: Label
    
    public var body: some View {
        Button {
            router.navigateToRoute(route, presentationStyle: presentationStyle)
        } label: {
            label
        }
    }
}
