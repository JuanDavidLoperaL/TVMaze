//
//  BiometricHelper.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import LocalAuthentication
import Foundation

final class BiometricHelper {
    
    private let context = LAContext()
    private var error: NSError?
    static let shared: BiometricHelper = BiometricHelper()
    
    private init() {}
    
    func getBiometrciType() -> LABiometryType {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return context.biometryType
        }
        return .none
    }
    
    func authenticateUser(completionHandler: @escaping(Bool) -> Void) {
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            var title = ""
            switch getBiometrciType() {
            case .faceID:
                title = "Please use Face ID to continue."
            case .touchID:
                title = "Please use touch ID to continue."
            case .opticID:
                title = "Please use optic ID to continue."
            case .none:
                break
            }
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: title) { success, error in
                DispatchQueue.main.async {
                    completionHandler(success)
                }
            }
        } else {
            print("Biometric no available: \(error?.localizedDescription ?? "unknown")")
            completionHandler(false)
        }
    }
}
