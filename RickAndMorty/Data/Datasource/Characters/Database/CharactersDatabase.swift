//
//  CharactersDatabase.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation
import SwiftData

// MARK: CharactersDatabaseProtocol

@MainActor
protocol CharactersDatabaseProtocol {
    func getCharacters() throws -> [SDCharacter]
    func searchCharacter(for name: String) throws -> [SDCharacter]
    func saveCharacters(characters: [SDCharacter]) throws
    func deleteAllCharacters() throws
}

// MARK: CharactersDatabase

@MainActor
final class CharactersDatabase: CharactersDatabaseProtocol {

    private let database: SwiftDataContainerProtocol

    init(database: SwiftDataContainerProtocol) {
        self.database = database
    }

    func getCharacters() throws -> [SDCharacter] {
        let fetchDescriptor = FetchDescriptor<SDCharacter>(predicate: nil,
                                                           sortBy: [SortDescriptor<SDCharacter>(\.id)])
        return try database.container.mainContext.fetch(fetchDescriptor)
    }

    func searchCharacter(for name: String) throws -> [SDCharacter] {
        let fetchDescriptor = FetchDescriptor<SDCharacter>(
            predicate: #Predicate { $0.name.localizedStandardContains(name) },
            sortBy: [SortDescriptor<SDCharacter>(\.id)]
        )
        return try database.container.mainContext.fetch(fetchDescriptor)
    }

    func saveCharacters(characters: [SDCharacter]) throws {
        characters.forEach {
            database.container.mainContext.insert($0)
        }
        try database.container.mainContext.save()
    }

    func deleteAllCharacters() throws {
        let list = try getCharacters()
        list.forEach {
            database.container.mainContext.delete($0)
        }
        try database.container.mainContext.save()
    }
}
