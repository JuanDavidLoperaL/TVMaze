//
//  TVMazeApp.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25.
//

import SwiftUI

@main
struct TVMazeApp: App {
    
    private var isBiometricEnabled: Bool = UserDefaults.standard.bool(forKey: "isBiometricEnabled")
    private var isPinEnabled: Bool = UserDefaults.standard.bool(forKey: "isPinEnabled")
    @State private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isBiometricEnabled || isPinEnabled {
                    if isLoggedIn {
                        MainTabView()
                    } else {
                        PreLoginView(
                            viewModel: PreLoginViewModel(
                            isPinEnable: isPinEnabled,
                            isBiometricEnable: isBiometricEnabled),
                            isLoggedIn: $isLoggedIn
                        )
                    }
                } else {
                    MainTabView()
                }
            }
        }
    }
}
