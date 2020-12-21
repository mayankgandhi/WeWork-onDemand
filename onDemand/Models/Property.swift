//
//  Property.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import Foundation
import CoreLocation

enum PropertyType: CaseIterable {
  case location, room
}

struct Property: Hashable {
  
  let id = UUID()
  let type: PropertyType

  let title: String
  let description: String

  let imageURL: String

  let lat: Double
  let long: Double

  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
  }

}
