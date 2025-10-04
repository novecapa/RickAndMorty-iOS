//
//  URLSessionMock.swift
//  RickAndMorty
//
//  Created by Josep Cerdá Penadés on 3/10/25.
//

import Foundation

final class URLSessionMock: URLSessionProtocol {

    private enum Constants {
        static let jsonExt = "json"
    }

    private let statusCode: Int

    init(statusCode: Int) {
        self.statusCode = statusCode
    }

    func getDataFrom<T>(_ request: URLRequest,
                        type: T.Type) async throws -> (Data, URLResponse) where T: Decodable {

        let filename: String = {
            let nameType = "\(T.self)"
            if let startRange = nameType.range(of: "<"),
               let endRange = nameType.range(of: ">") {
                let subrange = startRange.upperBound..<endRange.lowerBound
                return String(nameType[subrange])
            }
            return nameType
        }()
        if let url = Bundle.main.url(forResource: filename,
                                     withExtension: Constants.jsonExt) {
            do {
                let data = try Data(contentsOf: url)
                guard let urlRequest = request.url else {
                    throw NetworkError.badRequest
                }
                let response = HTTPURLResponse(url: urlRequest,
                                               statusCode: statusCode,
                                               httpVersion: "HTTP/1.1",
                                               headerFields: nil)
                return (data, response ?? URLResponse())
            } catch {
                throw NetworkError.decodeError
            }
        } else {
            throw NetworkError.badURL
        }
    }
}
