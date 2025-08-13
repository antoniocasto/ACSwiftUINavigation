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
            NavigationTab(tabId: AppTab.home)  {
                NavigationContainer(parent: router, tab: AppTab.home) {
                    HomeView()
                        .navigationTitle("Home")
                }
            } label: {
                Image(systemName: "house")
            }
            
            NavigationTab(tabId: AppTab.profile) {
                NavigationContainer(parent: router, tab: AppTab.profile) {
                    HomeView()
                        .navigationTitle("Profile")
                }
            } label: {
                Image(systemName: "person")
            }
        }
    }
}

#Preview {
    ContentView()
}
