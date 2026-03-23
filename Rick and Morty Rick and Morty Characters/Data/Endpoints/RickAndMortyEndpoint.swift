//
//  RickAndMortyEndpoint.swift
//  Rick and Morty Rick and Morty Characters
//
//  Created by Bruno Vinicius on 20/03/26.
//

import Foundation

enum RickAndMortyEndpoint: Endpoint {
    case listCharacters(page: Int, name: String?, status: String?)
    case characterDetail(id: Int)
    
    var baseURL: String { "https://rickandmortyapi.com" }
        
    var path: String {
        switch self {
        case .listCharacters:
            return "/api/character"
        case .characterDetail(let id):
            return "/api/character/\(id)"
        }
    }
    
    var method: String { "GET" }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .listCharacters(let page, let name, let status):
            var items = [URLQueryItem(name: "page", value: "\(page)")]
            if let name = name { items.append(URLQueryItem(name: "name", value: name)) }
            if let status = status { items.append(URLQueryItem(name: "status", value: status)) }
            return items
        default: return nil
        }
    }
}
