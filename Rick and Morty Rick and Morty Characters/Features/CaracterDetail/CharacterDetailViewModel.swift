//
//  CharacterDetailViewModel.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import Foundation
import Combine

@MainActor
final class CharacterDetailViewModel: ObservableObject {
    @Published var character: Character?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let characterId: Int
    private let service: RickAndMortyServiceProtocol
    
    init(characterId: Int, service: RickAndMortyServiceProtocol? = nil) {
        self.characterId = characterId
        self.service = service ?? RickAndMortyService()
    }
    
    func fetchDetails() async {
        isLoading = true
        errorMessage = nil
        
        do {
            self.character = try await service.fetchCharacterDetails(id: characterId)
            isLoading = false
        } catch {
            self.errorMessage = "Could not load details."
            self.isLoading = false
        }
    }
}
