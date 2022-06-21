//
//  TVMazeEndpoint.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import Foundation

enum TVMazeEndpoint: Endpoint {
    case shows(page: Int)
    case showMainInformation(showId: Int)
    case showEpisodes(showId: Int)
    case searchShows(query: String)
    case searchPeople(query: String)
    
    var baseURL: String {
        return "https://api.tvmaze.com"
    }
    
    var path: String {
        switch self {
        case .shows:
            return "/shows"
        case .showMainInformation(let id):
            return "/shows/\(id)"
        case .showEpisodes(let id):
            return "/shows/\(id)/episodes"
        case .searchShows:
            return "/search/shows"
        case .searchPeople:
            return "/search/people"
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .shows(let page):
            return [URLQueryItem(name: "page", value: String(page))]
        case .searchShows(let query), .searchPeople(let query):
            return [URLQueryItem(name: "q", value: query)]
        case .showMainInformation, .showEpisodes:
            return nil
        }
    }
    
    var method: EndpointMethod {
        return .get
    }
    
    var body: Data? {
        return nil
    }
}
