//
//  HomeRoute.swift
//  DemoApp1
//
//  Created by Antonio Casto on 11/08/25.
//

import ACSwiftUINavigation
import Foundation
import SwiftUI

enum HomeRoute: String, AppRoute {
    typealias InputPayload = Void
    
    case detail
    case sheet
    case fullScreen
    
    var id: String {
        "HomeRoute." + self.rawValue
    }
    
    var presentationStyle: PresentationStyle {
        switch self {
        case .detail:
                .push
        case .sheet:
                .sheet
        case .fullScreen:
                .fullScreen
        }
    }
    
    func buildView() -> any View {
        switch self {
        case .detail:
            HomeDetail()
        case .sheet:
            HomeSheet()
        case .fullScreen:
            HomeFullScreen()
        }
    }
}
