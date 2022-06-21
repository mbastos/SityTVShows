//
//  ShowDetailsViewController.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import UIKit
import RxSwift

fileprivate enum TableSection {
    case info
    case season(Int)
    
    init(forSectionIndex sectionIndex: Int) {
        switch sectionIndex {
        case 0: self = .info
        default: self = .season(sectionIndex - 1)
        }
    }
}

fileprivate enum HeaderRow: Int, CaseIterable {
    case header
    case genres
    case summary
    case info
    case episodesHeader
}

class ShowDetailsViewController: BaseViewController {
    // MARK: - Properties
    private let viewModel: ShowDetailsViewModel
    private let disposeBag = DisposeBag()
    
    private var information: ShowMainInformation?
    private var seasons: [ShowSeason]?
    
    // MARK: - Initializers
    init(viewModel: ShowDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Details"
        navigationItem.largeTitleDisplayMode = .never
        
        view.backgroundColor = .systemBackground
        
        setupSubviews()
        
        bindViewModel()
        viewModel.didLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // The user could have added/removed favorites in another screen, so we force a reload
        // to make sure the correct information is being presented
        tableView.reloadData()
    }
    
    // MARK: - Views
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerHeaderView(SeasonHeaderView.self)
        tableView.registerCell(GenericTableViewCell<ShowHeaderView>.self)
        tableView.registerCell(GenericTableViewCell<ShowGenresView>.self)
        tableView.registerCell(GenericTableViewCell<SummaryView>.self)
        tableView.registerCell(GenericTableViewCell<ShowInfoView>.self)
        tableView.registerCell(TitleCell.self)
        tableView.registerCell(GenericTableViewCell<EpisodeView>.self)
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
        
        viewModel.onShowEpisode.subscribe(onNext: { [weak self] episode in
            let vc = EpisodeDetailsViewController(episode: episode)
            self?.show(vc, sender: self)
        }).disposed(by: disposeBag)
        
        viewModel.onGoBack.subscribe(onNext: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.infoAndEpisodes.subscribe(onNext: { [weak self] (information, seasons) in
            guard let self = self, let information = information, let seasons = seasons else { return }
            self.information = information
            self.seasons = seasons
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
}

extension ShowDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        let infoSections = information != nil ? 1 : 0
        
        return infoSections + (seasons?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = TableSection(forSectionIndex: section)
        switch tableSection {
        case .info:
            return HeaderRow.allCases.count
        case .season(let seasonIndex):
            return seasons?[seasonIndex].episodes.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let tableSection = TableSection(forSectionIndex: section)
        switch tableSection {
        case .info:
            return 0
        case .season:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tableSection = TableSection(forSectionIndex: section)
        switch tableSection {
        case .info:
            return UIView()
        case .season(let seasonIndex):
            let view: SeasonHeaderView = tableView.dequeueReusableHeaderView()
            view.title = seasons?[seasonIndex].description
            return view
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableSection = TableSection(forSectionIndex: indexPath.section)
        
        if case .info = tableSection, let info = information {
            
            let headerRow = HeaderRow(rawValue: indexPath.row)
            
            switch headerRow {
            case .header:
                let cell: GenericTableViewCell<ShowHeaderView> = tableView.dequeueReusableCell(forIndexPath: indexPath)
                            
                if let cellView = cell.cellView {
                    cellView.model = info
                } else {
                    cell.cellView = ShowHeaderView(model: info)
                }
                
                return cell
            case .genres:
                let cell: GenericTableViewCell<ShowGenresView> = tableView.dequeueReusableCell(forIndexPath: indexPath)

                let genres = info.genres ?? []
                
                if let cellView = cell.cellView {
                    cellView.genres = genres
                } else {
                    cell.cellView = ShowGenresView(genres: genres)
                }

                return cell
                
            case .summary:
                let cell: GenericTableViewCell<SummaryView> = tableView.dequeueReusableCell(forIndexPath: indexPath)
                
                let summary = info.summary ?? ""
                
                if let cellView = cell.cellView {
                    cellView.summary = summary
                } else {
                    cell.cellView = SummaryView(summary: summary)
                }
                
                return cell
            
            case .info:
                let cell: GenericTableViewCell<ShowInfoView> = tableView.dequeueReusableCell(forIndexPath: indexPath)
                
                if let cellView = cell.cellView {
                    cellView.model = info
                } else {
                    cell.cellView = ShowInfoView(model: info)
                }
                
                return cell
                
            case .episodesHeader:
                
                let cell: TitleCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
                cell.title = "Episodes"
                return cell
                
            case .none:
                break
            }
            
        } else if case .season(let seasonIndex) = tableSection {
            
            let cell: GenericTableViewCell<EpisodeView> = tableView.dequeueReusableCell(forIndexPath: indexPath)
            let episode = seasons?[seasonIndex].episodes[indexPath.row]
            if let cellView = cell.cellView {
                cellView.episode = episode
            } else {
                cell.cellView = EpisodeView()
                cell.cellView?.episode = episode
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableSection = TableSection(forSectionIndex: indexPath.section)
        
        if case .season(let seasonIndex) = tableSection {
            viewModel.didSelectEpisode(atIndex: indexPath.row, ofSeasonIndex: seasonIndex)
        }
    }
}
