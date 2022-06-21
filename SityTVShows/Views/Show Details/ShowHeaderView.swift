//
//  ShowHeaderView.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import UIKit
import Kingfisher

class ShowHeaderView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let horizontalMargin: CGFloat = 16
        static let imageWidthProportion: CGFloat = 0.25 // proportion of image width in relation to the card
        static let imageAspectRatio: CGFloat = 145/104 // height over width
        static let minimumImageWidth: CGFloat = 40
        static let ratingStarsWidth: CGFloat = 80
        static let spacingToImage: CGFloat = 12
        static let itemSpacing: CGFloat = 16 // spacing between title, rating stars and rating label
    }
    
    // MARK: - Properties
    var model: ShowMainInformation {
        didSet {
            setupData()
        }
    }
    
    // MARK: - Initializers
    init(model: ShowMainInformation) {
        self.model = model
        
        super.init(frame: .zero)
        
        setupSubviews()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        return label
    }()
    
    lazy var ratingStarsView: RatingView = {
        let view = RatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        return label
    }()
    
    lazy var favoriteButton: FavoriteButton = {
        let button = FavoriteButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Methods
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(ratingStarsView)
        addSubview(ratingLabel)
        addSubview(favoriteButton)
        
        let imageWidthConstraint = imageView.widthAnchor.constraint(
            equalTo: self.widthAnchor,
            multiplier: Constants.imageWidthProportion)
        // Due to the aspect ratio constraint, it may not be possible to satisfy this constraint
        imageWidthConstraint.priority = UILayoutPriority.required - 1
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.horizontalMargin),
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.minimumImageWidth),
            imageWidthConstraint,
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Constants.imageAspectRatio),
            
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.spacingToImage),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            ratingStarsView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingStarsView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.itemSpacing),
            ratingStarsView.widthAnchor.constraint(equalToConstant: Constants.ratingStarsWidth),
            
            ratingLabel.leadingAnchor.constraint(equalTo: ratingStarsView.leadingAnchor),
            ratingLabel.topAnchor.constraint(equalTo: ratingStarsView.bottomAnchor, constant: Constants.itemSpacing),
            
            favoriteButton.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: Constants.itemSpacing),
            favoriteButton.bottomAnchor.constraint(equalTo: titleLabel.firstBaselineAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.horizontalMargin)
        ])
    }
    
    private func setupData() {
        titleLabel.text = model.name
        
        imageView.setRemoteImage(atURL: model.image?.medium, withContentMode: .scaleAspectFill)
        setRating(model.rating)
        favoriteButton.show = FavoriteShow(id: model.id, name: model.name)
    }
    
    private func setRating(_ rating: Rating?) {
        if let averageRating = rating?.averageOnScaleOfFive {
            ratingStarsView.isHidden = false
            ratingLabel.isHidden = false
            ratingStarsView.rating = averageRating
            ratingLabel.text = rating?.fullFormattedAverage
        } else {
            ratingStarsView.isHidden = true
            ratingLabel.isHidden = true
        }
    }
}
