//
//  UITableViewExtensions.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit

extension UITableView {
    func registerCell<Cell: UITableViewCell>(_ cellClass: Cell.Type) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
    
    func dequeueReusableCell<Cell: UITableViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = dequeueReusableCell(
            withIdentifier: identifier,
            for: indexPath) as? Cell
        else {
            fatalError("Cell type not registered: \(identifier)")
        }
        return cell
    }
}
