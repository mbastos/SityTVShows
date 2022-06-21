//
//  FavoriteShow.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation
import RealmSwift

class FavoriteShow: Object {
    @Persisted(primaryKey: true) var id: Int = 0
    @Persisted var name: String = ""
    
    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
}

extension Array where Element: FavoriteShow {
    func asDict() -> [Int: FavoriteShow] {
        return Dictionary(uniqueKeysWithValues: self.map({ ($0.id, $0) }))
    }
}
