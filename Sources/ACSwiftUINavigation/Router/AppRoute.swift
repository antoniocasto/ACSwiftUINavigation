//
//  AppRoute.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import SwiftUI

/// A protocol for Views representing a Router valid destination.
protocol AppRoute {
    @ViewBuilder
    func buildView() -> AnyView
}
