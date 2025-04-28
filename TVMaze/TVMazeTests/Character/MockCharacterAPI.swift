//
//  MockCharacterAPI.swift
//  TVMazeTests
//
//  Created by Juan david Lopera lopez on 28/04/25.
//

import Combine
@testable import TVMaze

final class MockCharacterAPI: CharacterAPIProtocol {
    
    var shouldReturnError = false
    var mockCharacters: [CharacterResponse] = []
    var mockCharactersByName: [CharacterByNameResponse] = []
    
    func loadCharactersList(page: Int) -> AnyPublisher<[CharacterResponse], NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.errorInRequest).eraseToAnyPublisher()
        } else {
            return Just(mockCharacters)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func loadCharactersBy(name: String) -> AnyPublisher<[CharacterByNameResponse], NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.errorInRequest).eraseToAnyPublisher()
        } else {
            return Just(mockCharactersByName)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
    }
}
