//
//  PresentationStyle.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 10/08/25.
//

import Foundation

/// A style that determines how a view is presented in the navigation flow.
///
/// - `push`: Presents the destination by pushing it onto a navigation stack.
/// - `sheet`: Presents the destination modally as a sheet.
/// - `fullScreen`: Presents the destination modally in a full-screen view.
public enum PresentationStyle {
    case push
    case sheet
    case fullScreen
}
