//
//  CharactersViewModel.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import SwiftUI

final class CharactersViewModel: ObservableObject {

    @Published var characters: [Character] = []

    private var debounceTimer: Timer?
    private let debounceInterval: TimeInterval
    @Published var searchText: String {
        didSet {
            debounceTimer?.invalidate()
            debounceTimer = Timer.scheduledTimer(withTimeInterval: debounceInterval,
                                                 repeats: false) { [weak self] _ in
                guard let self = self else { return }
                self.performSearch()
            }
        }
    }
    @Published var scrollToTop: Bool = false
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var showDetail: Bool = false
    var selectedCharacter: Character? = nil {
        didSet {
            guard selectedCharacter != nil else { return }
            showDetail = true
        }
    }

    @Published var isLoading = false
    private(set) var currentPage = 1
    private var hasNewPage = true

    private let useCase: CharactersUseCaseProtocol

    init (useCase: CharactersUseCaseProtocol,
          debounceInterval: TimeInterval = 0.75) {
        self.useCase = useCase
        self.searchText = ""
        self.debounceInterval = debounceInterval
    }
}

// MARK: - Private extensions

// MARK: - Pagination

private extension CharactersViewModel {
    func resetPagination() {
        currentPage = 1
        hasNewPage = true
        scrollToTop = true
    }

    var canLoadNewPage: Bool {
        hasNewPage && !isLoading
    }
}

// MARK: - Result handler

private extension CharactersViewModel {
    func handleError(_ error: Error) {
        showAlert = true
        errorMessage = error.localizedDescription
    }

    func populateResult(result: Characters) {
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

// MARK: - Search

private extension CharactersViewModel {
    func performSearch() {
        if searchText.count > 1 {
            resetPagination()
            searchCharacters()
        } else if searchText.isEmpty {
            resetPagination()
            fetchCharacters()
        }
    }

    func searchCharacters() {
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
}

// MARK: - Public methods

extension CharactersViewModel {
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
