//
//  SeriesAPI.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 21/04/25.
//

import Combine
import Foundation

enum NetworkError: Error {
    case invalidURL
    case serverNotAvailable
    case invalidCasting
    case errorInRequest
}
protocol SeriesAPIProtocol: AnyObject {
    func getSerieList(page: Int) -> AnyPublisher<[Serie], NetworkError>
}

final class SeriesAPI: SeriesAPIProtocol {
    func getSerieList(page: Int) -> AnyPublisher<[Serie], NetworkError> {
        guard let url = URL(string: "https://api.tvmaze.com/shows?page=\(page)") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.errorInRequest
                }
                return data
            }
            .decode(type: [Serie].self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if error is URLError {
                    return .serverNotAvailable
                } else {
                    
                    return .invalidCasting
                }
            }
            .eraseToAnyPublisher()
    }
}
