//
//  InfoDTO.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

// MARK: - InfoDTO

struct InfoDTO: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
}
