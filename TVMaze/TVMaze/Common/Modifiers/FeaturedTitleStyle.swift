//
//  FeaturedTitleStyle.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 22/04/25.
//

import Foundation
import SwiftUI

struct FeaturedTitleStyle: ViewModifier {
    
    var fontSize: CGFloat = 16.0
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: fontSize, weight: .bold))
            .foregroundStyle(.black)
    }
}
