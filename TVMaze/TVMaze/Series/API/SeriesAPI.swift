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
    func getSerieBy(name: String) -> AnyPublisher<[SerieByNameResponse], NetworkError>
}

final class SeriesAPI: SeriesAPIProtocol {
    func getSerieList(page: Int) -> AnyPublisher<[Serie], NetworkError> {
        var urlComponent = URLComponents(string: "https://api.tvmaze.com/shows")
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
    
    func getSerieBy(name: String) -> AnyPublisher<[SerieByNameResponse], NetworkError> {
        var urlComponent = URLComponents(string: "https://api.tvmaze.com/search/shows")
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
            .decode(type: [SerieByNameResponse].self, decoder: JSONDecoder())
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
