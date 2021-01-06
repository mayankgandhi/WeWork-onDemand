//
//  SearchCoordinator.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/21/20.
//

import Foundation
import UIKit

/// SearchCoordinator helps us separate the concerns between viewcontrollers
/// In this particular case - Search Coordinator helps show detailView of the property space selected
class SearchCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
//    let vc = SpaceDetailViewController.instantiate()
//    vc.coordinator = self
//    navigationController.pushViewController(vc, animated: false)
    }

    func showDetail(for property: Property) {
        let vc = SpaceDetailViewController.instantiate()
        // Make iOS to build the views
        _ = vc.view
        vc.coordinator = self
        vc.configure(for: property)
        navigationController.pushViewController(vc, animated: true)
    }
}
