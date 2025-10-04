//
//  CharacterDTO.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

// MARK: - CharacterDTO

struct CharacterDTO: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let location: LocationDTO
    let episode: [String]
}
