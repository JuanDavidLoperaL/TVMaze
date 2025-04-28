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
    private var originalSerielist: [SerieDataView] = []
    private(set) var hasMoreData: Bool = true
    private var previousSearch: String = ""
    private let userDefaults = UserDefaults.standard
    private let key = "favSeries"
    
    // MARK: - Internal Init
    init(api: SeriesAPIProtocol = SeriesAPI()) {
        self.api = api
        setupSearchSubscriber()
    }
    
    // MARK: - Published Properties
    @Published var seriesList: [SerieDataView] = []
    @Published var viewState: ViewState = .idle
    @Published var searchText: String = ""
}

// MARK: - Internal Functions
extension SeriesViewModel {
    
    func serie(index: Int) -> SerieDataView {
        guard seriesList.indices.contains(index) else {
            return seriesList.last ?? SerieDataView(id: 0, title: "", language: "", genres: "", scheduleDays: "", scheduleTime: "", summary: "")
        }
        return seriesList[index]
    }

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
                    let serieDataView = SerieDataView(id: serie.id,
                                                      title: serie.name,
                                                      language: serie.language,
                                                      genres: serie.genres.joined(separator: ", "),
                                                      scheduleDays: serie.schedule.days.joined(separator: ", "),
                                                      scheduleTime: serie.schedule.time,
                                                      summary: serie.summary,
                                                      image: self?.getImageURL(from: serie))
                    self?.seriesList.append(serieDataView)
                }
                self?.originalSerielist = self?.seriesList ?? []
                self?.sortSeriesList()
                self?.updateFavoritesStatus()
            }
            .store(in: &cancellables)
    }
    
    func loadSeriesByName() {
        if viewState == .loading {
            return
        }
        viewState = .loading
        api.getSerieBy(name: searchText)
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
                self?.seriesList = series.map({ serie in
                    SerieDataView(id: serie.show.id,
                                  title: serie.show.name,
                                  language: serie.show.language,
                                  genres: serie.show.genres.joined(separator: ", "),
                                  scheduleDays: serie.show.schedule.days.joined(separator: ", "),
                                  scheduleTime: serie.show.schedule.time,
                                  summary: serie.show.summary,
                                  image: self?.getImageURL(from: serie.show))
                })
                self?.sortSeriesList()
                self?.updateFavoritesStatus()
            }
            .store(in: &cancellables)
    }
    
    func buttonTitle(index: Int) -> String {
        let isFavorite = seriesList[index].isFavorite
        return isFavorite ? "Delete\nFavorite" : "Add Favorite"
    }
    
    func imgName(index: Int) -> String {
        let favDict: [String: Data] = userDefaults.dictionary(forKey: key) as? [String: Data] ?? [:]
        if favDict.isEmpty || (favDict["\(seriesList[index].id)"] == nil) {
            return "fav"
        }
        return "fav.fill"
    }
    
    func addToFavorite(index: Int) {
        seriesList[index].isFavorite.toggle()
        if !seriesList[index].isFavorite {
            removeFromFavorites(serieID: seriesList[index].id)
            return
        }
        let serie = seriesList[index]
        
        var favDict: [String: Data] = userDefaults.dictionary(forKey: key) as? [String: Data] ?? [:]
        
        do {
            let encodedSerie = try JSONEncoder().encode(serie)
            favDict["\(serie.id)"] = encodedSerie
            userDefaults.set(favDict, forKey: key)
            updateFavoritesStatus()
            sortSeriesList()
            print("✅ Serie updated in favorites")
        } catch {
            print("❌ Error saving serie in favorites: \(error.localizedDescription)")
        }
    }
    
    func removeFromFavorites(serieID: Int) {
        var favDict: [String: Data] = userDefaults.dictionary(forKey: key) as? [String: Data] ?? [:]
        
        if favDict.removeValue(forKey: "\(serieID)") != nil {
            userDefaults.set(favDict, forKey: key)
            updateFavoritesStatus()
            sortSeriesList()
            print("🗑️ Serie con ID \(serieID) eliminada de favoritos")
        } else {
            print("⚠️ Serie con ID \(serieID) no estaba en favoritos")
        }
    }
    
    func loadFavorites() {
        if let favDict = userDefaults.dictionary(forKey: key) as? [String: Data] {
            for (id, data) in favDict {
                do {
                    let serie = try JSONDecoder().decode(SerieDataView.self, from: data)
                    print("🔹 Loading series fav: \(serie.title)")
                } catch {
                    print("❌ Error loading favorites: \(error.localizedDescription)")
                }
            }
        }
    }
}

// MARK: - Private Functions
private extension SeriesViewModel {
    private func sortSeriesList() {
        seriesList.sort { $0.title.lowercased() < $1.title.lowercased() }
    }
    private func updateFavoritesStatus() {
        for (index, serie) in seriesList.enumerated() {
            let favDict: [String: Data] = userDefaults.dictionary(forKey: key) as? [String: Data] ?? [:]
            if let _ = favDict["\(serie.id)"] {
                seriesList[index].isFavorite = true
            } else {
                seriesList[index].isFavorite = false
            }
        }
    }
    
    private func getImageURL(from serie: Serie) -> URL? {
        if let imgURL = URL(string: serie.image?.medium ?? "") {
            return imgURL
        } else if let imgURL = URL(string: serie.image?.original ?? "") {
            return imgURL
        }
        return URL(string: "http://www.placeholder.com")
    }
    
    private func setupSearchSubscriber() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)            .removeDuplicates()
            .sink { [weak self] search in
                guard let self = self else {
                    return
                }
                let trimmed = search.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty {
                    self.seriesList = self.originalSerielist
                } else {
                    let filtered = self.originalSerielist.filter {
                        $0.title.lowercased().contains(trimmed.lowercased())
                    }
                    self.seriesList = filtered
                    
                    if filtered.isEmpty && trimmed != self.previousSearch {
                        self.previousSearch = trimmed
                        self.loadSeriesByName()
                    }
                }
                self.sortSeriesList()
            }
            .store(in: &cancellables)
    }
}
