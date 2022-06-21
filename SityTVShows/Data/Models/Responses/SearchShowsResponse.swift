//
//  SearchShowsResponse.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation

typealias SearchShowsResponse = [SearchShowsResponseItem]

struct SearchShowsResponseItem: Codable {
    let score: Double
    let show: ListedShow
}
