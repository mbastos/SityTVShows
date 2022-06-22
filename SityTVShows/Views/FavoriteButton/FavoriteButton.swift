//
//  FavoriteButton.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import UIKit

class FavoriteButton: UIImageView {
    // MARK: - Constants
    private enum Constants {
        static let heartImageFilled = UIImage(systemName: "heart.fill")
        static let heartImage = UIImage(systemName: "heart")
    }
    
    // MARK: - Properties
    var show: FavoriteShow? {
        didSet {
            setupData()
        }
    }
    var isFavorite: Bool?
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        
        contentMode = .center
        isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        addGestureRecognizer(gestureRecognizer)
        
        setupData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupData() {
        isFavorite = nil

        if let show = show {
            isFavorite = Persistence.shared.favoriteShows[show.id] != nil
        }
        
        setIsFavorite(isFavorite)
    }
    
    private func setIsFavorite(_ isFavorite: Bool?) {
        if let isFavorite = isFavorite {
            isHidden = false
            if isFavorite {
                image = Constants.heartImageFilled
                tintColor = .systemRed
            } else {
                image = Constants.heartImage
                tintColor = .systemGray
            }
        } else {
            isHidden = true
        }
    }
    
    @objc func didTap(_ sender: UITapGestureRecognizer) {
        guard let isFavorite = isFavorite, let show = show else {
            return
        }

        if isFavorite {
            Persistence.shared.removeFavorite(withId: show.id)
        } else {
            Persistence.shared.addFavorite(withId: show.id, andName: show.name)
        }
        
        setupData()
    }
}
