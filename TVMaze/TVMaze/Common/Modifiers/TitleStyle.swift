//
//  TitleStyle.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 22/04/25.
//

import Foundation
import SwiftUI

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14.0, weight: .regular))
            .foregroundStyle(.primary)
    }
}
