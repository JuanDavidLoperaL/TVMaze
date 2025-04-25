//
//  CharacterView.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import Kingfisher
import SwiftUI

struct CharacterView: View {
    
    @StateObject var viewModel: CharacterViewModel = CharacterViewModel()

    
    var body: some View {
        NavigationStack {
            VStack {
                switch viewModel.viewState {
                case .idle:
                    Text("TVMaze App")
                    Text("Dev: Juan David Lopera")
                case .error:
                    Image("error")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200.0, height: 200.0)
                        .padding()
                    Text("Error loading the characters list\nCheck your internet connection and\ntry again.")
                        .modifier(FeaturedTitleStyle())
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Button {
                        viewModel.loadCharacters()
                    } label: {
                        Text("Try again")
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top)
                case .loading:
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(3.0)
                            .padding(.bottom)
                        Text("Loading...")
                            .modifier(FeaturedTitleStyle())
                            .padding(.top)
                        Spacer()
                    }
                case .loaded:
                    TextField("Search characters...", text: $viewModel.searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding()
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            ForEach(viewModel.characterList.indices, id: \.self) { index in
                                let character = viewModel.characterList[index]
                                NavigationLink(destination: CharacterDetailView(viewModel: CharacterDetailViewModel(characterViewData: character))) {
                                    CharacterRow(character: character)
                                }
                                .onAppear {
                                    if index >= viewModel.characterList.count - 20 {
                                        viewModel.loadCharacters()
                                    }
                                }
                            }
                            if viewModel.viewState == .loading && viewModel.hasMoreData {
                                ProgressView("Loading more...")
                                    .padding()
                            }
                        }
                        .padding()
                    }
                    .simultaneousGesture(DragGesture().onChanged({ _ in
                        UIApplication.shared.hideKeyboard()
                    }))
                }
            }.padding()
            .onTapGesture {
                UIApplication.shared.hideKeyboard()
            }
            .onAppear(perform: {
                if viewModel.characterList.isEmpty {
                    viewModel.loadCharacters()
                }
            })
            .navigationTitle("Characters")
        }
    }
}

#Preview {
    CharacterView()
}
