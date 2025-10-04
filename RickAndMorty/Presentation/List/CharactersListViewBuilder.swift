//
//  CharactersListViewBuilder.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import Foundation

final class CharactersListViewBuilder {
    @MainActor func build() -> CharactersListView {
        let network = NetworkClient(urlSession: URLSession.shared)
        let remote = CharactersRemote(networkClient: network)
        let database = SwiftDataContainer(isStoredInMemoryOnly: false)
        let local = CharactersDatabase(database: database)
        let repository = CharactersRepository(remote: remote, database: local, utils: Utils())
        let useCase = CharactersUseCase(repository: repository)
        let viewModel = CharactersListViewModel(useCase: useCase)
        return CharactersListView(viewModel: viewModel)
    }
}
