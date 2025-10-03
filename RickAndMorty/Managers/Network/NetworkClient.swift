//
//  NetworkClient.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

protocol NetworkClientProtocol {
    func call<T: Decodable>(urlString: String,
                            method: NetworkMethod,
                            queryParams: [String: Any]?,
                            of type: T.Type) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {

    // MARK: - Private
    private let urlSession: URLSessionProtocol

    // MARK: - Init
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }

    func call<T: Decodable>(urlString: String,
                            method: NetworkMethod,
                            queryParams: [String: Any]? = nil,
                            of type: T.Type) async throws -> T {

        var urlComponents = URLComponents(string: urlString)

        // Query params
        urlComponents?.addQueryParams(queryParams)

        guard let url = urlComponents?.url else {
            throw NetworkError.badURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue.uppercased()

        let (data, response) = try await urlSession.getDataFrom(request, type: T.self)
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.badResponse
        }

        Log.thisRequest(response, data: data, request: request)

        switch response.statusCode {
        case 200..<300:
            let result = try JSONDecoder().decode(T.self, from: data)
            return result
        case 400..<499:
            throw NetworkError.notFound
        case 500:
            throw NetworkError.serverError
        default:
            throw NetworkError.badRequest
        }
    }
}

// MARK: URLComponents

private extension URLComponents {
    mutating func addQueryParams(_ queryParams: [String: Any?]?) {
        guard let queryParams else { return }
        queryItems = queryParams.compactMap { key, value in
            if let stringValue = value as? String, !stringValue.isEmpty {
                return URLQueryItem(name: key, value: stringValue)
            }
            if let otherValue = value,
               let stringValue = String(describing: otherValue)
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               !stringValue.isEmpty {
                return URLQueryItem(name: key, value: stringValue)
            }
            return nil
        }
    }
}
