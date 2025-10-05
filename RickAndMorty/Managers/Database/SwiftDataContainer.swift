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
    
    let container: ModelContainer
    
    init(isStoredInMemoryOnly: Bool = false) {
        do {
            self.container = try ModelContainer(
                for: SDCharacter.self, SDLocation.self,
                configurations: ModelConfiguration(isStoredInMemoryOnly: isStoredInMemoryOnly)
            )
        } catch {
            assertionFailure("Persistent ModelContainer creation failed: \(error). Falling back to in-memory storage.")
            do {
                self.container = try ModelContainer(
                    for: SDCharacter.self, SDLocation.self,
                    configurations: ModelConfiguration(isStoredInMemoryOnly: true)
                )
            } catch {
                preconditionFailure("Unable to create even in-memory ModelContainer: \(error)")
            }
        }
    }
}
