//
//  UIViewExtensions.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit

extension UIView {
    func fillSuperview() {
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    func fillSafeArea() {
        guard let superview = superview else { return }
        
        let safeArea = superview.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: safeArea.topAnchor),
            leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func centerOnSuperview() {
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ])
    }
}
