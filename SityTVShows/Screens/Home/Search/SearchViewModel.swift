//
//  SearchViewModel.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

enum SearchType: CustomStringConvertible, CaseIterable {
    case shows
    case people
    
    var description: String {
        switch self {
        case .shows:
            return "Shows"
        case .people:
            return "People"
        }
    }
}

enum SearchResultItem {
    case show(ListedShow)
    case person(Person)
}

class SearchViewModel {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let repository: ShowsRepository
    
    private let observableQueue = ObservableQueue()
    
    // MARK: - Actions
    private let onShowErrorRelay = PublishRelay<String>()
    private let onGoToShowDetailsRelay = PublishRelay<ShowDetailsViewModel>()
    private let onGoToPersonDetailsRelay = PublishRelay<PersonDetailsViewModel>()
    
    // MARK: - State
    private let itemsRelay = BehaviorRelay<[SearchResultItem]>(value: [])
    private let loadingRelay = BehaviorRelay(value: false)
    
    let queryText = BehaviorRelay<String>(value: "")
    let searchType = BehaviorRelay<SearchType>(value: .shows)
    
    private lazy var debouncedQuery = queryText.debounce(.milliseconds(500), scheduler: MainScheduler.instance)
    
    // MARK: - Public Observables
    lazy var onShowError = onShowErrorRelay.asSignal()
    lazy var onGoToShowDetails = onGoToShowDetailsRelay.asObservable()
    lazy var onGoToPersonDetails = onGoToPersonDetailsRelay.asObservable()
    
    lazy var items = itemsRelay.asDriver()
    lazy var isLoading = loadingRelay.asDriver().distinctUntilChanged()
    
    var shouldDisplayEmptyView: Driver<Bool> {
        return Driver.combineLatest(
            debouncedQuery.asDriver(onErrorJustReturn: ""),
            itemsRelay.asDriver(),
            loadingRelay.asDriver()
        ) { (query, items, isLoading) in
            return !query.isEmpty && items.isEmpty && !isLoading
        }
    }
    
    // MARK: - Initializers
    init(repository: ShowsRepository) {
        self.repository = repository
        
        Observable.combineLatest(debouncedQuery.distinctUntilChanged(), searchType.distinctUntilChanged().asObservable())
            .subscribe(onNext: { [weak self] (text, _) in
                self?.enqueueDataLoad(query: text)
            }).disposed(by: disposeBag)
    }
    
    // MARK: - External functions
    func didPressTryAgain() {
        if !loadingRelay.value {
            enqueueDataLoad(query: queryText.value)
        }
    }
    
    func didSelectItem(atIndex index: Int) {
        guard index < itemsRelay.value.count else { return }
        let item = itemsRelay.value[index]
        
        if case .show(let show) = item {
            let showViewModel = ShowDetailsViewModel(showId: show.id, repository: repository)
            onGoToShowDetailsRelay.accept(showViewModel)
        } else if case .person(let person) = item {
            let personViewModel = PersonDetailsViewModel(person: person, repository: repository)
            onGoToPersonDetailsRelay.accept(personViewModel)
        }
    }
    
    // MARK: - Internal functions
    private func enqueueDataLoad(query: String) {
        observableQueue
            .enqueue(loadData(query: query).asObservable())
            .subscribe(onNext: {})
            .disposed(by: disposeBag)
    }
    
    private func loadData(query: String) -> Single<Void> {
        guard query.count > 0 else {
            itemsRelay.accept([])
            return Single.just(())
        }
        
        return Single.create { single in
            
            self.loadingRelay.accept(true)
            
            let completion = { [weak self] in
                self?.loadingRelay.accept(false)
                single(.success(()))
            }
            
            if self.searchType.value == .shows {
                self.loadShows(query: query, completion: completion)
            } else {
                self.loadPeople(query: query, completion: completion)
            }
            
            return Disposables.create()
        }
    }
    
    private func loadShows(query: String, completion: @escaping () -> Void) {
        repository.searchShows(query: query) { [weak self] result in
            guard let self = self else { return }
                    
            switch result {
            case .success(let items):
                self.itemsRelay.accept(items.map({ .show($0.show) }))
            case .failure:
                self.onShowErrorRelay.accept("An error has occurred while searching for shows.")
            }
            
            completion()
        }
    }
    
    private func loadPeople(query: String, completion: @escaping () -> Void) {
        repository.searchPeople(query: query) { [weak self] result in
            guard let self = self else { return }
                    
            switch result {
            case .success(let items):
                self.itemsRelay.accept(items.map({ .person($0.person) }))
            case .failure:
                self.onShowErrorRelay.accept("An error has occurred while searching for people.")
            }
            
            completion()
        }
    }
}
