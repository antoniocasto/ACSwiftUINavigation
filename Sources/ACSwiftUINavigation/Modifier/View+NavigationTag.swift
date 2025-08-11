//
//  View+NavigationTab.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 11/08/25.
//

import SwiftUI

/// A view modifier that assigns a navigation or tab tag to a view using a specified `TabValue`.
///
/// Use `NavigationTagModifier` to tag a view for use within navigation or tab selection mechanisms,
/// enabling the identification and selection of views based on their associated tag values.
/// This modifier wraps the SwiftUI `.tag(_:)` modifier, converting the provided `TabValue` into an `AnyHashable`
/// to maintain compatibility across different navigation or tab view contexts.
///
/// Example usage:
/// ```swift
/// Text("Profile")
///     .modifier(NavigationTagModifier(tagValue: .profile))
/// ```
///
/// - Note: Typically used in conjunction with the `.navigationTag(_:)` view extension for more concise syntax.
///
/// - Parameter tagValue: The value used to identify this view for navigation or tab selection.
struct NavigationTagModifier: ViewModifier {
    //MARK: - Properties
    
    let tagValue: TabValue
    
    //MARK: - Methods
    
    func body(content: Content) -> some View {
        content
            .tag(AnyHashable(tagValue))
    }
}

extension View {
    /// Assigns a navigation or tab tag to the view, allowing it to be used with navigation or tab selection mechanisms.
    ///
    /// Use this modifier to tag a view within a navigation or tab view, enabling selection and identification of views based on their associated `TabValue`.
    ///
    /// - Parameter tagValue: The value used to identify this view for navigation or tab selection.
    /// - Returns: A view tagged with the specified value for navigation or tab selection.
    ///
    /// Example usage:
    /// ```swift
    /// Text("Home")
    ///     .navigationTag(.home)
    /// ```
    public func navigationTag(_ tagValue: TabValue) -> some View {
        modifier(NavigationTagModifier(tagValue: tagValue))
    }
}

