//
//  TitleHeaderView.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import UIKit

class TitleHeaderView: UITableViewHeaderFooterView {
    
    private enum Constants {
        static let horizontalMargin: CGFloat = 16
        static let verticalMargin: CGFloat = 8
    }
    
    var title: String? {
        didSet {
            label.text = title
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureTertiaryTitle()
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureSubviews() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.horizontalMargin),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.verticalMargin),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.verticalMargin)
        ])
    }
}
