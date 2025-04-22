//
//  SeriesViewModel.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25.
//

import Combine
import Foundation
import UIKit

final class SeriesViewModel: ObservableObject {
    
    // MARK: - Enums
    enum ViewState {
        case loading
        case loaded
        case error
        case idle
    }
    
    // MARK: - Private Properties
    private let api: SeriesAPIProtocol
    private var cancellables = Set<AnyCancellable>()
    private var page: Int = 0
    private var hasMoreData: Bool = true
    private var originalSerielist: [SerieDataView] = []
    
    // MARK: - Internal Init
    init(api: SeriesAPIProtocol = SeriesAPI()) {
        self.api = api
    }
    
    // MARK: - Published Properties
    @Published var seriesList: [SerieDataView] = []
    @Published var viewState: ViewState = .idle
    @Published var searchText: String = "" {
        didSet {
            if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                seriesList = originalSerielist
            } else {
                seriesList = originalSerielist.filter {
                    $0.title.lowercased().contains(searchText.lowercased())
                }
            }
        }
    }
}

// MARK: - Internal Functions
extension SeriesViewModel {
    func loadSeries() {
        guard hasMoreData else {
            return
        }
        if viewState == .loading {
            return
        }
        viewState = .loading
        api.getSerieList(page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] complete in
                switch complete {
                case .finished:
                    print("Success")
                case .failure:
                    self?.viewState = .error
                }
            } receiveValue: { [weak self] series in
                self?.viewState = .loaded
                self?.page += 1
                if series.isEmpty {
                    self?.hasMoreData = false
                }
                series.forEach { serie in
                    let serieDataView = SerieDataView(title: serie.name, language: serie.language, genres: serie.genres.joined(separator: ", "), image: self?.getImageURL(from: serie))
                    self?.seriesList.append(serieDataView)
                }
                self?.originalSerielist = self?.seriesList ?? []
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Functions
private extension SeriesViewModel {
    private func getImageURL(from serie: Serie) -> URL? {
        if let imgURL = URL(string: serie.image.medium) {
            return imgURL
        } else if let imgURL = URL(string: serie.image.original) {
            return imgURL
        }
        return URL(string: "http://www.placeholder.com")
    }
}
