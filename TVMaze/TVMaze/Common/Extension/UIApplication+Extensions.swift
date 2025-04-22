//
//  UIApplication+Extensions.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 22/04/25.
//

import SwiftUI

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder),
                   to: nil, from: nil, for: nil)
    }
}
