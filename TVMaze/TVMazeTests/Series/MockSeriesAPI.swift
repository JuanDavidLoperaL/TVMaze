//
//  MockSeriesAPI.swift
//  TVMazeTests
//
//  Created by Juan david Lopera lopez on 28/04/25.
//

import Combine
import Foundation
@testable import TVMaze

class MockSeriesAPI: SeriesAPIProtocol {
    
    var shouldReturnError = false
    var mockSeries: [Serie] = []
    var serieByName: [SerieByNameResponse] = []
    
    func getSerieList(page: Int) -> AnyPublisher<[TVMaze.Serie], TVMaze.NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.serverNotAvailable).eraseToAnyPublisher()
        } else {
            return Just(mockSeries)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
    }
    
    func getSerieBy(name: String) -> AnyPublisher<[TVMaze.SerieByNameResponse], TVMaze.NetworkError> {
        if shouldReturnError {
            return Fail(error: NetworkError.serverNotAvailable).eraseToAnyPublisher()
        } else {
            return Just(serieByName)
                .setFailureType(to: NetworkError.self)
                .eraseToAnyPublisher()
        }
    }
}
