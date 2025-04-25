//
//  CharacterDetailView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import Kingfisher
import SwiftUI

struct CharacterDetailView: View {
    
    @ObservedObject var viewModel: CharacterDetailViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.characterName)
            KFImage(viewModel.characterImg)
                .resizable()
                .placeholder {
                    Image("popcornplaceHolder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 200)
                }
                .cancelOnDisappear(true)
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 200)
                .cornerRadius(8)
            
            Spacer()
        }
        .onAppear {
            viewModel.loadEpisodes()
        }
    }
}

#Preview {
    CharacterDetailView(viewModel: CharacterDetailViewModel(characterViewData: CharacterViewData(id: 0, name: "")))
}
