//
//  ShowSchedule.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation

struct ShowSchedule: Codable {
    let days: [String]
    let time: String
    
    var formatted: String? {
        let lastDay = days.last ?? ""
        let remainingDays = days.dropLast().joined(separator: ", ")
                
        let formattedDays = [remainingDays, lastDay].filter({ !$0.isEmpty }).joined(separator: " and ")
        
        if !formattedDays.isEmpty && !time.isEmpty {
            return "\(formattedDays) at \(time)"
        } else if !time.isEmpty {
            return time
        } else {
            return nil
        }
    }
}
