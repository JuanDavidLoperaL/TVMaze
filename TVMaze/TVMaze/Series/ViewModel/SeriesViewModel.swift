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
    
    // MARK: - Private Properties
    private let api: SeriesAPIProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Internal Init
    init(api: SeriesAPIProtocol = SeriesAPI()) {
        self.api = api
    }
    
    // MARK: - Published Properties
    @Published var seriesList: [SerieDataView] = []
}

// MARK: - Internal Functions
extension SeriesViewModel {
    func getSeries() {
        api.getSerieList(page: 0)
            .receive(on: DispatchQueue.main)
            .sink { complete in
            switch complete {
            case .finished:
                print("Success")
            case .failure(let error):
                print("Error")
            }
        } receiveValue: { series in
            series.forEach { [weak self] serie in
                let serieDataView = SerieDataView(title: serie.name, language: serie.language, genres: serie.genres.joined(separator: ", "), image: UIImage())
                self?.seriesList.append(serieDataView)
            }
        }
        .store(in: &cancellables)
    }
}
