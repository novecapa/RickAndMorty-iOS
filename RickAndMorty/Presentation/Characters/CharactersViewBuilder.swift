//
//  CharactersViewBuilder.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import Foundation

protocol CharactersViewBuilderProtocol {
    @MainActor
    func build() -> CharactersView
}

final class CharactersViewBuilder: CharactersViewBuilderProtocol {
    @MainActor
    func build() -> CharactersView {
        let network = NetworkClient(urlSession: URLSession.shared)
        let remote = CharactersRemote(networkClient: network)
        let database = SwiftDataContainer(isStoredInMemoryOnly: false)
        let local = CharactersDatabase(database: database)
        let repository = CharactersRepository(remote: remote, database: local, utils: Utils())
        let useCase = CharactersUseCase(repository: repository)
        let viewModel = CharactersViewModel(useCase: useCase)
        return CharactersView(viewModel: viewModel)
    }
}
