//
//  CharacterDetailViewModel.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import Combine
import Foundation

final class CharacterDetailViewModel: ObservableObject {
    
    private let api: CharacterDetailAPIProtocol
    private let characterViewData: CharacterViewData
    private var cancellables = Set<AnyCancellable>()
    private(set) var episodeSaved: CharacterEpisodeViewData?
    
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
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Success")
                case .failure:
                    print("Error")
                }
            } receiveValue: { [weak self] characterEpisodes in
                self?.episodes = characterEpisodes.map { characterEpisodeResponse in
                    let show = characterEpisodeResponse.embedded.show
                    return CharacterEpisodeViewData(name: show.name, image: self?.getImageURL(from: characterEpisodeResponse), link: URL(string: show.url) ?? URL(fileURLWithPath: ""))
                }
            }
            .store(in: &cancellables)
    }
    
    func episodeSelected(episode: CharacterEpisodeViewData) {
        episodeSaved = episode
    }
}

// MARK: - Private Functions
private extension CharacterDetailViewModel {
    private func getImageURL(from episode: CharacterEpisodeResponse) -> URL? {
        if let imgURL = URL(string: episode.embedded.show.image?.medium ?? "") {
            return imgURL
        } else if let imgURL = URL(string: episode.embedded.show.image?.original ?? "") {
            return imgURL
        }
        return URL(string: "http://www.placeholder.com")
    }
}
