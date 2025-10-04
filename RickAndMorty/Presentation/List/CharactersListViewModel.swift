//
//  CharactersListViewModel.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import SwiftUI

final class CharactersListViewModel: ObservableObject {

    @Published var characters: [Character] = []
    @Published var searchText: String {
        didSet {
            if searchText.count > 1 {
                resetPagination()
                searchCharacters()
            } else if searchText.isEmpty {
                resetPagination()
                fetchCharacters()
            }
        }
    }
    @Published var scrollToTop: Bool = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    private var isLoading = false
    private(set) var currentPage = 1
    private var hasNewPage = true

    private let useCase: CharactersUseCaseProtocol

    init (useCase: CharactersUseCaseProtocol) {
        self.useCase = useCase
        self.searchText = ""
    }

    private func resetPagination() {
        currentPage = 1
        hasNewPage = true
        scrollToTop = true
    }

    private var canLoadNewPage: Bool {
        hasNewPage && !isLoading
    }

    private func handleError(_ error: Error) {
        showAlert = true
        errorMessage = error.localizedDescription
    }

    private func searchCharacters() {
        guard canLoadNewPage else { return }

        Task { @MainActor in
            do {
                defer { isLoading = false }
                isLoading = true
                let result = try await useCase.searchCharacters(for: searchText, page: currentPage)
                populateResult(result: result)
            } catch {
                handleError(error)
            }
        }
    }

    private func populateResult(result: Characters) {
        if currentPage == 1 {
            characters.removeAll()
            characters.append(contentsOf: result.characters)
        } else {
            characters.append(contentsOf: result.characters)
        }
        currentPage += result.addNewPage
        hasNewPage = result.hasNextPage
    }
}

// MARK: Public methods

extension CharactersListViewModel {
    func fetchCharacters() {
        guard canLoadNewPage else { return }
        guard searchText.count <= 1 else {
            searchCharacters()
            return
        }
        Task { @MainActor in
            do {
                defer { isLoading = false }
                isLoading = true
                let result = try await useCase.getCharacters(page: currentPage)
                populateResult(result: result)
            } catch {
                handleError(error)
            }
        }
    }
}
