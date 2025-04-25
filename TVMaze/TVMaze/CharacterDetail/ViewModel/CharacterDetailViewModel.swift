//
//  CharacterDetailViewModel.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import Foundation

final class CharacterDetailViewModel: ObservableObject {
    
    private let api: CharacterDetailAPIProtocol
    private let characterViewData: CharacterViewData
    
    init(api: CharacterDetailAPIProtocol = CharacterDetailAPI(), characterViewData: CharacterViewData) {
        self.api = api
        self.characterViewData = characterViewData
    }
    
    @Published var episodes: [CharacterEpisodeViewData] = []
    
    var characterName: String {
        return characterViewData.name
    }
    
    var characterImg: URL? {
        return characterViewData.image
    }
}

extension CharacterDetailViewModel {
    func loadEpisodes() {
        api.loadEpisodes(characterId: characterViewData.id)
            .subscribe(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Success")
                case .failure:
                    print("Error")
                }
            } receiveValue: { [weak self] characterEpisodes in
                self?.episodes = characterEpisodes.map { characterEpisodeResponse in
                    CharacterEpisodeViewData(name: characterEpisodeResponse.embedded.name, image: self?.getImageURL(from: characterEpisodeResponse), link: URL(string: characterEpisodeResponse.embedded.url) ?? URL(fileURLWithPath: ""))
                }
                print(characterEpisodes)
            }
    }
}

// MARK: - Private Functions
private extension CharacterDetailViewModel {
    private func getImageURL(from episode: CharacterEpisodeResponse) -> URL? {
        if let imgURL = URL(string: episode.embedded.image?.medium ?? "") {
            return imgURL
        } else if let imgURL = URL(string: episode.embedded.image?.original ?? "") {
            return imgURL
        }
        return URL(string: "http://www.placeholder.com")
    }
}
