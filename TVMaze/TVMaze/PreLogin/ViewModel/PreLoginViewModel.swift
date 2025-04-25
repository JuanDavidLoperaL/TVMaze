//
//  PreLoginViewModel.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import SwiftUI
import Foundation

final class PreLoginViewModel: ObservableObject {
    
    enum StateView {
        case pin
        case biometric
    }
    
    // MARK: - Private Properties
    private var isPinEnable: Bool
    private var isBiometricEnable: Bool
    
    // MARK: - Internal Properties
    var onLoginSuccess: (() -> Void)?
    
    // MARK: - Internal Init
    init(isPinEnable: Bool, isBiometricEnable: Bool) {
        self.isPinEnable = isPinEnable
        self.isBiometricEnable = isBiometricEnable
        preparePreLogin()
    }
    
    // MARK: - Wrapper Properties
    @Published var viewState: StateView = .pin
    @Published var pin: String = ""
    @Published var showAlert: Bool = false
    @Published var isValidationSuccessful: Bool = false
    @AppStorage("storePin") private var storePin: String = ""
    
    var buttonTitle: String {
        if isPinEnable {
            return "Submit PIN"
        }
        let biometricType = BiometricHelper.shared.getBiometrciType()
        if biometricType == .faceID {
            return "Authenticate with FaceID"
        }
        if biometricType == .touchID {
            return "Authenticate with TouchID"
        }
        return "Authenticate with opticID"
    }
}

// MARK: - Internal Function
extension PreLoginViewModel {
    func validate(completionHandler: @escaping() -> Void) {
        if isPinEnable {
            validatePIN()
            completionHandler()
        } else {
            validateBiometric(completionHandler: completionHandler)
        }
    }
}

// MARK: - Private Function
private extension PreLoginViewModel {
    func validatePIN() {
        guard storePin == pin else {
            showAlert = true
            return
        }
        showAlert = false
        isValidationSuccessful = true
    }
    
    func validateBiometric(completionHandler: @escaping() -> Void) {
        BiometricHelper.shared.authenticateUser { [weak self] isSuccess in
            self?.showAlert = !isSuccess
            self?.isValidationSuccessful = isSuccess
            completionHandler()
        }
    }
    
    func preparePreLogin() {
        if isPinEnable {
            viewState = .pin
            return
        }
        if isBiometricEnable {
            viewState = .biometric
            return
        }
    }
}
