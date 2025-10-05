//
//  NetworkClient.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

// MARK: NetworkClientProtocol

protocol NetworkClientProtocol {
    func call<T: Decodable>(urlString: String,
                            method: NetworkMethod,
                            queryParams: [String: Any]?,
                            of type: T.Type) async throws -> T
}

// MARK: NetworkClient

final class NetworkClient: NetworkClientProtocol {

    private let urlSession: URLSessionProtocol
    private let decoder: JSONDecoder

    init(urlSession: URLSessionProtocol,
         decoder: JSONDecoder = JSONDecoder()) {
        self.urlSession = urlSession
        self.decoder = decoder
    }

    func call<T: Decodable>(urlString: String,
                            method: NetworkMethod,
                            queryParams: [String: Any]? = nil,
                            of type: T.Type) async throws -> T {

        var urlComponents = URLComponents(string: urlString)

        // Query params
        if let queryParams {
            var items = urlComponents?.queryItems ?? []
            for (key, value) in queryParams {
                items.append(URLQueryItem(name: key, value: "\(value)"))
            }
            urlComponents?.queryItems = items
        }

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
            return try decoder.decode(T.self, from: data)
        case 400..<499:
            throw NetworkError.badRequest
        case 500:
            throw NetworkError.serverError
        case 502:
            throw NetworkError.badGateway
        default:
            throw NetworkError.badResponse
        }
    }
}
