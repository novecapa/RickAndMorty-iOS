//
//  SwiftDataContainer.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation
import SwiftData

// MARK: SwiftDataContainerProtocol

protocol SwiftDataContainerProtocol {
    var container: ModelContainer { get }
}

// MARK: SwiftDataContainer

final class SwiftDataContainer: SwiftDataContainerProtocol {

    internal let container: ModelContainer

    init(isStoredInMemoryOnly: Bool) {
        if let disk = try? ModelContainer(
            for: SDCharacter.self, SDLocation.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
        ) {
            self.container = disk
        } else if let memory = try? ModelContainer(
            for: SDCharacter.self, SDLocation.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        ) {
            assertionFailure("Falling back to in-memory ModelContainer")
            self.container = memory
        } else {
            assertionFailure("Unable to create any ModelContainer")
            preconditionFailure("ModelContainer creation failed")
        }
    }
}
