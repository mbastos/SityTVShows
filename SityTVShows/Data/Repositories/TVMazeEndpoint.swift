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
    case personCastCredits(personId: Int)
    
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
        case .personCastCredits(let personId):
            return "/people/\(personId)/castcredits"
        }
    }
    
    var query: [URLQueryItem]? {
        switch self {
        case .shows(let page):
            return [URLQueryItem(name: "page", value: String(page))]
        case .searchShows(let query), .searchPeople(let query):
            return [URLQueryItem(name: "q", value: query)]
        case .personCastCredits:
            return [URLQueryItem(name: "embed", value: "show")]
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
