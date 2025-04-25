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
}
