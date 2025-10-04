//
//  SwiftDataContainerTest.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

import Foundation
import SwiftData
@testable import RickAndMorty

final class SwiftDataContainerTest: SwiftDataContainerProtocol {

    static let shared: SwiftDataContainerTest = SwiftDataContainerTest()

    private init() {}

    @MainActor
    var container: ModelContainer = getModelContainer(inMemory: true)

    @MainActor
    static func getModelContainer(inMemory: Bool) -> ModelContainer {
        do {
            let container = try ModelContainer(for: SDCharacter.self, SDLocation.self,
                                               configurations: ModelConfiguration(isStoredInMemoryOnly: inMemory))
            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }
}
