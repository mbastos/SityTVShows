//
//  PersonDetailsViewController.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate enum TableSection: Int {
    case personInfo
    case shows
}

class PersonDetailsViewController: BaseViewController {
    // MARK: - Properties
    private let viewModel: PersonDetailsViewModel
    private let disposeBag = DisposeBag()
    
    private var person: Person?
    private var shows: [ListedShow]?
    private var cardView: CardView?
    
    // MARK: - Initializers
    init(viewModel: PersonDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Person"
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = .systemBackground
        
        setupSubviews()
        
        bindViewModel()
        viewModel.didLoad()
    }
    
    // MARK: - Views
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerHeaderView(TitleHeaderView.self)
        tableView.registerCell(GenericTableViewCell<CardView>.self)
        return tableView
    }()
    
    // MARK: - Methods
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.fillSafeArea()
    }
    
    private func bindViewModel() {
        viewModel.isLoading.subscribe(onNext: { [weak self] (isLoading) in
            if isLoading {
                self?.startLoading()
            } else {
                self?.stopLoading()
            }
        }).disposed(by: disposeBag)
        
        viewModel.onShowError.subscribe(onNext: { [weak self] (errorMessage) in
            guard let self = self else { return }
            self.showErrorAlert(
                message: errorMessage,
                onTryAgain: {
                    self.viewModel.didPressTryAgain()
                },
                onCancel: {
                    self.viewModel.didPressCancel()
                })
        }).disposed(by: disposeBag)
                
        viewModel.onGoToShowDetails.subscribe(onNext: { [weak self] viewModel in
            let vc = ShowDetailsViewController(viewModel: viewModel)
            self?.show(vc, sender: self)
        }).disposed(by: disposeBag)
        
        viewModel.onGoBack.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.person.subscribe(onNext: { [weak self] person in
            guard let self = self else { return }
            self.person = person
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
        viewModel.shows.subscribe(onNext: { [weak self] (shows) in
            guard let self = self else { return }
            self.shows = shows
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension PersonDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = TableSection(rawValue: section)
        switch tableSection {
        case .personInfo:
            return person != nil ? 1 : 0
        case .shows:
            return shows?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if TableSection(rawValue: section) == .shows {
            return UITableView.automaticDimension
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if TableSection(rawValue: section) == .shows {
            let view: TitleHeaderView = tableView.dequeueReusableHeaderView()
            view.title = "Appeared in"
            return view
        }
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = TableSection(rawValue: indexPath.section)
        
        switch tableSection {
        case .personInfo:
            guard let person = person else { break }
            
            let cell: GenericTableViewCell<CardView> = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            if let cellView = cell.cellView {
                cellView.type = .person(person)
                cellView.card.isHidden = true
            } else {
                cell.cellView = CardView(type: .person(person))
                cell.cellView?.card.isHidden = true
            }
            
            return cell
            
        case .shows:
            guard let show = shows?[indexPath.row] else { break }
            
            let cell: GenericTableViewCell<CardView> = tableView.dequeueReusableCell(forIndexPath: indexPath)
            
            if let cellView = cell.cellView {
                cellView.type = .show(show)
                cellView.card.isHidden = false
            } else {
                cell.cellView = CardView(type: .show(show))
                cell.cellView?.card.isHidden = false
            }
            
            return cell
            
        default: break
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableSection = TableSection(rawValue: indexPath.section)
        
        if tableSection == .shows {
            viewModel.didSelectShow(atIndex: indexPath.row)
        }
    }
}
