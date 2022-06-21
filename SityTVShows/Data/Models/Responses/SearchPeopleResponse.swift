//
//  SearchPeopleResponse.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation

typealias SearchPeopleResponse = [SearchPeopleResponseItem]

struct SearchPeopleResponseItem: Codable {
    let score: Double
    let person: Person
}
