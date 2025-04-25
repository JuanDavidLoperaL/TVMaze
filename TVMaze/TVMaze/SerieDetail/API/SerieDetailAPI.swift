//
//  SerieDetailAPI.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 22/04/25.
//

import Combine
import Foundation

protocol SerieDetailAPIProtocol: AnyObject {
    func loadEpisodes(id: Int) -> AnyPublisher<[SerieEpisodes], NetworkError>
}

final class SerieDetailAPI: SerieDetailAPIProtocol {
    func loadEpisodes(id: Int) -> AnyPublisher<[SerieEpisodes], NetworkError> {
        guard let url = URL(string: "https://api.tvmaze.com/shows/\(id)/episodes") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.errorInRequest
                }
                return data
            }
            .decode(type: [SerieEpisodes].self, decoder: JSONDecoder())
            .mapError{ error in
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
