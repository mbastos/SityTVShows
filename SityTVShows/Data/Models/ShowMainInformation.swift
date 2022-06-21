//
//  ShowMainInformation.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import Foundation

struct ShowMainInformation: Codable {
    let averageRuntime: Int?
    let genres: [String]?
    let id: Int
    let image: Image?
    let language: String?
    let name: String
    let rating: Rating?
    let schedule: ShowSchedule?
    let status: String
    let summary: String?
    let type: String?
}
