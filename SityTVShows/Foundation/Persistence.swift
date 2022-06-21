//
//  Persistence.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation
import RealmSwift

class Persistence {
    static let shared = Persistence()
    let realm: Realm
    private(set) var favoriteShows: [Int: FavoriteShow]
    
    private init() {
        do {
            realm = try Realm()
        } catch let error {
            fatalError("Failed to create Realm instance: \(error)")
        }
        
        favoriteShows = realm.objects(FavoriteShow.self).sorted(by: { $0.name < $1.name }).asDict()
    }
    
    private func refreshFavorites() {
        favoriteShows = realm.objects(FavoriteShow.self).sorted(by: { $0.name < $1.name }).asDict()
    }
    
    func favorite(withId id: Int) -> FavoriteShow? {
        return realm.object(ofType: FavoriteShow.self, forPrimaryKey: id)
    }
    
    func addFavorite(withId id: Int, andName name: String) {
        let favoriteShow = FavoriteShow(id: id, name: name)
        try! realm.write {
            realm.add(favoriteShow)
        }
        
        refreshFavorites()
    }
    
    func removeFavorite(withId id: Int) {
        guard let favoriteShow = favorite(withId: id) else { return }
        try! realm.write {
            realm.delete(favoriteShow)
        }
        
        refreshFavorites()
    }
}
