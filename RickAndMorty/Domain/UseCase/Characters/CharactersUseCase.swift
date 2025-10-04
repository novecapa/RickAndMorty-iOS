//
//  CharactersUseCase.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

// MARK: CharactersUseCaseProtocol

protocol CharactersUseCaseProtocol {
    func getCharacters(page: Int) async throws -> Characters
    func searchCharacters(for name: String, page: Int) async throws -> Characters
}

// MARK: CharactersUseCase

final class CharactersUseCase: CharactersUseCaseProtocol {

    private let repository: CharactersRepositoryProtocol

    init(repository: CharactersRepositoryProtocol) {
        self.repository = repository
    }

    func getCharacters(page: Int) async throws -> Characters {
        try await repository.getCharacters(page: page)
    }

    func searchCharacters(for name: String, page: Int) async throws -> Characters {
        try await repository.searchCharacters(for: name, page: page)
    }
}
