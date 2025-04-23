//
//  SerieDetailViewModel.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 22/04/25.
//

import Combine
import Foundation

final class SerieDetailViewModel: ObservableObject {
    
    private let api: SerieDetailAPIProtocol
    private(set) var serieDataView: SerieDataView
    private var cancellables = Set<AnyCancellable>()
    
    init(serieDataView: SerieDataView, api: SerieDetailAPIProtocol = SerieDetailAPI()) {
        self.serieDataView = serieDataView
        self.api = api
    }
    
    @Published var episodesList: [EpisodeViewData] = [] {
        didSet {
            episodesTitle = episodesList.isEmpty ? "" : "Episodes"
        }
    }
    @Published var episodesTitle: String = ""
}

// MARK: - Internal Functions
extension SerieDetailViewModel {
    func cleanSummary() -> String {
        return serieDataView.summary.htmlStripped
    }
    
    func loadEpisodes() {
        api.loadEpisodes(id: serieDataView.id)
            .receive(on: DispatchQueue.main)
            .sink { complete in
                switch complete {
                case .finished:
                    print("working")
                case .failure:
                    print("error")
                }
            } receiveValue: { [weak self] episodes in
                self?.episodesList = episodes.map({ episode in
                    EpisodeViewData(season: "season: \(episode.season)", img: URL(string: episode.image.medium), name: episode.name, number: "Episode: \(episode.number)", summary: episode.summary.htmlStripped)
                })
            }
            .store(in: &cancellables)
    }
}
