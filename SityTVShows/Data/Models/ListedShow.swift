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
