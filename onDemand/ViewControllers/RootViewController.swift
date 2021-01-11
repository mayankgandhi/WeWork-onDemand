//
//  RootViewController.swift
//  onDemand
//
//  Created by Mayank Gandhi on 1/6/21.
//

import UIKit

class RootViewController: UITabBarController, Storyboarded {
    var coordinator: MainCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        addTabBarItems()
    }

    private func addTabBarItems() {
        let searchVC = SearchViewController.instantiate()
        let searchTabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))
        searchTabBarItem.tag = 0
        searchVC.tabBarItem = searchTabBarItem

        let reservationsVC = ReservationsViewController.instantiate()
        let reservationsBarItem = UITabBarItem(title: "Reservations", image: UIImage(systemName: "calendar"), selectedImage: UIImage(systemName: "calendar.circle.fill"))
        reservationsBarItem.tag = 1
        reservationsVC.tabBarItem = reservationsBarItem

        let accountVC = AccountViewController.instantiate()
        let accountBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.fill"), selectedImage: UIImage(systemName: "person.circle.fill"))
        accountBarItem.tag = 2
        accountVC.tabBarItem = accountBarItem

        setViewControllers([searchVC, reservationsVC, accountVC], animated: true)
    }
}
