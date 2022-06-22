//
//  SearchViewController.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit
import RxSwift
import RxCocoa

class SearchViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let cellType = GenericTableViewCell<CardView>.self
        static let estimatedRowHeight: CGFloat = 120
        static let contentVerticalInsets: CGFloat = 16
    }
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel: SearchViewModel
    
    // MARK: - Initializers
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Type keywords here..."
        controller.searchBar.showsCancelButton = false
        return controller
    }()
    
    lazy var typeLabel: UILabel = {
        let label = UILabel()
        label.text = "Shows"
        return label
    }()
    
    lazy var typeView: UIView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 6

        let arrowView = UIImageView(image: UIImage(systemName: "chevron.down"))
        arrowView.tintColor = .label
        arrowView.translatesAutoresizingMaskIntoConstraints = false

        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.backgroundColor = .systemGray3
        divider.widthAnchor.constraint(equalToConstant: 1).isActive = true
        
        let extraSpace = UIView()
        extraSpace.translatesAutoresizingMaskIntoConstraints = false
        extraSpace.widthAnchor.constraint(equalToConstant: 3).isActive = true

        view.addArrangedSubview(typeLabel)
        view.addArrangedSubview(arrowView)
        view.addArrangedSubview(divider)
        view.addArrangedSubview(extraSpace)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapTypeView))
        view.addGestureRecognizer(gestureRecognizer)

        return view
    }()
    
    @objc func didTapTypeView() {
        let alert = UIAlertController(
            title: "Search type",
            message: "What are you searching for?",
            preferredStyle: .actionSheet)
        
        let actions = SearchType.allCases.map({ type in
            return UIAlertAction(title: type.description, style: .default) { [weak self] _ in
                self?.viewModel.searchType.accept(type)
            }
        })
        
        actions.forEach({ alert.addAction($0) })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        
    }
    
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
        tableView.backgroundView = emptyView
        return tableView
    }()
    
    lazy var emptyView: UIView = {
        let label = UILabel()
        label.isHidden = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "No results were found."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Search"
        view.backgroundColor = .systemBackground
        
        navigationItem.searchController = searchController
        
        setupSubviews()
        
        bindTableView()
        setupObservables()
    }
    
    private func setupSubviews() {
        view.addSubview(tableView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
        
        searchController.searchBar.searchTextField.leftViewMode = .always
        searchController.searchBar.searchTextField.leftView = typeView
    }
    
    private func bindTableView() {
        let id = String(describing: Constants.cellType)
        
        viewModel.items.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: id, cellType: Constants.cellType)) { (row, element, cell) in
                let cardViewType = CardViewType(fromSearchResult: element)
                
                if let cellView = cell.cellView {
                    cellView.type = cardViewType
                } else {
                    cell.cellView = CardView(type: cardViewType)
                }
            }.disposed(by: disposeBag)
        
        viewModel.shouldDisplayEmptyView
            .map(!)
            .drive(emptyView.rx.isHidden)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] (indexPath) in
                self?.viewModel.didSelectItem(atIndex: indexPath.row)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupObservables() {
        searchController
            .searchBar
            .rx.text.orEmpty
            .bind(to: viewModel.queryText)
            .disposed(by: disposeBag)
        
        viewModel.searchType
            .map(\.description)
            .bind(to: typeLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isLoading.drive(onNext: { [weak self] (isLoading) in
            if isLoading {
                self?.startLoading()
            } else {
                self?.stopLoading()
            }
        }).disposed(by: disposeBag)
        
        viewModel.onShowError.emit(onNext: { [weak self] (errorMessage) in
            guard let self = self else { return }
            self.showErrorAlert(
                message: errorMessage,
                onTryAgain: {
                    self.viewModel.didPressTryAgain()
                })
        }).disposed(by: disposeBag)
        
        viewModel.onGoToShowDetails.subscribe(onNext: { [weak self] (viewModel) in
            self?.show(ShowDetailsViewController(viewModel: viewModel), sender: self)
        }).disposed(by: disposeBag)
        
        viewModel.onGoToPersonDetails.subscribe(onNext: { [weak self] (viewModel) in
            self?.show(PersonDetailsViewController(viewModel: viewModel), sender: self)
        }).disposed(by: disposeBag)
    }
}
