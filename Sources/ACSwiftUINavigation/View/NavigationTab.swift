//
//  NavigationTab.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 11/08/25.
//

import SwiftUI

/// A container view that wraps content and provides integration with SwiftUI's tab navigation system.
///
/// `NavigationTab` is designed to be used inside a `TabView`. It assigns a unique tab identifier (`tabId`)
/// and a tab item label to its content, enabling type-safe and ergonomic tab construction with custom content and labels.
///
/// - Note: The `tabId` is typically a value conforming to `Hashable` (often a `String`, `Int`, or an enum),
///   which is internally stored as `AnyHashable`. This allows selection of tabs in a `TabView` using a binding.
///
/// - Parameters:
///   - Content: The main view content of the tab, provided via a `@ViewBuilder` closure.
///   - Label: The visual representation of the tab item, such as a `Text` or `Label`, also provided via a closure.
///
/// - Example:
/// ```swift
/// @State private var selected: AnyHashable? = "home"
/// TabView(selection: $selected) {
///     NavigationTab(tabId: "home") {
///         Text("Home Screen")
///     } label: {
///         Label("Home", systemImage: "house")
///     }
///     NavigationTab(tabId: "settings") {
///         Text("Settings Screen")
///     } label: {
///         Label("Settings", systemImage: "gear")
///     }
/// }
/// ```
///
/// Use this structure when you want to modularize tab content and labels with a standardized API,
/// while leveraging SwiftUI's native tab selection and presentation mechanisms.
public struct NavigationTab<Content: View, Label: View>: View {
    //MARK: - Initializer
    
    public init(tabId: TabValue? = nil,
                @ViewBuilder content: @escaping () -> Content,
                label: @escaping () -> Label = { EmptyView() }) {
        if let tabId = tabId {
            self.tabId = AnyHashable(tabId)
        }
        self.content = content
        self.label = label
    }
    
    //MARK: - Properties
    
    var tabId: AnyHashable?
    let content: () -> Content
    let label: () -> Label
    
    public var body: some View {
        content()
            .tag(tabId)
            .tabItem(label)
    }
}


#Preview {
    @Previewable 
    @State var selectedTab: AnyHashable? = "settings"
    
    TabView(selection: $selectedTab) {
        NavigationTab(tabId: "house") {
            Text("Home")
        } label: {
            Label("Home", systemImage: "house")
        }
        NavigationTab(tabId: "settings") {
            Text("Settings")
        } label: {
            Label("Settings", systemImage: "gear")
        }
    }
}
