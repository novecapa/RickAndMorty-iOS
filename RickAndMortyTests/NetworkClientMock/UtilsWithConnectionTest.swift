//
//  UtilsWithConnectionTest.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 4/10/25.
//

@testable import RickAndMorty

final class UtilsWithConnectionTest: UtilsProtocol {
    var existsConnection: Bool {
        true
    }
}

final class UtilsWithoutConnectionTest: UtilsProtocol {
    var existsConnection: Bool {
        false
    }
}
