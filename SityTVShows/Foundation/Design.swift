//
//  Design.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import UIKit

extension UILabel {
    func configureTitle() {
        font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        textColor = .label
    }
    
    func configureSecondaryTitle() {
        font = UIFont.systemFont(ofSize: 20, weight: .medium)
        textColor = .label
    }
    
    func configureTertiaryTitle() {
        font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textColor = .label
    }
    
    func configureQuaternaryTitle() {
        font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textColor = .label
    }
    
    func configureSecondaryText() {
        font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textColor = .secondaryLabel
    }
}
