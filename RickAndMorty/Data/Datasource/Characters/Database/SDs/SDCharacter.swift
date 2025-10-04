//
//  SDCharacter.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation
import SwiftData

@Model
class SDCharacter {
    @Attribute(.unique) var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var image: String
    @Relationship(deleteRule: .cascade)
    var location: SDLocation
    var episode: [String]

    init(
        id: Int,
        name: String,
        status: String,
        species: String,
        type: String,
        genger: String,
        image: String,
        location: SDLocation,
        episode: [String]
    ) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = genger
        self.image = image
        self.location = location
        self.episode = episode
    }
}
