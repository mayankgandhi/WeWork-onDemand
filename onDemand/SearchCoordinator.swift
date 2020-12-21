//
//  SearchCoordinator.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/21/20.
//

import Foundation
import UIKit

class SearchCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
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
