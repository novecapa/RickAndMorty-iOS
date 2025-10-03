//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badRequest
    case serverError
    case notFound
    case badResponse
    case decodeError
}
