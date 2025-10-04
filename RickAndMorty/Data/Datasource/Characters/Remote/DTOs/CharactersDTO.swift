//
//  CharactersDTO.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

// MARK: - CharactersDTO

struct CharactersDTO: Codable {
    let info: InfoDTO
    let results: [CharacterDTO]
}
