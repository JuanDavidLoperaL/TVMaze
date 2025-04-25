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
            SettingsView()
                .tabItem {
                    Label("Characters", systemImage: "person.fill")
                }
                .tag(TabOptions.characters)

            SeriesView()
                .tabItem {
                    Label("Series", systemImage: "movieclapper.fill")
                }
                .tag(TabOptions.series)
            
            SettingsView()
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
