//
//  PersonDetailsViewModel.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import Foundation
import RxSwift
import RxRelay

class PersonDetailsViewModel {
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let repository: ShowsRepository
    
    // MARK: - Actions
    private let onShowErrorRelay = PublishRelay<String>()
    private let onGoToShowDetailsRelay = PublishRelay<ShowDetailsViewModel>()
    private let onGoBackRelay = PublishRelay<Void>()
    
    // MARK: - State
    private let personRelay: BehaviorRelay<Person>
    private let showsRelay = BehaviorRelay<[ListedShow]>(value: [])
    private let loadingRelay = BehaviorRelay(value: false)
    
    // MARK: - Public Observables
    lazy var onShowError = onShowErrorRelay.asObservable()
    lazy var onGoToShowDetails = onGoToShowDetailsRelay.asObservable()
    lazy var onGoBack = onGoBackRelay.asObservable()
    lazy var isLoading = loadingRelay.asObservable().distinctUntilChanged()
    
    lazy var person = personRelay.asObservable()
    lazy var shows = showsRelay.asObservable()
    
    // MARK: - Initializers
    init(person: Person, repository: ShowsRepository) {
        self.personRelay = BehaviorRelay(value: person)
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
    
    func didSelectShow(atIndex index: Int) {
        guard index < showsRelay.value.count else { return }
        let show = showsRelay.value[index]
        let showViewModel = ShowDetailsViewModel(showId: show.id, repository: repository)
        onGoToShowDetailsRelay.accept(showViewModel)
    }
    
    // MARK: - Methods
    private func loadData() {
        loadingRelay.accept(true)
        
        repository.getPersonCastCredits(personId: personRelay.value.id) { [weak self] (result) in
            guard let self = self else { return }
            
            self.loadingRelay.accept(false)
            
            switch result {
            case .success(let response):
                self.showsRelay.accept(response.map({ $0.embedded.show }))
            case .failure:
                self.onShowErrorRelay.accept("An error has occurred while fetching the cast credits.")
            }
        }
    }
}

