//
//  CardView.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit
import Kingfisher

enum CardViewType {
    case show(ListedShow)
}

class CardView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let margin: CGFloat = 16
        static let cardInset: CGFloat = 12
        static let imageWidthProportion: CGFloat = 0.25 // proportion of image width in relation to the card
        static let imageAspectRatio: CGFloat = 145/104 // height over width
        static let minimumImageWidth: CGFloat = 40
        static let ratingStarsWidth: CGFloat = 80
        static let ratingSpacing: CGFloat = 8 // spacing between stars and rating label
    }
    
    // MARK: - Properties
    var type: CardViewType {
        didSet {
            setupData()
        }
    }
    
    lazy var placeholderImage = UIImage(named: "ic_no_image")?.withRenderingMode(.alwaysTemplate)
    lazy var heartImageFilled = UIImage(systemName: "heart.fill")
    lazy var heartImage = UIImage(systemName: "heart")
    
    // MARK: - Initializers
    init(type: CardViewType) {
        self.type = type
        super.init(frame: .zero)
        
        setupSubviews()
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    lazy var card: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 5.0
        view.layer.shadowOpacity = 1
        view.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowRadius = 6.0
        // improve performance
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale
        return view
    }()
    
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
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
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
        label.textColor = UIColor(red: 85/255, green: 85/255, blue: 85/255, alpha: 1)
        return label
    }()
    
    lazy var heartView: UIImageView = {
        let view = UIImageView(image: heartImageFilled)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .systemRed
        return view
    }()
    
    // MARK: - Setup
    private func setupSubviews() {
        addSubview(card)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(ratingStarsView)
        addSubview(ratingLabel)
        addSubview(heartView)
        
        let imageWidthConstraint = imageView.widthAnchor.constraint(
            equalTo: self.widthAnchor,
            multiplier: Constants.imageWidthProportion)
        // Due to the aspect ratio constraint, it may not be possible to satisfy this constraint
        imageWidthConstraint.priority = UILayoutPriority.required - 1
        
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: self.topAnchor),
            card.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.margin),
            card.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.margin),
            card.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.margin),
            
            imageView.topAnchor.constraint(equalTo: card.topAnchor, constant: Constants.cardInset),
            imageView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: Constants.cardInset),
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.minimumImageWidth),
            imageWidthConstraint,
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Constants.imageAspectRatio),
            imageView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -Constants.cardInset),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.cardInset),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -Constants.cardInset),
            
            ratingStarsView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.cardInset),
            ratingStarsView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -Constants.cardInset),
            ratingStarsView.widthAnchor.constraint(equalToConstant: Constants.ratingStarsWidth),
            
            ratingLabel.leadingAnchor.constraint(equalTo: ratingStarsView.trailingAnchor, constant: Constants.ratingSpacing),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingStarsView.centerYAnchor),
            
            heartView.leadingAnchor.constraint(greaterThanOrEqualTo: ratingLabel.trailingAnchor),
            heartView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -Constants.cardInset),
            heartView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -Constants.cardInset)
        ])
    }
    
    private func setupData() {
        switch type {
        case .show(let listedShow):
            titleLabel.text = listedShow.name
            setImage(url: listedShow.image?.medium)
            setRating(listedShow.rating)
            
            // TODO: actually find out if this series is saved as a favorite
            setIsFavorite(Bool.random())
        }
    }
    
    private func setImage(url: URL?) {
        if let imageURL = url {
            imageView.image = nil
            imageView.contentMode = .scaleAspectFill
            imageView.kf.setImage(with: imageURL)
        } else {
            imageView.contentMode = .center
            // There could be a Kingfisher load in progress, so we cancel it this way
            let resource: Resource? = nil
            imageView.kf.setImage(with: resource)
            imageView.image = placeholderImage
            imageView.tintColor = .systemGray
        }
    }
    
    private func setRating(_ rating: Rating?) {
        if let averageRating = rating?.averageOnScaleOfFive {
            ratingStarsView.isHidden = false
            ratingLabel.isHidden = false
            ratingStarsView.rating = averageRating
            ratingLabel.text = rating?.formattedAverage
        } else {
            ratingStarsView.isHidden = true
            ratingLabel.isHidden = true
        }
    }
    
    private func setIsFavorite(_ isFavorite: Bool?) {
        if let isFavorite = isFavorite {
            heartView.isHidden = false
            if isFavorite {
                heartView.image = heartImageFilled
                heartView.tintColor = .systemRed
            } else {
                heartView.image = heartImage
                heartView.tintColor = .systemGray
            }
        } else {
            heartView.isHidden = true
        }
    }
}
