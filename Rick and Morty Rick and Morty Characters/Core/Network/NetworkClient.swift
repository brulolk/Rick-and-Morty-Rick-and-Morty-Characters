//
//  NetworkClient.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import Foundation

protocol NetworkClientProtocol {
    func execute<T: Codable>(_ endpoint: Endpoint) async throws -> T
}

final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    
    // Tratando Snake Case globalmente no Client
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func execute<T: Codable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = buildURL(from: endpoint) else {
            print("❌ Invalid URL for path: \(endpoint.path)")
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method
        
        do {
            let (data, response) = try await session.data(for: request)
            
            // LOG DE DEBUG: Verificando o que está chegando
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("🚀 API Response JSON: \(jsonString)")
//            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ [Response Error] Could not cast to HTTPURLResponse")
                throw APIError.invalidResponse
            }
                
            print("📡 [Status Code] \(httpResponse.statusCode) for: \(url.absoluteString)")
            
            if httpResponse.statusCode == 429 {
                print("🚫 [Rate Limit] Too many requests. Waiting is needed.")
                throw APIError.tooManyRequests
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("⚠️ [Server Error] Status: \(httpResponse.statusCode)")
                throw APIError.serverError(httpResponse.statusCode)
            }
            
            return try decoder.decode(T.self, from: data)
        } catch let error as DecodingError {
            print("💾 [Decoding Error] Detail: \(error)")
            throw APIError.decodingError(error)
            
        } catch {
            print("🌐 [Network Error] \(error.localizedDescription)")
            throw APIError.networkError(error)
        }
    }
    
    private func buildURL(from endpoint: Endpoint) -> URL? {
        var components = URLComponents(string: endpoint.baseURL)
        components?.path = endpoint.path
        components?.queryItems = endpoint.queryItems
        return components?.url
    }
}
