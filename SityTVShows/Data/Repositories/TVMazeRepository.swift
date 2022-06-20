//
//  TVMazeRepository.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import Foundation

protocol ShowsRepository {
    func listShows(page: Int, completion: @escaping (Result<[ListedShow], Error>) -> Void)
}

class TVMazeRepository: ShowsRepository {
    static let baseURL = "https://api.tvmaze.com/"
    
    func listShows(
        page: Int = 0,
        completion: @escaping (Result<[ListedShow], Error>) -> Void
    ) {
        let url = TVMazeRepository.baseURL + "shows?page=\(page)"
        Networking.request(responseType: [ListedShow].self, urlString: url) { response in
            switch response {
            case .success(let shows):
                completion(.success(shows))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
