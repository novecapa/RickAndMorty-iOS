//
//  CharactersListViewBuilderMock.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import Foundation

final class CharactersViewBuilderMock: CharactersViewBuilderProtocol {
    @MainActor
    func build() -> CharactersView {
        let urlSession = URLSessionMock(statusCode: 200)
        let network = NetworkClient(urlSession: urlSession)
        let remote = CharactersRemote(networkClient: network)
        let database = SwiftDataContainer(isStoredInMemoryOnly: true)
        let local = CharactersDatabase(database: database)
        let repository = CharactersRepository(remote: remote, database: local, utils: Utils())
        let useCase = CharactersUseCase(repository: repository)
        let viewModel = CharactersViewModel(useCase: useCase)
        return CharactersView(viewModel: viewModel)
    }
}
