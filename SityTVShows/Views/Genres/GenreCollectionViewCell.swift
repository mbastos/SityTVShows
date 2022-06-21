//
//  GenreCollectionViewCell.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    private enum Constants {
        static let accentColor = UIColor(red: 255/255, green: 109/255, blue: 109/255, alpha: 1)
        static let inset: CGFloat = 3
    }
    
    // MARK: - Properties
    var text: String = "" {
        didSet {
            label.text = text.uppercased()
        }
    }
    
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    lazy var badge: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 3
        view.layer.borderWidth = 1
        view.layer.borderColor = Constants.accentColor.cgColor
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = Constants.accentColor
        return label
    }()
    
    // MARK: - Methods
    private func setupSubviews() {
        contentView.addSubview(badge)
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            badge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            badge.topAnchor.constraint(equalTo: contentView.topAnchor),
            badge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            badge.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            label.leadingAnchor.constraint(equalTo: badge.leadingAnchor, constant: Constants.inset),
            label.topAnchor.constraint(equalTo: badge.topAnchor, constant: Constants.inset),
            label.trailingAnchor.constraint(equalTo: badge.trailingAnchor, constant: -Constants.inset),
            label.bottomAnchor.constraint(equalTo: badge.bottomAnchor, constant: -Constants.inset)
        ])
    }
}
