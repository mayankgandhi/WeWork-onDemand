//
//  Coordinator.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/21/20.
//

import Foundation
import UIKit

/// An extremely basic protocol that allows coordinator pattern
/// The `Coordinator pattern` is used her to perform the handoff between tapping on the collection view items and their respective detail ViewController
protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func start()
}
