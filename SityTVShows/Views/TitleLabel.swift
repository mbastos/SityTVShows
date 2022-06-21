//
//  TitleLabel.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import UIKit

class TitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        config()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        config()
    }
    
    private func config() {
        font = UIFont.systemFont(ofSize: 20, weight: .medium)
        textColor = .label
    }
}
