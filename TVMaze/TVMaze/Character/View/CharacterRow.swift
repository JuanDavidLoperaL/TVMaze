//
//  CharacterRow.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import Kingfisher
import SwiftUI

struct CharacterRow: View {
    
    var character: CharacterViewData
    
    var body: some View {
        VStack {
            KFImage(character.image)
                .resizable()
                .placeholder {
                    Image("popcornplaceHolder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 160)
                }
                .cancelOnDisappear(true)
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 160)
                .cornerRadius(8)
            Text(character.name)
                .modifier(FeaturedTitleStyle())
        }
    }
}

#Preview {
    CharacterRow(character: CharacterViewData(id: 0, name: "", image: nil))
}
