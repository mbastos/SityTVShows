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
    case person(Person)
}

extension CardViewType {
    init(fromSearchResult item: SearchResultItem) {
        switch item {
        case .show(let show):
            self = .show(show)
        case .person(let person):
            self = .person(person)
        }
    }
}

class CardView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let cardInset: CGFloat = 12
        static let imageWidthProportion: CGFloat = 0.25 // proportion of image width in relation to the card
        static let imageAspectRatio: CGFloat = 145/104 // height over width
        static let minimumImageWidth: CGFloat = 40
        static let ratingStarsWidth: CGFloat = 80
        static let ratingSpacing: CGFloat = 8 // spacing between stars and rating label
        static let favoriteButtonSize: CGFloat = 32
    }
    
    // MARK: - Properties
    var type: CardViewType {
        didSet {
            setupData()
        }
    }
    
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
        label.configureSecondaryTitle()
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
        label.configureSecondaryText()
        return label
    }()
    
    lazy var favoriteButton: FavoriteButton = {
        let button = FavoriteButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var personInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    
    lazy var countryLabel = createLabel()
    
    lazy var birthdayLabel = createLabel()
    
    lazy var genderLabel = createLabel()
    
    // MARK: - Setup
    private func setupSubviews() {
        addSubview(card)
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(ratingStarsView)
        addSubview(ratingLabel)
        addSubview(favoriteButton)
        addSubview(personInfoStackView)
        
        [countryLabel, birthdayLabel, genderLabel].forEach({ personInfoStackView.addArrangedSubview($0) })
        
        let imageWidthConstraint = imageView.widthAnchor.constraint(
            equalTo: self.widthAnchor,
            multiplier: Constants.imageWidthProportion)
        // Due to the aspect ratio constraint, it may not be possible to satisfy this constraint
        imageWidthConstraint.priority = UILayoutPriority.required - 1
        
        NSLayoutConstraint.activate([
            card.topAnchor.constraint(equalTo: self.topAnchor),
            card.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .defaultMargin),
            card.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -.defaultMargin),
            card.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -.defaultMargin),
            
            imageView.topAnchor.constraint(equalTo: card.topAnchor, constant: Constants.cardInset),
            imageView.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: Constants.cardInset),
            imageView.widthAnchor.constraint(greaterThanOrEqualToConstant: Constants.minimumImageWidth),
            imageWidthConstraint,
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: Constants.imageAspectRatio),
            imageView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -Constants.cardInset),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.cardInset),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -Constants.cardInset),
            
            personInfoStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            personInfoStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.cardInset),
            personInfoStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            ratingStarsView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: Constants.cardInset),
            ratingStarsView.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -Constants.cardInset),
            ratingStarsView.widthAnchor.constraint(equalToConstant: Constants.ratingStarsWidth),
            
            ratingLabel.leadingAnchor.constraint(equalTo: ratingStarsView.trailingAnchor, constant: Constants.ratingSpacing),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingStarsView.centerYAnchor),
            
            favoriteButton.leadingAnchor.constraint(greaterThanOrEqualTo: ratingLabel.trailingAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -Constants.cardInset),
            favoriteButton.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -Constants.cardInset),
            favoriteButton.widthAnchor.constraint(equalToConstant: Constants.favoriteButtonSize),
            favoriteButton.heightAnchor.constraint(equalToConstant: Constants.favoriteButtonSize)
        ])
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureSecondaryText()
        return label
    }
    
    private func setupData() {
        switch type {
        case .show(let listedShow):
            titleLabel.text = listedShow.name
            imageView.setRemoteImage(atURL: listedShow.image?.medium, withContentMode: .scaleAspectFill)
            setRating(listedShow.rating)
            
            favoriteButton.isHidden = false
            favoriteButton.show = FavoriteShow(id: listedShow.id, name: listedShow.name)
            
            personInfoStackView.isHidden = true
            
        case .person(let person):
            titleLabel.text = person.name
            imageView.setRemoteImage(atURL: person.image?.medium, withContentMode: .scaleAspectFill)
            setRating(nil)
            favoriteButton.isHidden = true
            
            personInfoStackView.isHidden = false
            setPersonInfo(person)
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
    
    private func setPersonInfo(_ person: Person) {
        if let country = person.country?.name {
            countryLabel.isHidden = false
            countryLabel.text = "Country: \(country)"
        } else {
            countryLabel.isHidden = true
        }
        
        if let birthday = person.birthday {
            birthdayLabel.isHidden = false
            let formattedDate = DateFormatter.longDate.string(from: birthday)
            birthdayLabel.text = "Birthday: \(formattedDate)"
        } else {
            birthdayLabel.isHidden = true
        }
        
        if let gender = person.gender {
            genderLabel.isHidden = false
            genderLabel.text = "Gender: \(gender)"
        } else {
            genderLabel.isHidden = true
        }
    }
}
