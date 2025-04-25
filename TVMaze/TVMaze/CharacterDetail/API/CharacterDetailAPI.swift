//
//  CharacterDetailAPI.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import Combine
import Foundation

protocol CharacterDetailAPIProtocol: AnyObject {
    func loadEpisodes(characterId: Int) -> AnyPublisher<[CharacterEpisodeResponse], NetworkError>
}

final class CharacterDetailAPI: CharacterDetailAPIProtocol {
    func loadEpisodes(characterId: Int) -> AnyPublisher<[CharacterEpisodeResponse], NetworkError> {
        var urlComponent = URLComponents(string: "https://api.tvmaze.com/people/\(characterId)/castcredits")
        urlComponent?.queryItems = [
            URLQueryItem(name: "embed", value: "show")
        ]
        guard let url = urlComponent?.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse: HTTPURLResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.errorInRequest
                }
                return data
            }
            .decode(type: [CharacterEpisodeResponse].self, decoder: JSONDecoder())
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
