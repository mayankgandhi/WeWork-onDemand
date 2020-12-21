//
//  UIImageView+Load.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import Foundation
import UIKit

extension UIImageView {
  func load(url: URL) {
    DispatchQueue.global().async { [weak self] in
      if let data = try? Data(contentsOf: url) {
        if let image = UIImage(data: data) {
          DispatchQueue.main.async {
            self?.image = image
          }
        }
      }
    }
  }
}
