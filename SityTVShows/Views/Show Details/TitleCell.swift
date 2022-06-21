//
//  TitleCell.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import UIKit

class TitleCell: UITableViewCell {
    // MARK: - Constants
    private enum Constants {
        static let margin: CGFloat = 16
    }
    
    // MARK: - Properties
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - Subviews
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureSecondaryTitle()
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func setupSubviews() {
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.margin),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.margin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.margin),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
