//
//  HomeTabBarController.swift
//  SityTVShows
//
//  Created by mblabs on 19/06/22.
//

import UIKit

class HomeTabBarController: UITabBarController {
    
    private let repository = TVMazeRepository()
    
    lazy var shows: UIViewController = {
        let vc = ShowsViewController(viewModel: ShowsViewModel(repository: repository))
        vc.tabBarItem = UITabBarItem(
            title: "Shows",
            image: UIImage(systemName: "film"),
            selectedImage: UIImage(systemName: "film.fill"))
        return configureNavigationController(withRoot: vc)
    }()
    
    lazy var search: UIViewController = {
        let vc = SearchViewController(viewModel: SearchViewModel(repository: repository))
        vc.tabBarItem = UITabBarItem(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            tag: 2)
        return configureNavigationController(withRoot: vc)
    }()
    
    lazy var favorites: UIViewController = {
        let vc = FavoritesViewController()
        vc.tabBarItem = UITabBarItem(
            title: "Favorites",
            image: UIImage(systemName: "heart"),
            selectedImage: UIImage(systemName: "heart.fill"))
        return configureNavigationController(withRoot: vc)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        tabBar.tintColor = .systemOrange
        tabBar.backgroundColor = .systemBackground
        
        viewControllers = [shows, search, favorites]
    }
    
    private func configureNavigationController(withRoot rootVC: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootVC)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.tintColor = .systemOrange
        return navigationController
    }
}
