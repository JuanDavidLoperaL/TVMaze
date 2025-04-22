//
//  FeaturedTitleStyle.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 22/04/25.
//

import Foundation
import SwiftUI

struct FeaturedTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.black)
    }
}
