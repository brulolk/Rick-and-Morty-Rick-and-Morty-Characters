//
//  CharacterListViewModel.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import Foundation
import Combine

@MainActor
final class CharacterListViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var characters: [Character] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = "" {
        didSet { setupSearchDebounce() }
    }
    @Published var selectedStatus: CharacterStatus? {
        didSet {
            debouncer.run { [weak self] in
                self?.resetAndFetch()
            }
        }
    }
    
    // MARK: - Private Properties
    private var currentPage = 1
    private var canLoadMore = true
    private let service: RickAndMortyServiceProtocol
    private let debouncer = Debouncer(delay: .milliseconds(400))
    
    // MARK: - Initializer
    // Injeção de dependência para garantir testabilidade
    init(service: RickAndMortyServiceProtocol? = nil) {
        self.service = service ?? RickAndMortyService()
    }
    
    // MARK: - Public Methods
    func fetchInitialCharacters() async {
        guard characters.isEmpty else { return }
        await fetchCharacters()
    }
    
    func fetchNextPageIfNeeded(currentCharacter item: Character) {
        // Lógica de Infinite Scroll: dispara quando faltam 3 itens para o fim
        let thresholdIndex = characters.index(characters.endIndex, offsetBy: -3)
        if characters.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            Task { await fetchCharacters() }
        }
    }
    
    func resetAndFetch() {
        currentPage = 1
        characters = []
        canLoadMore = true
        Task { await fetchCharacters() }
    }
    
    // MARK: - Private Methods
    private func fetchCharacters() async {
        guard !isLoading && canLoadMore else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await service.fetchCharacters(
                page: currentPage,
                name: searchText.isEmpty ? nil : searchText,
                status: selectedStatus
            )
            
            self.characters.append(contentsOf: response.results)
            self.currentPage += 1
            self.canLoadMore = response.info.next != nil
            self.isLoading = false
        } catch {
            self.errorMessage = "Failed to load characters. Tap to retry."
            self.isLoading = false
        }
    }
    
    private func setupSearchDebounce() {
        debouncer.run { [weak self] in
            self?.resetAndFetch()
        }
    }
}
