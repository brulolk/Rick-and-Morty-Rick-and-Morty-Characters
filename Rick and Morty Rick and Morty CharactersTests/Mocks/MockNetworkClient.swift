//
//  MockNetworkClient.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import Foundation
@testable import Rick_and_Morty_Rick_and_Morty_Characters

class MockNetworkClient: NetworkClientProtocol {
    // Armazena o que queremos que a função retorne ou lance
    var result: Result<Any, Error>?

    func execute<T: Codable>(_ endpoint: Endpoint) async throws -> T {
        guard let result = result else {
            fatalError("Result não configurado no Mock")
        }

        switch result {
        case .success(let data):
            guard let value = data as? T else {
                throw APIError.decodingError(NSError(domain: "Mock", code: 0))
            }
            return value
        case .failure(let error):
            throw error
        }
    }
}
