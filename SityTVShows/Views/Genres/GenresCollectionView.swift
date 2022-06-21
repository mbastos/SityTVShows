//
//  GenresCollectionView.swift
//  SityTVShows
//
//  Created by mblabs on 20/06/22.
//

import UIKit

class GenresCollectionView: UICollectionView {
    // MARK: - Properties
    var genres: [String] = [] {
        didSet {
            reloadData()
        }
    }
    
    // MARK: - Initializers
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.estimatedItemSize = CGSize(width: 100, height: 16)
        layout.minimumInteritemSpacing = 3
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        isScrollEnabled = true
        showsHorizontalScrollIndicator = false
        dataSource = self
        
        registerCell(GenreCollectionViewCell.self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GenresCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: GenreCollectionViewCell = dequeueReusableCell(forIndexPath: indexPath)
        cell.text = genres[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return genres.count
    }
}
