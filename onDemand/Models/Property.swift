//
//  Property.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import CoreLocation
import Foundation
import MapKit

enum PropertyType: CaseIterable {
    case location, room
}

class MapProperty: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    init(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

struct Property: Hashable {
    let id = UUID()
    let type: PropertyType

    let title: String
    let description: String

    let imageURL: String

    let lat: Double
    let long: Double

    func getAnnotation() -> MapProperty {
        let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(long))
        return MapProperty(coordinate)
    }
}
