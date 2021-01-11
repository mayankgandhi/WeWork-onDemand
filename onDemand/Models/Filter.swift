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
    let selected: Bool
}
