//
//  ShowSeason.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation

class ShowSeason: CustomStringConvertible {
    let number: Int
    let episodes: [ShowEpisode]
    
    init(number: Int, episodes: [ShowEpisode]) {
        self.number = number
        self.episodes = episodes
    }
    
    var description: String {
        return "Season \(number)"
    }
}
