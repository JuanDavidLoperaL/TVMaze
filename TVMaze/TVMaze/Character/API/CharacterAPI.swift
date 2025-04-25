//
//  CharacterAPI.swift
//  TVMaze
//
//  Created by Juan david Lopera lopez on 24/04/25.
//

import Combine
import Foundation

protocol CharacterAPIProtocol: AnyObject {
    func loadCharactersList(page: Int) -> AnyPublisher<[CharacterResponse], NetworkError>
    func loadCharactersBy(name: String) -> AnyPublisher<[CharacterByNameResponse], NetworkError>
}

final class CharacterAPI: CharacterAPIProtocol {
    
    func loadCharactersList(page: Int) -> AnyPublisher<[CharacterResponse], NetworkError> {
        var urlComponent = URLComponents(string: "https://api.tvmaze.com/people")
        urlComponent?.queryItems = [
            URLQueryItem(name: "page", value: "\(page)")
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
            .decode(type: [CharacterResponse].self, decoder: JSONDecoder())
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
    
    func loadCharactersBy(name: String) -> AnyPublisher<[CharacterByNameResponse], NetworkError> {
        var urlComponent = URLComponents(string: "https://api.tvmaze.com/search/people")
        urlComponent?.queryItems = [
            URLQueryItem(name: "q", value: name)
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
            .decode(type: [CharacterByNameResponse].self, decoder: JSONDecoder())
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
