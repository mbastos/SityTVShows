//
//  Rating.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import Foundation

struct Rating: Codable {
    let average: Double?
    
    // The data comes on a scale from 0 to 10, but we display it on 5 stars only.
    var averageOnScaleOfFive: Double? {
        return average.map({ $0 / 2 })
    }
    
    var formattedAverage: String? {
        return averageOnScaleOfFive.map({ String($0) })
    }
    
    var fullFormattedAverage: String? {
        return averageOnScaleOfFive.map({ "\($0) out of 5" })
    }
}
