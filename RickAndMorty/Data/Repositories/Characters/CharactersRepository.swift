//
//  CharactersRepository.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

// MARK: CharactersRepositoryProtocol

protocol CharactersRepositoryProtocol {
    func getCharacters(page: Int) async throws -> Characters
    func searchCharacters(for name: String, page: Int) async throws -> Characters
}

// MARK: CharactersRepository

final class CharactersRepository: CharactersRepositoryProtocol {

    private let remote: CharactersRemoteProtocol
    private let database: CharactersDatabaseProtocol
    private let utils: UtilsProtocol

    init(
        remote: CharactersRemoteProtocol,
        database: CharactersDatabaseProtocol,
        utils: UtilsProtocol
    ) {
        self.remote = remote
        self.database = database
        self.utils = utils
    }
    
    func getCharacters(page: Int) async throws -> Characters {
        if page == 1 && !utils.existsConnection {
            let characters: [Character] = try await MainActor.run {
                try database.getCharacters().map { $0.toEntity }
            }
            return Characters(characters: characters, hasNextPage: false)
        }
        let chList = try await remote.getCharacters(page: page)

        // SwiftData persistence
        try await MainActor.run {
            let sds = chList.results.map { $0.toEntity.toSD }
            try database.saveCharacters(characters: sds)
        }

        return chList.toEntity
    }

    func searchCharacters(for name: String, page: Int) async throws -> Characters {
        if !utils.existsConnection {
            let characters: [Character] = try await MainActor.run {
                try database.searchCharacter(for: name).map { $0.toEntity }
            }
            return Characters(characters: characters, hasNextPage: false)
        }
        let chList = try await remote.searchCharacters(for: name, page: page)

        // SwiftData persistence
        try await MainActor.run {
            let sds = chList.results.map { $0.toEntity.toSD }
            try database.saveCharacters(characters: sds)
        }

        return chList.toEntity
    }
}

// MARK: - SDCharacter

private extension SDCharacter {
    var toEntity: Character {
        Character(id: id,
                  name: name,
                  status: status,
                  species: species,
                  type: type,
                  gender: gender,
                  image: image,
                  location: location.toEntity,
                  episode: episode)
    }
}

// MARK: - Character

private extension Character {
    var toSD: SDCharacter {
        SDCharacter(id: id,
                    name: name,
                    status: status,
                    species: species,
                    type: type,
                    gender: gender,
                    image: image,
                    location: location.toSD,
                    episode: episode)
    }
}

// MARK: - Location

private extension Location {
    var toSD: SDLocation {
        SDLocation(name: name, url: url)
    }
}

// MARK: - SDLocation

private extension SDLocation {
    var toEntity: Location {
        Location(name: name, url: url)
    }
}

// MARK: - CharactersDTO

private extension CharactersDTO {
    var toEntity: Characters {
        Characters(characters: results.map { $0.toEntity },
                   hasNextPage: info.hasNextPage)
    }
}

// MARK: - CharacterDTO

private extension CharacterDTO {
    var toEntity: Character {
        Character(id: id,
                  name: name,
                  status: status,
                  species: species,
                  type: type,
                  gender: gender,
                  image: image,
                  location: location.toEntity,
                  episode: episode.map { $0 })
    }
}

// MARK: - InfoDTO

private extension InfoDTO {
    var hasNextPage: Bool {
        guard let nextPage = next else {
            return false
        }
        return !nextPage.isEmpty ? true : false
    }
}

// MARK: - LocationDTO

private extension LocationDTO {
    var toEntity: Location {
        Location(name: name, url: url)
    }
}
