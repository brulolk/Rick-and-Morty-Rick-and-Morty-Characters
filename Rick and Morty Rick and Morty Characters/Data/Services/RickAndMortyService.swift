//
//  RickAndMortyService.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import Foundation

final class RickAndMortyService: RickAndMortyServiceProtocol {
    private let client: NetworkClientProtocol
    
    // Injeção de dependência por construtor (Requisito Senior)
    public init(client: NetworkClientProtocol = NetworkClient()) {
        self.client = client
    }
    
    func fetchCharacters(page: Int, name: String?, status: CharacterStatus?) async throws -> CharacterResponse {
        let endpoint = RickAndMortyEndpoint.listCharacters(
            page: page,
            name: name,
            status: status?.rawValue.lowercased()
        )
        return try await client.execute(endpoint)
    }
    
    func fetchCharacterDetails(id: Int) async throws -> Character {
        let endpoint = RickAndMortyEndpoint.characterDetail(id: id)
        return try await client.execute(endpoint)
    }
}
