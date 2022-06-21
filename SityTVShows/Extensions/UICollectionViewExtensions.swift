//
//  UICollectionViewExtensions.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import UIKit

extension UICollectionView {
    func registerCell<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellWithReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeueReusableCell<Cell: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: identifier,
            for: indexPath) as? Cell
        else {
            fatalError("Cell type not registered: \(identifier)")
        }
        return cell
    }
}
