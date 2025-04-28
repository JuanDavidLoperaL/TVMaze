//
//  MockSerieDetailAPI.swift
//  TVMazeTests
//
//  Created by Juan david Lopera lopez on 28/04/25.
//

import XCTest
import Combine
@testable import TVMaze

class MockSerieDetailAPI: SerieDetailAPIProtocol {
    var shouldReturnError = false
    var mockEpisodes: [SerieEpisodes] = []
    
    func loadEpisodes(id: Int) -> AnyPublisher<[SerieEpisodes], NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.serverNotAvailable)
                .eraseToAnyPublisher()
        } else {
            return Just(mockEpisodes)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
    }
}
