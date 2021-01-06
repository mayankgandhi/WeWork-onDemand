//
//  MainCoordinator.swift
//  onDemand
//
//  Created by Mayank Gandhi on 1/6/21.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
  var childCoordinators = [Coordinator]()
  var navigationController: UINavigationController

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  func start() {
    let vc = RootViewController.instantiate()
    vc.coordinator = self
    navigationController.setNavigationBarHidden(true, animated: true)
    navigationController.pushViewController(vc, animated: false)
  }
}
