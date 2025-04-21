//
//  MainTabView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab: TabOptions = .series

    var body: some View {
        TabView(selection: $selectedTab) {
            // This will be replaced with Characters View
            ContentView()
                .tabItem {
                    Label("Characters", systemImage: "person.fill")
                }
                .tag(TabOptions.characters)
            // This will be replaced with Series View
            ContentView()
                .tabItem {
                    Label("Series", systemImage: "movieclapper.fill")
                }
                .tag(TabOptions.series)
            // This will be replaced with Settings View
            ContentView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(TabOptions.settings)
        }
    }
}

#Preview {
    MainTabView()
}
