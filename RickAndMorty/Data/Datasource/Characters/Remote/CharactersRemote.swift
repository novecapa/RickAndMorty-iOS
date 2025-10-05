//
//  CharactersRemote.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

// MARK: - CharactersRemoteProtocol

protocol CharactersRemoteProtocol {
    func getCharacters(page: Int) async throws -> CharactersDTO
    func searchCharacters(for name: String, page: Int) async throws -> CharactersDTO
}

// MARK: - CharactersRemote

final class CharactersRemote: CharactersRemoteProtocol {

    private enum Endpoints {

        // MARK: Base URL
        private static let baseURL = "https://rickandmortyapi.com/api/"

        // MARK: Endpoints
        case character

        var rawValue: String {
            switch self {
            case .character:
                return Endpoints.baseURL + "character"
            }
        }
    }

    private enum Constants {
        static let page = "page"
        static let name = "name"
    }

    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func getCharacters(page: Int) async throws -> CharactersDTO {
        let url = Endpoints.character.rawValue
        let queryParams = [
            Constants.page: page
        ]
        return try await networkClient.call(urlString: url,
                                            method: .get,
                                            queryParams: queryParams,
                                            of: CharactersDTO.self)
    }

    func searchCharacters(for name: String, page: Int) async throws -> CharactersDTO {
        let url = Endpoints.character.rawValue
        let queryParams: [String: Any] = [
            Constants.page: page,
            Constants.name: name
        ]
        return try await networkClient.call(urlString: url,
                                            method: .get,
                                            queryParams: queryParams,
                                            of: CharactersDTO.self)
    }
}
