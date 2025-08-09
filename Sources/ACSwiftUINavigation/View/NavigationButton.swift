//
//  NavigationButton.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import SwiftUI

/// A customizable navigation button that interacts with an inherited `Router` to present destination routes using different presentation styles.
///
/// `NavigationButton` allows navigation to a specified destination conforming to `AppRoute`, using styles such as push, sheet, or full screen presentation.
/// The view label is provided through a `@ViewBuilder` closure, enabling flexible button appearance.
///
/// Example usage:
/// ```swift
/// NavigationButton(destination: SomeRoute()) {
///     Text("Navigate")
/// }
/// ```
///
/// - Note: The button requires a `Router` to be available in the environment.
///
/// - Parameters:
///   - destination: The route to navigate to, conforming to `AppRoute`.
///   - presentationStyle: How to present the destination (push, sheet, or full screen).
///   - label: A view builder for the button’s label.
public struct NavigationButton<Label: View>: View {
    //MARK: - Initializer
    
    /// Creates a navigation button that presents a destination route using the specified presentation style.
    ///
    /// - Parameters:
    ///   - destination: The destination route to navigate to. Must conform to `AppRoute`.
    ///   - presentationStyle: The way in which the destination should be presented (push, sheet, or full screen). Defaults to `.push`.
    ///   - label: A view builder closure that generates the button's label.
    public init(destination: any AppRoute,
                presentationStyle: PresentationStyle = .push,
                @ViewBuilder label: () -> Label) {
        self.destination = destination
        self.presentationStyle = presentationStyle
        self.label = label()
    }
    
    //MARK: - Properties
    
    /// The inherited closest Router in the hierarchy.
    @Environment(Router.self) var router: Router
    
    private let destination: any AppRoute
    private let presentationStyle: PresentationStyle
    private let label: Label
    
    public var body: some View {
        Button {
            presentDestination()
        } label: {
            label
        }
    }
    
    //MARK: - Methods - actions
    
    private func presentDestination() {
        switch presentationStyle {
        case .push:
            router.push(destination)
        case .sheet:
            router.presentSheet(destination)
        case .fullScreen:
            router.presentFullScreen(destination)
        }
    }
}

extension NavigationButton {
    public enum PresentationStyle {
        case push
        case sheet
        case fullScreen
    }
}
