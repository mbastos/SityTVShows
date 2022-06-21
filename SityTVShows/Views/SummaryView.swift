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
        static let margin: CGFloat = 16
        static let spacing: CGFloat = 12
        static let summaryFont = UIFont.systemFont(ofSize: 12)
    }
    
    // MARK: - Properties
    var summary: String = "" {
        didSet {
            setupData()
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupData()
    }
    
    convenience init(summary: String) {
        self.init(frame: .zero)
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
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.margin),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.margin),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.margin),
            
            summaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            summaryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func setupData() {
        let data = Data(summary.utf8)
        let attributedString = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil)
        
        attributedString?.replaceFonts(with: Constants.summaryFont)
        attributedString?.addAttribute(
            .foregroundColor,
            value: UIColor.secondaryLabel,
            range: NSRange(location: 0, length: attributedString?.length ?? 0))
        
        summaryLabel.attributedText = attributedString?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
