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
    @State private var showSafariView = false
    
    var body: some View {
        VStack {
            Text(viewModel.characterName)
                .modifier(FeaturedTitleStyle())
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
            episodeList()
                .padding(.top)
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showSafariView) {
            SafariView(url: viewModel.episodeSaved?.link ?? URL(filePath: ""))
                }
        .onAppear {
            viewModel.loadEpisodes()
        }
    }
    
    func episodeList() -> some View {
        VStack {
            Text("Episode List")
                .modifier(FeaturedTitleStyle())
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(viewModel.episodes, id: \.self) { episode in
                        HStack {
                            KFImage(episode.image)
                                .resizable()
                                .placeholder {
                                    Image("popcornplaceHolder")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 120, height: 200)
                                }
                                .cancelOnDisappear(true)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70.0, height: 70.0)
                                .cornerRadius(8)
                            VStack(alignment: .leading) {
                                Text("Name")
                                    .modifier(TitleStyle())
                                Text(episode.name)
                                    .modifier(FeaturedTitleStyle())
                                
                            }
                            Spacer()
                            Button {
                                viewModel.episodeSelected(episode: episode)
                                showSafariView = true
                            } label: {
                                Text("See More!")
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    CharacterDetailView(viewModel: CharacterDetailViewModel(characterViewData: CharacterViewData(id: 0, name: "")))
}
