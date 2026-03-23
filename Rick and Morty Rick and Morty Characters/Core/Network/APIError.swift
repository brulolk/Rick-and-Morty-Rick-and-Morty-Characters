//
//  APIError.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

enum APIError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
    case serverError(Int)
    case tooManyRequests
}
