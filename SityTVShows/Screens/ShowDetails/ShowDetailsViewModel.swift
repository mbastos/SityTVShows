//
//  ShowDetailsViewModel.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import Foundation
import RxSwift
import RxRelay

class ShowDetailsViewModel {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let repository: ShowsRepository
    private let showId: Int
    
    // MARK: - Actions
    private let onShowErrorRelay = PublishRelay<String>()
    private let onShowEpisodeRelay = PublishRelay<ShowEpisode>()
    private let onGoBackRelay = PublishRelay<Void>()
    
    // MARK: - State
    private let informationRelay = BehaviorRelay<ShowMainInformation?>(value: nil)
    private let episodesRelay = BehaviorRelay<[ShowEpisode]>(value: [])
    private let seasonsRelay = BehaviorRelay<[ShowSeason]?>(value: nil)
    private let loadingRelay = BehaviorRelay(value: false)
    
    // MARK: - Public Observables
    lazy var onShowError = onShowErrorRelay.asObservable()
    lazy var onShowEpisode = onShowEpisodeRelay.asObservable()
    lazy var onGoBack = onGoBackRelay.asObservable()
    lazy var isLoading = loadingRelay.asObservable().distinctUntilChanged()
    
    lazy var information = informationRelay.asObservable()
    lazy var infoAndEpisodes = Observable.combineLatest(informationRelay.asObservable(), seasonsRelay.asObservable())
    
    // MARK: - Initializers
    init(showId: Int, repository: ShowsRepository) {
        self.showId = showId
        self.repository = repository
    }
    
    // MARK: - External methods
    func didLoad() {
        loadData()
    }
    
    func didPressTryAgain() {
        loadData()
    }
    
    func didPressCancel() {
        onGoBackRelay.accept(())
    }
    
    func didSelectEpisode(atIndex index: Int, ofSeasonIndex seasonIndex: Int) {
        guard let seasons = seasonsRelay.value, seasonIndex < seasons.count else { return }
        
        let season = seasons[seasonIndex]
        
        guard index < season.episodes.count else { return }
        let episode = season.episodes[index]
        
        onShowEpisodeRelay.accept(episode)
    }
    
    // MARK: - Internal methods
    private func loadData() {
        let dispatchGroup = DispatchGroup()
        
        loadingRelay.accept(true)
        
        loadMainInformation(dispatchGroup: dispatchGroup)
        loadEpisodes(dispatchGroup: dispatchGroup)
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.loadingRelay.accept(false)
        }
    }
    
    private func loadMainInformation(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        
        repository.getShowMainInformation(showId: showId) { [weak self] (result) in
            dispatchGroup.leave()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let information):
                self.informationRelay.accept(information)
            case .failure:
                self.onShowErrorRelay.accept("An error has occurred while fetching information from the show.")
            }
        }
    }
    
    private func loadEpisodes(dispatchGroup: DispatchGroup) {
        dispatchGroup.enter()
        
        repository.getShowEpisodes(showId: showId) { [weak self] (result) in
            dispatchGroup.leave()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let episodes):
                self.mapEpisodesToSeasons(episodes: episodes.map({ ShowEpisode(fromResponse: $0) }))
            case .failure:
                self.onShowErrorRelay.accept("An error has occurred while fetching the episodes list.")
            }
        }
    }
    
    private func mapEpisodesToSeasons(episodes: [ShowEpisode]) {
        let grouped = Dictionary(grouping: episodes, by: { $0.season })
        
        let seasons = grouped.map({ season, episodes in
            return ShowSeason(number: season, episodes: episodes.sorted(by: { $0.number < $1.number }))
        }).sorted(by: { $0.number < $1.number })
        
        seasonsRelay.accept(seasons)
    }
}
