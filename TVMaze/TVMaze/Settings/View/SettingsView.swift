//
//  SettingsView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 23/04/25.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel = SettingsViewModel()
    @State private var showPinSetup = false

    var body: some View {
        Form {
            Section(header: Text("Security")) {
                Toggle(isOn: $viewModel.isPinEnabled) {
                    Label("Activate PIN", systemImage: "lock.fill")
                }
                .onChange(of: viewModel.isPinEnabled) { value in
                    viewModel.isPinEnable(value: value)
                }
                Toggle(isOn: $viewModel.isBiometricEnabled) {
                    Label("Activate Biometric", systemImage: "faceid")
                }
                .onChange(of: viewModel.isBiometricEnabled) { value in
                    viewModel.isBiometriEnable(value: value)
                }
            }
        }
        .navigationTitle("Configuración")
        .sheet(isPresented: $viewModel.showPinSetup) {
            ActivePinSetupView(isPinEnable: $viewModel.isPinEnabled)
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.alertTitle),
                  message: Text(viewModel.alertDescription),
                  dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    SettingsView()
}
