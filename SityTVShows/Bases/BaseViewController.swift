//
//  BaseViewController.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit

class BaseViewController: UIViewController {
    weak var errorAlert: UIAlertController?
    
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
        guard activityIndicator.superview == nil else {
            return
        }
        setupBackgroundView()
        setupActivityIndicator()
        activityIndicator.startAnimating()
        
        self.backgroundView.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.backgroundView.alpha = 1.0
        }
    }
    
    internal func stopLoading() {
        if activityIndicator.superview != nil {
            activityIndicator.stopAnimating()
            self.backgroundView.removeFromSuperview()
            self.activityIndicator.removeFromSuperview()
        }
    }
    
    internal func showErrorAlert(message: String, onTryAgain: @escaping () -> Void, onCancel: (() -> Void)? = nil) {
        if let errorAlert = errorAlert {
            errorAlert.dismiss(animated: false) {
                self.presentErrorAlert(message: message, onTryAgain: onTryAgain, onCancel: onCancel)
            }
        } else {
            self.presentErrorAlert(message: message, onTryAgain: onTryAgain, onCancel: onCancel)
        }
    }
    
    private func presentErrorAlert(message: String, onTryAgain: @escaping () -> Void, onCancel: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        
        let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { _ in
            onTryAgain()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            onCancel?()
        }
        
        alertController.addAction(tryAgainAction)
        alertController.addAction(cancelAction)
        
        guard presentedViewController == nil else { return }
        present(alertController, animated: true)
        
        self.errorAlert = alertController
    }
}
