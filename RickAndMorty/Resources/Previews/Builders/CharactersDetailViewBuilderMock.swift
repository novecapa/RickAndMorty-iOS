//
//  CharactersDetailViewBuilderMock.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 5/10/25.
//

import Foundation

final class CharactersDetailViewBuilderMock: CharactersDetailViewBuilderProtocol {
    func build(character: Character = .mock) -> CharactersDetailView {
        let viewModel = CharactersDetailViewModel(character: character)
        let view = CharactersDetailView(viewModel: viewModel)
        return view
    }
}
