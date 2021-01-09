//
//  NSObject+Identifier.swift
//  onDemand
//
//  Created by Mayank Gandhi on 1/9/21.
//

import Foundation

extension NSObject {
  static var identifier: String {
    return String(describing: self)
  }
}
