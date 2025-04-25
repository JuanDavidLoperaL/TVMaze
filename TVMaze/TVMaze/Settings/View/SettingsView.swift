//
//  SettingsView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 23/04/25.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var viewModel: SettingsViewModel = SettingsViewModel()
    @AppStorage("isPinEnabled") private var isPinEnabled: Bool = false
    @AppStorage("storePin") private var storePin: String = ""
    @AppStorage("isBiometricEnabled") private var isBiometricEnabled: Bool = false
    @State private var showPinSetup = false

    var body: some View {
        Form {
            Section(header: Text("Security")) {
                Toggle(isOn: $showPinSetup) {
                    Label("Activate PIN", systemImage: "lock.fill")
                }
                .onChange(of: showPinSetup) { value in
                    if value {
                        isBiometricEnabled = false
                    } else {
                        isPinEnabled = false
                        storePin = ""
                    }
                }
                Toggle(isOn: $isBiometricEnabled) {
                    Label("Activate Biometric", systemImage: "faceid")
                }
                .onChange(of: isBiometricEnabled) { value in
                    if value {
                        if viewModel.getBiometrciType() != .none {
                            isPinEnabled = false
                            storePin = ""
                            isBiometricEnabled = true
                        } else {
                            isBiometricEnabled = false
                        }
                    } else {
                        isBiometricEnabled = false
                    }
                }
            }
        }
        .navigationTitle("Configuración")
        .sheet(isPresented: $showPinSetup) {
            ActivePinSetupView()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.alertTitle),
                  message: Text(viewModel.alertDescription),
                  dismissButton: .default(Text("OK")))
        }
        .onChange(of: storePin) { oldValue, newValue in
            if newValue.isEmpty {
                isPinEnabled = false
                storePin = newValue
                print(storePin)
            }
        }
    }
}

#Preview {
    SettingsView()
}
