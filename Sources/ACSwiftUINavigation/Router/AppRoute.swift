//
//  AppRoute.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import SwiftUI

protocol AppRoute {
    @ViewBuilder
    func buildView() -> AnyView
}
