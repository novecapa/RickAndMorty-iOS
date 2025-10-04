//
//  Characters.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

struct Characters {
    let characters: [Character]
    let hasNextPage: Bool

    var addNewPage: Int {
        hasNextPage ? 1 : 0
    }
}
