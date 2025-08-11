//
//  AppRoute.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import SwiftUI


/// A protocol that defines a navigation route within an application.
/// 
/// Conforming types represent a destination that can be presented or pushed within a navigation stack,
/// providing a SwiftUI view and presentation style. Routes are expected to be uniquely identifiable and hashable,
/// allowing them to be managed in navigation collections.
/// 
/// - Requires:
///    - Conformance to `Identifiable` and `Hashable` for proper collection management and identity.
///    - A property indicating the presentation style (e.g., push, modal).
///    - A method for constructing the destination view wrapped in `AnyView`.
/// 
/// - Note: This protocol leverages SwiftUI's `@ViewBuilder` for view construction, enabling the composition
///         of complex views as navigation destinations. Platform availability for SwiftUI types may be required.
///
public protocol AppRoute: Identifiable, Hashable {
    //MARK: - Properties
    
    var presentationStyle: PresentationStyle { get }
    
    //MARK: - Methods
    
    @ViewBuilder
    func buildView() -> any View
}
