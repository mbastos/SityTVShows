//
//  TVMazeRepository.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import Foundation

protocol ShowsRepository {
    func listShows(page: Int, completion: @escaping (Result<[ListedShow], Error>) -> Void)
    func getShowMainInformation(showId: Int, completion: @escaping (Result<ShowMainInformation, Error>) -> Void)
    func getShowEpisodes(showId: Int, completion: @escaping (Result<ShowEpisodesResponse, Error>) -> Void)
    func searchShows(query: String, completion: @escaping (Result<SearchShowsResponse, Error>) -> Void)
    func searchPeople(query: String, completion: @escaping (Result<SearchPeopleResponse, Error>) -> Void)
}

class TVMazeRepository: ShowsRepository {
    func listShows(
        page: Int = 0,
        completion: @escaping (Result<[ListedShow], Error>) -> Void
    ) {
        let endpoint = TVMazeEndpoint.shows(page: page)
        Networking.request(responseType: [ListedShow].self, endpoint: endpoint) { result in
            switch result {
            case .success(let shows):
                completion(.success(shows))
            case .failure(let error):
                Logging.logError(error: error)
                completion(.failure(error))
            }
        }
    }
    
    func getShowMainInformation(
        showId: Int,
        completion: @escaping (Result<ShowMainInformation, Error>) -> Void
    ) {
        let endpoint = TVMazeEndpoint.showMainInformation(showId: showId)
        Networking.request(responseType: ShowMainInformation.self, endpoint: endpoint) { result in
            switch result {
            case .success(let show):
                completion(.success(show))
            case .failure(let error):
                Logging.logError(error: error)
                completion(.failure(error))
            }
        }
    }
    
    func getShowEpisodes(
        showId: Int,
        completion: @escaping (Result<ShowEpisodesResponse, Error>) -> Void
    ) {
        let endpoint = TVMazeEndpoint.showEpisodes(showId: showId)
        Networking.request(responseType: ShowEpisodesResponse.self, endpoint: endpoint) { result in
            switch result {
            case .success(let show):
                completion(.success(show))
            case .failure(let error):
                Logging.logError(error: error)
                completion(.failure(error))
            }
        }
    }
    
    func searchShows(
        query: String,
        completion: @escaping (Result<SearchShowsResponse, Error>) -> Void
    ) {
        let endpoint = TVMazeEndpoint.searchShows(query: query)
        Networking.request(responseType: SearchShowsResponse.self, endpoint: endpoint) { result in
            switch result {
            case .success(let shows):
                completion(.success(shows))
            case .failure(let error):
                Logging.logError(error: error)
                completion(.failure(error))
            }
        }
    }
    
    func searchPeople(
        query: String,
        completion: @escaping (Result<SearchPeopleResponse, Error>) -> Void
    ) {
        let endpoint = TVMazeEndpoint.searchPeople(query: query)
        Networking.request(responseType: SearchPeopleResponse.self, endpoint: endpoint) { result in
            switch result {
            case .success(let people):
                completion(.success(people))
            case .failure(let error):
                Logging.logError(error: error)
                completion(.failure(error))
            }
        }
    }
}
