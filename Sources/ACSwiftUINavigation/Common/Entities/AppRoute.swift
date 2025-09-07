//
//  AppRoute.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import SwiftUI


/// A protocol representing a navigation route in an app, suitable for supported navigation models.
///
/// Conforming types define a destination or navigation endpoint, including the presentation style and a way to build the destination view.
/// 
/// - Note: `AppRoute` is intended to be used as the fundamental abstraction for routing and navigation within an app. It requires conformance to `Identifiable`, `Hashable`, and `Sendable` to support value semantics, identity, and safety across concurrency domains.
///
public protocol AppRoute: Identifiable, Hashable, Sendable {
    /// The type of data required to initialize or perform the route.
    ///
    /// Use `Void` if the route does not require any specific payload.
    associatedtype InputPayload: Sendable
    
    //MARK: - Properties
    
    /// The presentation style to use for this route.
    ///
    /// This defines how the destination should be presented (e.g., pushed, sheet, full screen, etc.).
    var presentationStyle: PresentationStyle { get }
    
    //MARK: - Methods
    
    /// Builds and returns the SwiftUI view associated with this route.
    ///
    /// This method should construct the view hierarchy representing the destination for this route.
    /// It can capture any state or data needed to render the view.
    ///
    /// - Returns: An instance conforming to `View` that represents the route's destination.
    @ViewBuilder
    func buildView() -> any View
}
