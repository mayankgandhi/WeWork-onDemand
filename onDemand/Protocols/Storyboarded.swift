//
//  Storyboarded.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/21/20.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let inVC = storyboard.instantiateViewController(withIdentifier: id) as! Self
        print(inVC)
        return inVC
    }
}
