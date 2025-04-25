//
//  CharacterViewModel.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import Combine
import Foundation
import UIKit

final class CharacterViewModel: ObservableObject {
    
    // MARK: - Enums
    enum ViewState {
        case loading
        case loaded
        case error
        case idle
    }
    
    // MARK: - Private Properties
    private let api: CharacterAPIProtocol
    private var cancellables = Set<AnyCancellable>()
    private var page: Int = 0
    private var originalCharacterslist: [CharacterViewData] = []
    private(set) var hasMoreData: Bool = true
    private var previousSearch: String = ""
    
    // MARK: - Internal Init
    init(api: CharacterAPIProtocol = CharacterAPI()) {
        self.api = api
        setupSearchSubscriber()
    }
    
    // MARK: - Published Properties
    @Published var characterList: [CharacterViewData] = []
    @Published var viewState: ViewState = .idle
    @Published var searchText: String = ""
}

// MARK: - Internal Functions
extension CharacterViewModel {
    func loadCharacters() {
        guard hasMoreData else {
            return
        }
        if viewState == .loading {
            return
        }
        viewState = .loading
        api.loadCharactersList(page: page)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] complete in
                switch complete {
                case .finished:
                    print("Success")
                case .failure:
                    self?.viewState = .error
                }
            } receiveValue: { [weak self] characters in
                self?.viewState = .loaded
                self?.page += 1
                if characters.isEmpty {
                    self?.hasMoreData = false
                }
                characters.forEach { character in
                    let characterViewData = CharacterViewData(id: character.id, name: character.name, image: self?.getImageURL(from: character))
                    self?.characterList.append(characterViewData)
                }
                self?.originalCharacterslist = self?.characterList ?? []
            }
            .store(in: &cancellables)
    }
    
    func loadSeriesByName() {
        if viewState == .loading {
            return
        }
        viewState = .loading
        api.loadCharactersBy(name: searchText)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] complete in
                switch complete {
                case .finished:
                    print("Success")
                case .failure:
                    self?.viewState = .error
                }
            } receiveValue: { [weak self] characters in
                self?.viewState = .loaded
                self?.characterList = characters.map({ character in
                    CharacterViewData(id: character.person.id, name: character.person.name, image: self?.getImageURL(from: character.person))
                })
            }
            .store(in: &cancellables)
    }
}

// MARK: - Private Functions
private extension CharacterViewModel {
    private func getImageURL(from character: CharacterResponse) -> URL? {
        if let imgURL = URL(string: character.image?.medium ?? "") {
            return imgURL
        } else if let imgURL = URL(string: character.image?.original ?? "") {
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
                    self.characterList = self.originalCharacterslist
                } else {
                    let filtered = self.originalCharacterslist.filter {
                        $0.name.lowercased().contains(trimmed.lowercased())
                    }
                    self.characterList = filtered
                    
                    if filtered.isEmpty && trimmed != self.previousSearch {
                        self.previousSearch = trimmed
                        self.loadSeriesByName()
                    }
                }
            }
            .store(in: &cancellables)
    }
}
