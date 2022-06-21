//
//  UIImageExtensions.swift
//  SityTVShows
//
//  Created by mblabs on 21/06/22.
//

import UIKit
import Kingfisher

extension UIImageView {
    static var placeholderImage = UIImage(named: "ic_no_image")?.withRenderingMode(.alwaysTemplate)
    
    func setRemoteImage(atURL url: URL?, withContentMode contentMode: UIView.ContentMode) {
        if let imageURL = url {
            image = nil
            self.contentMode = contentMode
            kf.setImage(with: imageURL)
        } else {
            self.contentMode = .center
            // There could be a Kingfisher load in progress, so we cancel it this way
            let resource: Resource? = nil
            kf.setImage(with: resource)
            image = UIImageView.placeholderImage
            tintColor = .systemGray
        }
    }
}
