//
//  ShowGenresView.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import UIKit

class ShowGenresView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let spacing: CGFloat = 12
        static let collectionViewHeight: CGFloat = 18
    }
    
    // MARK: - Properties
    var genres: [String] = [] {
        didSet {
            setupData()
        }
    }
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        
        setupSubviews()
    }
    
    convenience init(genres: [String]) {
        self.init()
        self.genres = genres
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureSecondaryTitle()
        label.text = "Genres"
        return label
    }()
    
    lazy var collectionView: GenresCollectionView = {
        let collectionView = GenresCollectionView()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: .defaultMargin, bottom: 0, right: .defaultMargin)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Methods
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .defaultMargin),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: .defaultMargin),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -.defaultMargin),
                        
            collectionView.heightAnchor.constraint(equalToConstant: Constants.collectionViewHeight),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupData() {
        collectionView.genres = genres
    }
}
