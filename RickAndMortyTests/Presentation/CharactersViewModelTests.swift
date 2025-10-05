//
//  CharactersViewModelTests.swift
//  RickAndMortyTests
//
//  Created by Josep Cerdá Penadés on 5/10/25.
//

import Foundation

import XCTest
import Combine
@testable import RickAndMorty

final class CharactersViewModelTests: XCTestCase {

    enum Constants {
        static let searchString = "Rick Sanchez"
        static let testTimeOut: TimeInterval = 3
    }

    var urlSession: URLSessionTest!
    var utils: UtilsWithConnectionTest!
    var networkClient: NetworkClient!
    var remoteData: CharactersRemote!
    var database: CharactersDatabase!
    var remoteRepository: CharactersRepository!
    var useCase: CharactersUseCase!
    var viewModel: CharactersViewModel!
    var bag = Set<AnyCancellable>()

    @MainActor
    override func setUp() {
        self.urlSession = URLSessionTest(statusCode: 200)
        self.networkClient = NetworkClient(urlSession: urlSession)
        self.remoteData = CharactersRemote(networkClient: networkClient)
        self.database = CharactersDatabase(database: SwiftDataContainerTest.shared)
        self.utils = UtilsWithConnectionTest()
        self.remoteRepository = CharactersRepository(remote: remoteData,
                                                     database: database,
                                                     utils: utils)
        self.useCase = CharactersUseCase(repository: remoteRepository)
        self.viewModel = CharactersViewModel(useCase: useCase, debounceInterval: 0)
    }

    override func tearDown() {
        urlSession = nil
        utils = nil
        networkClient = nil
        remoteData = nil
        database = nil
        remoteRepository = nil
        useCase = nil
        viewModel = nil
        bag.removeAll()
    }
    
    @MainActor
    func test_viewmodel_fetch() {
        // Given: ViewModel con pipeline real y debounce=0; observamos 'characters' esperando la primera lista no vacía
        let exp = expectation(description: "characters filled")

        viewModel.$characters
            .dropFirst()
            .filter { !$0.isEmpty }
            .prefix(1)
            .receive(on: RunLoop.main)
            .sink { chars in
                XCTAssertGreaterThan(chars.count, 0)
                exp.fulfill()
            }
            .store(in: &bag)

        // When: solicitamos la primera página
        viewModel.fetchCharacters()

        // Then: recibimos resultados y la paginación avanza
        wait(for: [exp], timeout: Constants.testTimeOut)
        XCTAssertEqual(viewModel.currentPage, 2)
    }

    @MainActor
    func test_view_model_search() {
        // Given: reconfiguramos entorno para búsqueda (URLSessionTestSearch), VM con debounce=0 y suscripción a 'characters' (primera lista no vacía)
        let urlSession = URLSessionTestSearch(statusCode: 200)
        networkClient = NetworkClient(urlSession: urlSession)
        remoteData = CharactersRemote(networkClient: networkClient)
        database = CharactersDatabase(database: SwiftDataContainerTest.shared)
        utils = UtilsWithConnectionTest()
        remoteRepository = CharactersRepository(remote: remoteData,
                                                database: database,
                                                utils: utils)
        useCase = CharactersUseCase(repository: remoteRepository)
        viewModel = CharactersViewModel(useCase: useCase, debounceInterval: 0)

        let exp = expectation(description: "search results filled")

        viewModel.$characters
            .dropFirst()
            .filter { !$0.isEmpty }
            .prefix(1)
            .receive(on: RunLoop.main)
            .sink { chars in
                XCTAssertGreaterThan(chars.count, 0)
                exp.fulfill()
            }
            .store(in: &bag)

        // When: establecemos el texto de búsqueda (>1 char) para disparar 'performSearch'
        viewModel.searchText = Constants.searchString

        // Then: recibimos resultados de búsqueda, la página permanece en 1 y 'scrollToTop' se activa
        wait(for: [exp], timeout: Constants.testTimeOut)
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.scrollToTop)
    }
    
    @MainActor
    func test_select_character_sets_show_detail_true() {
        // Given: 'showDetail' comienza en false
        XCTAssertFalse(viewModel.showDetail)
        let character: Character = .mock
        // When: asignamos un Character como seleccionado
        viewModel.selectedCharacter = character
        // Then: 'showDetail' pasa a true
        XCTAssertTrue(viewModel.showDetail)
    }
    
    func test_get_remote_characters_not_empty() async throws {
        do {
            // When
            let res = try await useCase.getCharacters(page: 0)

            // Then
            XCTAssertGreaterThan(res.characters.count, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    @MainActor
    func test_search_remote_characters_not_empty() async throws {
        do {
            // Given
            let urlSession = URLSessionTestSearch(statusCode: 200)
            networkClient = NetworkClient(urlSession: urlSession)
            remoteData = CharactersRemote(networkClient: networkClient)
            database = CharactersDatabase(database: SwiftDataContainerTest.shared)
            utils = UtilsWithConnectionTest()
            remoteRepository = CharactersRepository(remote: remoteData,
                                                    database: database,
                                                    utils: utils)
            useCase = CharactersUseCase(repository: remoteRepository)

            // When
            let res = try await useCase.searchCharacters(for: Constants.searchString,
                                                         page: 1)

            // Then
            XCTAssertEqual(res.characters.count, 1)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    @MainActor
    func test_search_remote_characters_empty() async throws {
        do {
            // Given
            let urlSession = URLSessionTestEmpty(statusCode: 200)
            networkClient = NetworkClient(urlSession: urlSession)
            remoteData = CharactersRemote(networkClient: networkClient)
            database = CharactersDatabase(database: SwiftDataContainerTest.shared)
            utils = UtilsWithConnectionTest()
            remoteRepository = CharactersRepository(remote: remoteData,
                                                    database: database,
                                                    utils: utils)
            useCase = CharactersUseCase(repository: remoteRepository)

            // When
            let res = try await useCase.searchCharacters(for: "", page: 1)

            // Then
            XCTAssertEqual(res.characters.count, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    @MainActor
    func test_save_characters_in_databse() async throws {
        do {
            // Given
            let list = try await useCase.getCharacters(page: 1)

            // When
            let dbList = try database.getCharacters()

            // Then
            XCTAssertEqual(list.characters.count, dbList.count)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    @MainActor
    func test_search_characters_from_databse_not_empty_result() async throws {
        do {
            // Given
            _ = try await useCase.getCharacters(page: 1)

            // When
            let dbSearch = try database.searchCharacter(for: Constants.searchString)

            // Then
            XCTAssertEqual(dbSearch.count, 1)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    @MainActor
    func test_search_characters_from_databse_empty_result() async throws {
        do {
            // Given
            _ = try await useCase.getCharacters(page: 1)

            // When
            let dbSearch = try database.searchCharacter(for: "")

            // Then
            XCTAssertEqual(dbSearch.count, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    @MainActor
    func test_delete_characters_from_databse() async throws {
        do {
            // Given
            _ = try await remoteRepository.getCharacters(page: 1)

            // When
            try database.deleteAllCharacters()
            let dbList = try database.getCharacters()

            // Then
            XCTAssertEqual(dbList.count, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    @MainActor
    func test_get_characters_status_400() {
        // Given
        let urlSession = URLSessionTest(statusCode: 400)
        networkClient = NetworkClient(urlSession: urlSession)
        remoteData = CharactersRemote(networkClient: networkClient)
        database = CharactersDatabase(database: SwiftDataContainerTest.shared)
        utils = UtilsWithConnectionTest()
        remoteRepository = CharactersRepository(remote: remoteData,
                                                database: database,
                                                utils: utils)
        useCase = CharactersUseCase(repository: remoteRepository)
        viewModel = CharactersViewModel(useCase: useCase)

        // When
        viewModel.fetchCharacters()

        // Then
        let exp = expectation(description: "alert shown")
        viewModel.$showAlert
            .dropFirst()
            .sink { shown in
                if shown { exp.fulfill() }
            }
            .store(in: &bag)

        wait(for: [exp], timeout: Constants.testTimeOut)
        XCTAssertEqual(viewModel.characters.count, 0)
    }

    @MainActor
    func test_get_characters_status_500() {
        // Given
        let urlSession = URLSessionTest(statusCode: 500)
        networkClient = NetworkClient(urlSession: urlSession)
        remoteData = CharactersRemote(networkClient: networkClient)
        database = CharactersDatabase(database: SwiftDataContainerTest.shared)
        utils = UtilsWithConnectionTest()
        remoteRepository = CharactersRepository(remote: remoteData,
                                                database: database,
                                                utils: utils)
        useCase = CharactersUseCase(repository: remoteRepository)
        viewModel = CharactersViewModel(useCase: useCase)

        // When
        viewModel.fetchCharacters()

        // Then
        let exp = expectation(description: "alert shown")
        viewModel.$showAlert
            .dropFirst()
            .sink { shown in
                if shown { exp.fulfill() }
            }
            .store(in: &bag)

        wait(for: [exp], timeout: Constants.testTimeOut)
        XCTAssertEqual(viewModel.characters.count, 0)
    }

    @MainActor
    func test_get_characters_without_internet() {
        do {
            // Given
            let urlSession = URLSessionTest(statusCode: 200)
            networkClient = NetworkClient(urlSession: urlSession)
            remoteData = CharactersRemote(networkClient: networkClient)
            database = CharactersDatabase(database: SwiftDataContainerTest.shared)
            let utils = UtilsWithoutConnectionTest()
            remoteRepository = CharactersRepository(remote: remoteData,
                                                    database: database,
                                                    utils: utils)
            useCase = CharactersUseCase(repository: remoteRepository)
            viewModel = CharactersViewModel(useCase: useCase)
            try database.deleteAllCharacters()

            // When
            viewModel.fetchCharacters()

            // Then
            let exp = expectation(description: "fetch completed")
            viewModel.$isLoading
                .dropFirst()
                .filter { $0 == false }
                .sink { _ in
                    exp.fulfill()
                }
                .store(in: &bag)

            wait(for: [exp], timeout: Constants.testTimeOut)
            XCTAssertEqual(self.viewModel.characters.count, 0)
            XCTAssertFalse(self.viewModel.showAlert)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    @MainActor
    func test_search_characters_without_internet() async throws {
        do {
            // Given
            let urlSession = URLSessionTest(statusCode: 200)
            networkClient = NetworkClient(urlSession: urlSession)
            remoteData = CharactersRemote(networkClient: networkClient)
            database = CharactersDatabase(database: SwiftDataContainerTest.shared)
            let utils = UtilsWithoutConnectionTest()
            remoteRepository = CharactersRepository(remote: remoteData,
                                                    database: database,
                                                    utils: utils)
            useCase = CharactersUseCase(repository: remoteRepository)
            try database.deleteAllCharacters()

            // When
            let res = try await useCase.searchCharacters(for: Constants.searchString,
                                                         page: 1)

            // Then
            XCTAssertEqual(res.characters.count, 0)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    @MainActor
    func test_error_sets_alert_and_message_on_fetch() {
        // Given
        let urlSession = URLSessionTest(statusCode: 500)
        networkClient = NetworkClient(urlSession: urlSession)
        remoteData = CharactersRemote(networkClient: networkClient)
        database = CharactersDatabase(database: SwiftDataContainerTest.shared)
        utils = UtilsWithConnectionTest()
        remoteRepository = CharactersRepository(remote: remoteData,
                                                database: database,
                                                utils: utils)
        useCase = CharactersUseCase(repository: remoteRepository)
        viewModel = CharactersViewModel(useCase: useCase, debounceInterval: 0)
        let exp = expectation(description: "alert shown")

        viewModel.$showAlert
            .dropFirst()
            .sink { shown in
                if shown { exp.fulfill() }
            }
            .store(in: &bag)

        // When
        viewModel.fetchCharacters()

        // Then
        wait(for: [exp], timeout: Constants.testTimeOut)
        XCTAssertFalse(viewModel.errorMessage.isEmpty)
    }

    @MainActor
    func test_is_loading_toggles_around_fetch() {
        // Given
        var states: [Bool] = []
        let exp = expectation(description: "loading toggled off")

        viewModel.$isLoading
            .dropFirst()
            .sink { value in
                states.append(value)
                if states.count >= 2 { // true then false
                    exp.fulfill()
                }
            }
            .store(in: &bag)

        // When
        viewModel.fetchCharacters()

        // Then
        wait(for: [exp], timeout: 1.0)
        XCTAssertEqual(states.first, true)
        XCTAssertEqual(states.last, false)
    }

    @MainActor
    func test_search_sets_scroll_to_top_true() {
        // Given
        XCTAssertFalse(viewModel.scrollToTop)
        let exp = expectation(description: "scrollToTop set")

        viewModel.$scrollToTop
            .dropFirst()
            .sink { value in
                if value { exp.fulfill() }
            }
            .store(in: &bag)

        // When
        viewModel.searchText = "Ri" // > 1 char triggers search

        // Then
        wait(for: [exp], timeout: Constants.testTimeOut)
        XCTAssertTrue(viewModel.scrollToTop)
    }
}
