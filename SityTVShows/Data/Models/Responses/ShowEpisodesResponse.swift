//
//  ShowEpisodesResponse.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import Foundation

typealias ShowEpisodesResponse = [ShowEpisodeResponse]

struct ShowEpisodeResponse: Codable {
    let airdate: Date?
    let id: Int
    let image: Image?
    let name: String
    let number: Int
    let rating: Rating?
    let runtime: Int?
    let season: Int
    let summary: String?
}

extension ShowEpisodeResponse {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let airdateString = try container.decodeIfPresent(String.self, forKey: .airdate)
        if let airdateString = airdateString, !airdateString.isEmpty {
            let formatter = DateFormatter.yyyyMMdd
            if let date = formatter.date(from: airdateString) {
                airdate = date
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: .airdate,
                    in: container,
                    debugDescription: "Unexpected date format.")
            }
        } else {
            airdate = nil
        }
        
        
        id = try container.decode(Int.self, forKey: .id)
        image = try container.decodeIfPresent(Image.self, forKey: .image)
        name = try container.decode(String.self, forKey: .name)
        number = try container.decode(Int.self, forKey: .number)
        rating = try container.decodeIfPresent(Rating.self, forKey: .rating)
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime)
        season = try container.decode(Int.self, forKey: .season)
        summary = try container.decodeIfPresent(String.self, forKey: .summary)
    }
}
