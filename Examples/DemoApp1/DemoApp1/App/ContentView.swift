//
//  ContentView.swift
//  DemoApp1
//
//  Created by Antonio Casto on 11/08/25.
//

import ACSwiftUINavigation
import SwiftUI

enum AppTab {
    case home
    case profile
}

struct ContentView: View {
    
    @State private var router = Router()
    
    var body: some View {
        TabView(selection: $router.selectedTab) {
            NavigationContainer(parent: router, tab: AppTab.home) {
                HomeView()
                    .navigationTitle("Home")
            }
            .navigationTag(AppTab.home)
            .tabItem {
                Image(systemName: "house")
            }
            
            NavigationContainer(parent: router, tab: AppTab.profile) {
                HomeView()
                    .navigationTitle("Profile")
            }
            .navigationTag(AppTab.profile)
            .tabItem {
                Image(systemName: "person")
            }
        }
    }
}

#Preview {
    ContentView()
}
