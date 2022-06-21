//
//  EpisodeTableViewCell.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import UIKit

enum EpisodeViewStyle {
    case small
    case big
    
    var imageWidthProportion: CGFloat {
        switch self {
        case .small:
            return 0.3
        case .big:
            return 0.35
        }
    }
    
    var shouldDisplaySeason: Bool {
        switch self {
        case .small:
            return false
        case .big:
            return true
        }
    }
}

class EpisodeView: UIView {
    // MARK: - Constants
    private enum Constants {
        static let margin: CGFloat = 16
        static let imageAspectRatio: CGFloat = 140/250 // height over width
        static let spacing: CGFloat = 8 // spacing between title and info
    }
    
    // MARK: - Properties
    private let style: EpisodeViewStyle
    var episode: ShowEpisode? {
        didSet {
            setupData()
        }
    }
    
    // MARK: - Initializers
    init(style: EpisodeViewStyle = .small) {
        self.style = style
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Subviews
    lazy var imgView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        switch style {
        case .small:
            label.configureQuaternaryTitle()
        case .big:
            label.configureSecondaryTitle()
        }
        return label
    }()
    
    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()
    
    lazy var episodeLabel = createLabel()
    
    lazy var seasonLabel = createLabel()
    
    lazy var airedAtLabel = createLabel()
    
    // MARK: - Methods
    private func setupSubviews() {
        addSubview(imgView)
        addSubview(titleLabel)
        addSubview(infoStackView)
        
        [episodeLabel, seasonLabel, airedAtLabel].forEach({ infoStackView.addArrangedSubview($0) })
        
        let imgViewBottomConstraint = imgView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -Constants.margin)
        imgViewBottomConstraint.priority = .defaultLow - 1
        
        NSLayoutConstraint.activate([
            imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constants.margin),
            imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: Constants.margin),
            imgView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: style.imageWidthProportion),
            imgView.heightAnchor.constraint(equalTo: imgView.widthAnchor, multiplier: Constants.imageAspectRatio),
            imgViewBottomConstraint,
            
            titleLabel.topAnchor.constraint(equalTo: imgView.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: Constants.margin),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -Constants.margin),
            
            infoStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            infoStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.spacing),
            infoStackView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            infoStackView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -Constants.margin)
        ])
    }
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.configureSecondaryText()
        return label
    }
    
    private func setupData() {
        guard let episode = episode else {
            return
        }
        
        titleLabel.text = episode.name
        imgView.setRemoteImage(atURL: episode.image?.medium, withContentMode: .scaleAspectFill)
        
        let episodeNumberText = "Episode \(episode.number)"
        if let runtime = episode.runtime {
            episodeLabel.text = "\(episodeNumberText) - \(runtime) min"
        } else {
            episodeLabel.text = episodeNumberText
        }
        
        if style.shouldDisplaySeason {
            seasonLabel.isHidden = false
            seasonLabel.text = "Season \(episode.season)"
        } else {
            seasonLabel.isHidden = true
        }
        
        if let airDate = episode.airdate {
            airedAtLabel.isHidden = false
            airedAtLabel.text = DateFormatter.longDate.string(from: airDate)
        } else {
            airedAtLabel.isHidden = true
        }
    }
}
