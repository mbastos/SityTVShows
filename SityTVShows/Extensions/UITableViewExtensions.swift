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
    
    func registerHeaderView<View: UITableViewHeaderFooterView>(_ viewClass: View.Type) {
        register(viewClass, forHeaderFooterViewReuseIdentifier: String(describing: viewClass))
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
    
    func dequeueReusableHeaderView<View: UITableViewHeaderFooterView>() -> View {
        let identifier = String(describing: View.self)
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: identifier) as? View
        else {
            fatalError("Header type not registered: \(identifier)")
        }
        return cell
    }
    
    func addLoadingFooter() {
        let activityIndicator = UIActivityIndicatorView(
            frame: CGRect(x: 0, y: 0, width: bounds.width, height: 80))
        activityIndicator.startAnimating()
        
        tableFooterView = activityIndicator
    }
    
    func removeLoadingFooter() {
        tableFooterView = nil
    }
}
