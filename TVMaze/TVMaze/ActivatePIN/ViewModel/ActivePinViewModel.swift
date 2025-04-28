//
//  ActivePinViewModel.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import Combine
import Foundation

final class ActivePinViewModel: ObservableObject {
    
    @Published var pin: String = ""
    @Published var showAlert: Bool = false
    
    var alertTitle: String {
        return "PIN invalid"
    }
    
    var alertDescription: String {
        return "PIN is invalid, PIN should be just 5 digits and only numbers."
    }

    func validatePin() -> Bool {
        let regex = #"^\d{5}$"#
        return pin.range(of: regex, options: .regularExpression) != nil
    }
    
    func isPinEnable() -> Bool {
        let storedPin: String = UserDefaults.standard.string(forKey: "storedPin") ?? String()
        return !storedPin.isEmpty
    }
    
    func savePin() {
        UserDefaults.standard.set(pin, forKey: "storedPin")
    }
}
