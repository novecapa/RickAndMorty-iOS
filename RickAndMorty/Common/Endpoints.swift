//
//  Endpoints.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

enum Endpoints {

    // MARK: Base URL

    private static let baseURL = "https://rickandmortyapi.com/api/"

    case character

    var rawValue: String {
        switch self {
        case .character:
            return Endpoints.baseURL + "character"
        }
    }
}
