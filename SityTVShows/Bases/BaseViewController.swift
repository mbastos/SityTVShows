//
//  BaseViewController.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit

class BaseViewController: UIViewController {
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    private func setupBackgroundView() {
        view.addSubview(backgroundView)
        
        NSLayoutConstraint.activate([
            view.leftAnchor.constraint(equalTo: backgroundView.leftAnchor),
            view.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            view.rightAnchor.constraint(equalTo: backgroundView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
        
        backgroundView.isHidden = true
        backgroundView.alpha = 0.0
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerOnSuperview()
    }
    
    internal func startLoading() {
        setupBackgroundView()
        setupActivityIndicator()
        activityIndicator.startAnimating()
        
        self.backgroundView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.backgroundView.alpha = 1.0
        }
    }
    
    internal func stopLoading() {
        activityIndicator.stopAnimating()
        UIView.animate(
            withDuration: 0.5,
            animations: { self.backgroundView.alpha = 0.0 },
            completion: { _ in
                self.backgroundView.removeFromSuperview()
                self.activityIndicator.removeFromSuperview()
            })
    }
    
    internal func showErrorAlert(message: String, onTryAgain: @escaping () -> Void, onCancel: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Oops! An error has occurred", message: message, preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { _ in
            onTryAgain()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            onCancel?()
        }
        
        alertController.addAction(tryAgainAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true)
    }
}
