//
//  ShowsViewModel.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import Foundation
import RxSwift
import RxRelay

class ShowsViewModel {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let repository: ShowsRepository
    private var currentPage = 0
    private var hasNextPage = true
    
    // MARK: - Actions
    private let onShowErrorRelay = PublishRelay<String>()
    private let onShowDetailsRelay = PublishRelay<Int>()
    
    // MARK: - State
    private let showsRelay = BehaviorRelay<[ListedShow]>(value: [])
    private let loadingRelay = BehaviorRelay(value: false)
    
    // MARK: - Public Observables
    lazy var onShowError = onShowErrorRelay.asObservable()
    lazy var onShowDetails = onShowDetailsRelay.asObservable()
    
    lazy var shows = showsRelay.asObservable()
    lazy var isLoading = loadingRelay.asObservable().distinctUntilChanged()
    
    // MARK: - Initializers
    init(repository: ShowsRepository) {
        self.repository = repository
    }
    
    // MARK: - External functions
    func didLoad() {
        loadCurrentPage()
    }
    
    func didPressTryAgain() {
        if !loadingRelay.value {
            loadCurrentPage()
        }
    }
    
    func didReachEnd() {
        if !loadingRelay.value && hasNextPage {
            currentPage += 1
            loadCurrentPage()
        }
    }
    
    func didSelectItem(atIndex index: Int) {
        guard index < showsRelay.value.count else { return }
        let item = showsRelay.value[index]
        
        onShowDetailsRelay.accept(item.id)
    }
    
    // MARK: - Internal functions
    private func loadCurrentPage() {
        loadingRelay.accept(true)
        
        repository.listShows(page: currentPage) { [weak self] result in
            guard let self = self else { return }
            
            self.loadingRelay.accept(false)
            
            switch result {
            case .success(let shows):
                if shows.count > 0 {
                    let newList = self.showsRelay.value + shows
                    self.showsRelay.accept(newList)
                } else {
                    // Empty list has been returned, which means there are no more items to be fetched
                    self.hasNextPage = false
                }
            case .failure(_):
                // TODO: proper logging
                self.onShowErrorRelay.accept("An error has occurred while fetching the shows list.")
            }
        }
    }
}
