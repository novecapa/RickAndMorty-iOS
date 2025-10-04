//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

enum NetworkError: Error, Hashable {
    case badResponse
    case badRequest
    case serverError
    case badGateway
    case badURL
    case decodeError
}
