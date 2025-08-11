//
//  HomeView.swift
//  DemoApp1
//
//  Created by Antonio Casto on 11/08/25.
//

import ACSwiftUINavigation
import SwiftUI

struct HomeView: View {
    var body: some View {
        List {
            Section("Basic navigation") {
                NavigationButton(route: HomeRoute.detail) {
                    Text("Navigate to detail via push")
                }
                
                NavigationButton(route: HomeRoute.sheet) {
                    Text("Navigate to sheet")
                }
                
                NavigationButton(route: HomeRoute.fullScreen) {
                    Text("Navigate to full screen")
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
