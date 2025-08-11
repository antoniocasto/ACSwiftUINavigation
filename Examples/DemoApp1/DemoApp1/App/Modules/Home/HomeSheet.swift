//
//  HomeSheet.swift
//  DemoApp1
//
//  Created by Antonio Casto on 11/08/25.
//

import ACSwiftUINavigation
import SwiftUI

struct HomeSheet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(spacing: 26.0) {
                NavigationButton(route: HomeRoute.detail) {
                    Text("Push a nested detail")
                }
                
                NavigationButton(route: HomeRoute.sheet) {
                    Text("Present a nested sheet")
                }
                
                NavigationButton(route: HomeRoute.fullScreen) {
                    Text("Present a nested full screen")
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationTitle("HomeFullScreen")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                   dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
            }
        }
    }
}

#Preview {
    HomeSheet()
}
