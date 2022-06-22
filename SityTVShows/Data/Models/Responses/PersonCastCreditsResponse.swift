//
//  PersonCastCreditsResponse.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation

typealias PersonCastCreditsResponse = [PersonCastCreditsResponseItem]

struct PersonCastCreditsResponseItem: Codable {
    let embedded: EmbeddedShow
    
    public enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct EmbeddedShow: Codable {
    let show: ListedShow
}
