//
//  ShowInfoView.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import UIKit

class ShowInfoView: UIView {
    
    // MARK: - Constants
    private enum Constants {
        static let margin: CGFloat = 16
        static let spacing: CGFloat = 12
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
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureSecondaryTitle()
        label.text = "Info"
        return label
    }()
    
    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var status = createItem(title: "Status")
    private lazy var schedule = createItem(title: "Schedule")
    private lazy var type = createItem(title: "Type")
    private lazy var language = createItem(title: "Language")
    
    // MARK: - Methods
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(infoStackView)
        
        [status, schedule, type, language].forEach({ infoStackView.addArrangedSubview($0.stackView) })
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.margin),
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.margin),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.margin),
            
            infoStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infoStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            infoStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func createLabel(weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: weight)
        label.textColor = .secondaryLabel
        return label
    }
    
    private func createItem(title: String) -> (stackView: UIStackView, label: UILabel) {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .top
        stackView.spacing = 5
        
        let titleLabel = createLabel(weight: .bold)
        titleLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .horizontal)
        titleLabel.text = "\(title):"
        stackView.addArrangedSubview(titleLabel)
        
        let valueLabel = createLabel(weight: .regular)
        valueLabel.numberOfLines = 0
        stackView.addArrangedSubview(valueLabel)
        
        return (stackView: stackView, label: valueLabel)
    }
    
    private func setupData() {
        status.label.text = model.status
        
        if let formattedSchedule = model.schedule?.formatted {
            schedule.stackView.isHidden = false
            schedule.label.text = formattedSchedule
        } else {
            schedule.stackView.isHidden = true
        }
        
        if let typeText = model.type {
            type.stackView.isHidden = false
            type.label.text = typeText
        } else {
            type.stackView.isHidden = true
        }
        
        if let languageText = model.language {
            language.stackView.isHidden = false
            language.label.text = languageText
        } else {
            language.stackView.isHidden = true
        }
    }
}
