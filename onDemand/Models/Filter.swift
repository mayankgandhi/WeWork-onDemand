//
//  Filter.swift
//  onDemand
//
//  Created by Mayank Gandhi on 1/9/21.
//

import Foundation

struct Filter: Hashable {
  let id = UUID()
  let type: PropertyType

  static let allFilters = [Filter(type: .location), Filter(type: .room)]
}
