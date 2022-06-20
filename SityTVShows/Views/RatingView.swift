//
//  RatingView.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit

class RatingView: UIStackView {
    
    // MARK: - Properties
    var rating: Double = 5 {
        didSet {
            fillStars()
        }
    }
    
    // MARK: - Views
    lazy var stars: [StarImageView] = (0..<5).map({ _ in
        let star = StarImageView(fillRatio: 1)
        star.translatesAutoresizingMaskIntoConstraints = false
        star.heightAnchor.constraint(equalTo: star.widthAnchor, multiplier: 1.0).isActive = true
        return star
    })
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        
        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = 2
        
        stars.forEach(self.addArrangedSubview)
        fillStars()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func createStar() -> StarImageView {
        let star = StarImageView(fillRatio: 1)
        star.translatesAutoresizingMaskIntoConstraints = false
        star.heightAnchor.constraint(equalTo: star.widthAnchor, multiplier: 1.0).isActive = true
        return star
    }
    
    private func fillStars() {
        stars.enumerated().forEach({ (index, star) in
            let ratio = (rating - Double(index)).clamped(to: 0...1)
            star.fillRatio = ratio
        })
    }
}
