//
//  RickAndMortyServiceProtocol.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import Foundation

protocol RickAndMortyServiceProtocol {
    func fetchCharacters(page: Int, name: String?, status: CharacterStatus?) async throws -> CharacterResponse
    func fetchCharacterDetails(id: Int) async throws -> Character
}
