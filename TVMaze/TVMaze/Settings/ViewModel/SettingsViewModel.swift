//
//  SettingsViewModel.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import LocalAuthentication
import Foundation

final class SettingsViewModel: ObservableObject {
    
    @Published var showAlert: Bool = false
    @Published var isBiometricEnabled: Bool = UserDefaults.standard.bool(forKey: "isBiometricEnabled")
    @Published var isPinEnabled: Bool = UserDefaults.standard.bool(forKey: "isPinEnabled")
    @Published var showPinSetup = false
    
    var alertTitle: String {
        return "Biometric Error"
    }
    
    var alertDescription: String {
        return "Where we not able to find the biometric type of your device."
    }
    
    func getBiometrciType() -> LABiometryType {
        let biometricType = BiometricHelper.shared.getBiometrciType()
        showAlert = biometricType == .none ? true : false
        return biometricType
    }
    
    func isPinEnable(value: Bool) {
        if value {
            isPinEnabled = true
            isBiometricEnabled = false
            UserDefaults.standard.set(true, forKey: "isPinEnabled")
            UserDefaults.standard.set(false, forKey: "isBiometricEnabled")
            showPinSetup = value
        } else {
            isPinEnabled = false
            UserDefaults.standard.set(false, forKey: "isPinEnabled")
            UserDefaults.standard.set("", forKey: "storedPin")
        }
    }
    
    func isBiometriEnable(value: Bool) {
        if value && (getBiometrciType() == .none) {
            isBiometricEnabled = false
            showAlert = true
            return
        }
        if value {
            isPinEnabled = false
            isBiometricEnabled = true
            UserDefaults.standard.set(false, forKey: "isPinEnabled")
            UserDefaults.standard.set(true, forKey: "isBiometricEnabled")
            UserDefaults.standard.set("", forKey: "storedPin")
        } else {
            isBiometricEnabled = false
            UserDefaults.standard.set(false, forKey: "isBiometricEnabled")
        }
    }
}
