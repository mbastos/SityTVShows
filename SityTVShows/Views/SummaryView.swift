//
//  SummaryView.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import UIKit

class SummaryView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let spacing: CGFloat = 12
        static let summaryFont = UIFont.systemFont(ofSize: 12)
        static let summaryBoldFont = UIFont.boldSystemFont(ofSize: 12)
    }
    
    // MARK: - Properties
    var summary: String = "" {
        didSet {
            if summary != oldValue {
                setupData()
            }
        }
    }
    
    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        
        setupSubviews()
    }
    
    convenience init(summary: String) {
        self.init()
        self.summary = summary
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
        label.text = "Summary"
        return label
    }()
    
    lazy var summaryLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = Constants.summaryFont
        label.textColor = .secondaryLabel
        return label
    }()
    
    // MARK: - Methods
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(summaryLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: .defaultMargin),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: .defaultMargin),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -.defaultMargin),
            
            summaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            summaryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupData() {
        let attributedString = NSMutableAttributedString.init(string: summary)
        
        // Letting NSMutableAttributedString parse the whole HTML leads to various problems.
        // It was causing internal inconsistencies in the table view (in ShowDetailsViewController).
        attributedString.parseBoldHTML(boldFont: Constants.summaryBoldFont)
        summaryLabel.attributedText = attributedString
    }
}
