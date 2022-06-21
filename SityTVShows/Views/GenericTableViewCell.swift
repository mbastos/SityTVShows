//
//  GenericTableViewCell.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit

class GenericTableViewCell<View: UIView>: UITableViewCell {
    
    var cellView: View? {
        didSet {
            setupView()
        }
    }
    
    private func setupView() {
        guard let cellView = cellView else { return }
        
        contentView.addSubview(cellView)
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.fillSuperview()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
