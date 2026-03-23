//
//  MockRickAndMortyService.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import Foundation
@testable import Rick_and_Morty_Rick_and_Morty_Characters

class MockRickAndMortyService: RickAndMortyServiceProtocol {
    func fetchCharacters(page: Int, name: String?, status: CharacterStatus?) async throws -> CharacterResponse {
        return CharacterResponse(info: Info(count: 0, pages: 0, next: nil), results: [])
    }
    
    func fetchCharacterDetails(id: Int) async throws -> Character {
        // Retorne um objeto Character fake aqui
        fatalError("Implementar se necessário para o teste de detalhe")
    }
}
