//
//  FavoritesViewController.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit
import RealmSwift

class FavoritesViewController: UITableViewController {
    
    var notificationToken: NotificationToken?
    let results = Persistence.shared.realm.objects(FavoriteShow.self).sorted(byKeyPath: "name")
    
    deinit {
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemBackground
        
        tableView.registerCell(UITableViewCell.self)
        
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let self = self else { return }
            
            switch changes {
            case .initial:
                self.tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                self.tableView.performBatchUpdates({
                    self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                })
            case .error(let error):
                Logging.logError(error: error)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        
        var configuration = cell.defaultContentConfiguration()
        configuration.text = results[indexPath.row].name
        cell.contentConfiguration = configuration
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Persistence.shared.removeFavorite(withId: results[indexPath.row].id)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = results[indexPath.row].id
        let viewModel = ShowDetailsViewModel(showId: id, repository: TVMazeRepository())
        let vc = ShowDetailsViewController(viewModel: viewModel)
        show(vc, sender: self)
    }
}
