//
//  RickAndMortyServiceTests.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import XCTest
@testable import Rick_and_Morty_Rick_and_Morty_Characters

@MainActor
final class RickAndMortyServiceTests: XCTestCase {
    func testFetchCharacters_Success_ShouldDecodeCorrectLevel() async throws {
        // Arrange
        let mockClient = MockNetworkClient()
        let expectedResponse = CharacterResponse(
            info: Info(count: 1, pages: 1, next: nil),
            results: [Character(id: 1, name: "Bob", status: .alive, species: "Alien", gender: "Male", origin: LocationInfo(name: "Unknow", url: ""), location: LocationInfo(name: "Unknow", url: ""), image: "", episode: [], url: "", created: "")]
        )
        mockClient.result = .success(expectedResponse)
        let sut = RickAndMortyService(client: mockClient)

        // Act
        let response = try await sut.fetchCharacters(page: 1, name: nil, status: nil)

        // Assert
        XCTAssertEqual(response.results.first?.name, "Bob")
    }
    
    func testFetchCharacters_RateLimit_ShouldReturnTooManyRequestsError() async {
        // Arrange
        let mockClient = MockNetworkClient()
        mockClient.result = .failure(APIError.tooManyRequests)
        let sut = RickAndMortyService(client: mockClient)

        // Act & Assert
        do {
            _ = try await sut.fetchCharacters(page: 1, name: nil, status: nil)
            XCTFail("Deveria ter lançado .tooManyRequests")
        } catch let error as APIError {
            if case .tooManyRequests = error {
                XCTAssert(true)
            } else {
                XCTFail("Erro retornado foi \(error), mas esperava .tooManyRequests")
            }
        } catch {
            XCTFail("Erro desconhecido")
        }
    }
}
