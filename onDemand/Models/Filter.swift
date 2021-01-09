//
//  Filter.swift
//  onDemand
//
//  Created by Mayank Gandhi on 1/9/21.
//

import Foundation

struct Filter: Hashable {
  let id = UUID()
  let name: String

  static let allFilters = [Filter(name: "Filter 1"), Filter(name: "Filter 2")]
}
