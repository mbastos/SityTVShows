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
    private let viewModel = ShowsViewModel(repository: TVMazeRepository())
    
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
    
    override func viewDidLoad() {
        title = "Shows"
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        
        setupSubviews()
        
        bindTableView()
        setupObservables()
        
        viewModel.didLoad()
    }
    
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
    
    private func setupObservables() {
        viewModel.isLoading.subscribe(onNext: { [weak self] (isLoading) in
            if isLoading {
                self?.addLoadingFooter()
            } else {
                self?.removeLoadingFooter()
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
        
        viewModel.onShowDetails.subscribe(onNext: { [weak self] (id) in
            self?.show(ShowDetailsViewController(), sender: self)
        }).disposed(by: disposeBag)
    }
    
    private func addLoadingFooter() {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(
            x: 0, y: 0, width: tableView.bounds.width, height: 80))
        activityIndicator.startAnimating()
        
        tableView.tableFooterView = activityIndicator
    }
    
    private func removeLoadingFooter() {
        tableView.tableFooterView = nil
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
