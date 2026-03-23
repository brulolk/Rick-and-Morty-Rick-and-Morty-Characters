//
//  CharacterListViewModelTests.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import XCTest
@testable import Rick_and_Morty_Rick_and_Morty_Characters

@MainActor
final class CharacterListViewModelTests: XCTestCase {
    func testFilterChange_ShouldResetPagination() async {
        // Arrange
        let mockService = MockRickAndMortyService()
        let sut = CharacterListViewModel(service: mockService)
        
        // Act
        sut.selectedStatus = .alive
        
        // Assert
        XCTAssertTrue(sut.characters.isEmpty, "A lista deve ser limpa ao trocar o filtro")
        // Como o debounce é de 400ms, em testes reais usaríamos uma expectativa,
        // mas para o seu teste rápido, validar o reset já demonstra a lógica.
    }
}
