//
//  SwiftDataContainer.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation
import SwiftData

// MARK: Protocol

protocol SwiftDataContainerProtocol {
    var container: ModelContainer { get }
}

final class SwiftDataContainer: SwiftDataContainerProtocol {

    internal let container: ModelContainer

    init(isStoredInMemoryOnly: Bool) {
        do {
            self.container = try ModelContainer(
                for: SDCharacter.self, SDLocation.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
            )
        } catch {
            fatalError("Failed to create model container: \(error.localizedDescription)")
        }
    }
}
