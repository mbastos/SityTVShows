//
//  ShowsViewController.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit
import RxSwift
import RxCocoa

class ShowsViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let cellType = GenericTableViewCell<CardView>.self
        static let estimatedRowHeight: CGFloat = 120
        static let contentVerticalInsets: CGFloat = 16
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel: ShowsViewModel
    
    // MARK: - Initializers
    init(viewModel: ShowsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.contentInset = UIEdgeInsets(
            top: Constants.contentVerticalInsets,
            left: 0,
            bottom: Constants.contentVerticalInsets,
            right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight
        tableView.separatorStyle = .none
        tableView.registerCell(Constants.cellType)
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shows"
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        
        setupSubviews()
        
        bindTableView()
        bindViewModel()
        
        viewModel.didLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // The user could have added/removed favorites in another screen, so we force a reload
        // to make sure the correct information is being presented
        tableView.reloadData()
    }
    
    // MARK: - Methods
    private func setupSubviews() {
        view.addSubview(tableView)
        tableView.fillSafeArea()
    }
    
    private func bindTableView() {
        let id = String(describing: Constants.cellType)
        
        viewModel.shows
            .bind(to: tableView.rx.items(cellIdentifier: id, cellType: Constants.cellType)) { (row, element, cell) in
                if let cellView = cell.cellView {
                    cellView.type = .show(element)
                } else {
                    cell.cellView = CardView(type: .show(element))
                }
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                self?.viewModel.didSelectItem(atIndex: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindViewModel() {
        viewModel.isLoading.subscribe(onNext: { [weak self] (isLoading) in
            if isLoading {
                self?.tableView.addLoadingFooter()
            } else {
                self?.tableView.removeLoadingFooter()
            }
        }).disposed(by: disposeBag)
        
        viewModel.onShowError.subscribe(onNext: { [weak self] (errorMessage) in
            guard let self = self else { return }
            self.showErrorAlert(
                message: errorMessage,
                onTryAgain: {
                    self.viewModel.didPressTryAgain()
                })
        }).disposed(by: disposeBag)
        
        viewModel.onShowDetails.subscribe(onNext: { [weak self] (detailsViewModel) in
            self?.show(ShowDetailsViewController(viewModel: detailsViewModel), sender: self)
        }).disposed(by: disposeBag)
    }
}

extension ShowsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let numberOfRows = tableView.dataSource?.tableView(tableView, numberOfRowsInSection: indexPath.section) ?? 0
        // If this cell is the last one, it means the end has been reached
        if indexPath.row == numberOfRows - 1 {
            viewModel.didReachEnd()
        }
    }
}
