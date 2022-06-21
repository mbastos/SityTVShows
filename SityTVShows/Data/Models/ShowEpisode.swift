//
//  ShowEpisode.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation

class ShowEpisode {
    let airdate: Date?
    let id: Int
    let image: Image?
    let name: String
    let number: Int
    let rating: Rating?
    let runtime: Int?
    let season: Int
    let summary: String?
    
    init(fromResponse response: ShowEpisodeResponse) {
        self.airdate = response.airdate
        self.id = response.id
        self.image = response.image
        self.name = response.name
        self.number = response.number
        self.rating = response.rating
        self.runtime = response.runtime
        self.season = response.season
        self.summary = response.summary
    }
}
