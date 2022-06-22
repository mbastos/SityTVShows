//
//  EpisodeDetailsViewController.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import UIKit

class EpisodeDetailsViewController: BaseViewController {
    
    // MARK: - Constants
    private enum Constants {
        static let ratingStarsWidth: CGFloat = 100
    }
    
    // MARK: - Properties
    var episode: ShowEpisode?
    
    // MARK: - Initializers
    convenience init(episode: ShowEpisode) {
        self.init()
        self.episode = episode
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episode"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        
        setupSubviews()
        setupData()
    }
    
    // MARK: - Subviews
    lazy var episodeView: EpisodeView = {
        let view = EpisodeView(style: .big)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    lazy var summaryView: SummaryView = {
        let view = SummaryView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Methods
    private func setupSubviews() {
        view.addSubview(episodeView)
        view.addSubview(ratingStarsView)
        view.addSubview(ratingLabel)
        view.addSubview(summaryView)
        
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            episodeView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            episodeView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            episodeView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            
            ratingStarsView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: .defaultMargin),
            ratingStarsView.topAnchor.constraint(equalTo: episodeView.bottomAnchor, constant: .defaultMargin),
            ratingStarsView.widthAnchor.constraint(equalToConstant: Constants.ratingStarsWidth),
            
            ratingLabel.leadingAnchor.constraint(equalTo: ratingStarsView.trailingAnchor, constant: 8),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingStarsView.centerYAnchor),
            
            summaryView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            summaryView.topAnchor.constraint(equalTo: ratingStarsView.bottomAnchor),
            summaryView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    private func setupData() {
        guard let episode = episode else {
            return
        }

        episodeView.episode = episode
        
        if let averageRating = episode.rating?.averageOnScaleOfFive {
            ratingStarsView.rating = averageRating
            ratingLabel.text = episode.rating?.fullFormattedAverage
        } else {
            ratingStarsView.isHidden = true
            ratingLabel.isHidden = true
        }
        
        summaryView.summary = episode.summary ?? "No summary available"
    }
}
