//
//  ListedShow.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import Foundation

struct ListedShow: Codable {
    let id: Int
    let name: String
    let image: Image?
    let rating: Rating?
}

struct Rating: Codable {
    let average: Double?
    
    // The data comes on a scale from 0 to 10, but we display it on 5 stars only.
    var averageOnScaleOfFive: Double? {
        return average.map({ $0 / 2 })
    }
    
    var formattedAverage: String? {
        return averageOnScaleOfFive.map({ String($0) })
    }
}
