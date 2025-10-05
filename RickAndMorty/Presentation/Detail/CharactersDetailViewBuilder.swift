//
//  CharactersDetailViewBuilder.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import Foundation

protocol CharactersDetailViewBuilderProtocol {
    func build(character: Character) -> CharactersDetailView
}

final class CharactersDetailViewBuilder: CharactersDetailViewBuilderProtocol {
    func build(character: Character) -> CharactersDetailView {
        let viewModel = CharactersDetailViewModel(character: character)
        let view = CharactersDetailView(viewModel: viewModel)
        return view
    }
}
