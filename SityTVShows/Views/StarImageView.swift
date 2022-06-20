//
//  StarImageView.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit

class StarImageView: UIImageView {
    
    // MARK: - Constants
    private enum Constants {
        static let filledColor = UIColor.systemYellow.cgColor
        static let emptyColor = UIColor.systemGray.cgColor
    }
    
    // MARK: - Properties
    private let gradient = CAGradientLayer()
    private let gradientMask = CALayer()
    
    var fillRatio: Double = 1 {
        didSet {
            setLocations()
        }
    }
    
    // MARK: - Initializers
    init(fillRatio: Double) {
        let star = UIImage(systemName: "star.fill")
        
        super.init(image: star)
                
        gradient.frame = self.bounds
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)
        gradient.colors = [Constants.filledColor, Constants.filledColor, Constants.emptyColor, Constants.emptyColor]
        self.fillRatio = fillRatio
        
        gradientMask.contents = star?.cgImage
        gradientMask.frame = self.bounds

        gradient.mask = gradientMask
        gradient.masksToBounds = true
        
        layer.insertSublayer(gradient, at: 0)
        
        setLocations()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        
        layoutIfNeeded()
        
        gradient.frame = self.bounds
        gradientMask.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        
    }
    
    private func setLocations() {
        let fillRatio = NSNumber(floatLiteral: fillRatio)
        gradient.locations = [0, fillRatio, fillRatio, 1]
    }
}
