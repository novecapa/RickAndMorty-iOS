//
//  Character.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import SwiftUI

struct Character: Identifiable, Equatable {

    static func == (lhs: Character, rhs: Character) -> Bool {
        lhs.id == rhs.id && lhs.name == rhs.name && lhs.status == rhs.status
    }

    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let location: Location
    let episode: [String]

    // MARK: Character image
    var imageUrl: URL? {
        URL(string: image)
    }

    // MARK: Status color
    var statusColor: Color {
        switch status.lowercased() {
        case "dead":
            return .red
        case "alive":
            return .green
        default:
            return .yellow
        }
    }

    // MARK: Detail
    var appearsOn: String {
        "\("Appears on".localized()) \(episode.count) \("episode(s)".localized())"
    }
}

// MARK: Mock values

extension Character {
    static let mock: Character = Character(id: 1,
                                           name: "Name",
                                           status: "alive",
                                           species: "Specie",
                                           type: "Type",
                                           gender: "Gender",
                                           image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                                           location: Location(name: "Location", url: "URL..."),
                                           episode: ["1", "2", "3"])
}
