//
//  Person.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation

struct Person: Codable {
    let birthday: Date?
    let country: Country?
    let gender: String?
    let id: Int
    let image: Image?
    let name: String
}

struct Country: Codable {
    let name: String
}

extension Person {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let birthdayString = try container.decodeIfPresent(String.self, forKey: .birthday)
        let formatter = DateFormatter.yyyyMMdd
        if let birthdayString = birthdayString {
            if let date = formatter.date(from: birthdayString) {
                birthday = date
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: .birthday,
                    in: container,
                    debugDescription: "Unexpected date format.")
            }
        } else {
            birthday = nil
        }
        
        country = try container.decodeIfPresent(Country.self, forKey: .country)
        gender = try container.decodeIfPresent(String.self, forKey: .gender)
        id = try container.decode(Int.self, forKey: .id)
        image = try container.decodeIfPresent(Image.self, forKey: .image)
        name = try container.decode(String.self, forKey: .name)
    }
}
