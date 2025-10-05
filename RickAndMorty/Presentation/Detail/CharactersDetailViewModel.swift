//
//  CharactersDetailViewModel.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import Foundation

final class CharactersDetailViewModel {

    private let character: Character

    init(character: Character) {
        self.character = character
    }
}

// MARK: CharactersDetailViewModel

extension CharactersDetailViewModel {
    var characterDetail: Character {
        character
    }
}
