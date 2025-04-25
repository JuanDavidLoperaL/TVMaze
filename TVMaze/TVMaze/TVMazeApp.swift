//
//  TVMazeApp.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25.
//

import SwiftUI

@main
struct TVMazeApp: App {
    
//    @AppStorage("isBiometricEnabled") private var isBiometricEnabled: Bool = false
//    @AppStorage("isPinEnabled") private var isPinEnabled: Bool = false
//    @State private var isLoggedIn = false
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainTabView()
//                if isBiometricEnabled || isPinEnabled {
//                    if isLoggedIn {
//                        MainTabView()
//                    } else {
//                        PreLoginView(
//                            viewModel: PreLoginViewModel(
//                            isPinEnable: isPinEnabled,
//                            isBiometricEnable: isBiometricEnabled),
//                            isLoggedIn: $isLoggedIn
//                        )
//                    }
//                } else {
//                    MainTabView()
//                }
            }
        }
    }
}
