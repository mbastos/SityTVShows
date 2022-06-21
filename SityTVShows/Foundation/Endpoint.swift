//
//  Endpoint.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import Foundation

enum EndpointMethod: String {
    case get
    case delete
    case post
    case put
    
    var httpMethod: String {
        return self.rawValue.uppercased()
    }
}

enum EndpointBody {
    case jsonEncoded(Codable)
}

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var query: [URLQueryItem]? { get }
    var method: EndpointMethod { get }
    var body: Data? { get }
}

extension Endpoint {
    var fullURL: URL? {
        guard var components = URLComponents(string: baseURL) else { return nil }
        
        components.path += path
        components.queryItems = query
        
        return components.url
    }
}
