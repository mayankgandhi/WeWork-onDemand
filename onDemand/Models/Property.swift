//
//  Property.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import CoreLocation
import Foundation
import MapKit

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

    static var allProperties = [
        Property(type: .location,
                 title: "1150 S Olive St",
                 description: "WeWork Downtown Los Angeles",
                 imageURL: "https://picsum.photos/220/301",
                 lat: 34.03975457554052,
                 long: -118.26118191629129),
        Property(type: .location,
                 title: "1031 S Broadway",
                 description: "Wework Los Angeles",
                 imageURL: "https://picsum.photos/204/341",
                 lat: 34.04072237799053,
                 long: -118.25835261527308),
        Property(type: .room, title: "Room 35C",
                 description: "555 West 5th Street, 35th Floor",
                 imageURL: "https://picsum.photos/221/356",
                 lat: 34.04072237791053,
                 long: -118.25835261527310),
        Property(type: .room, title: "Room 36C",
                 description: "555 West 5th Street, 36th Floor",
                 imageURL: "https://picsum.photos/221/456",
                 lat: 34.04072237791053,
                 long: -118.25835261527310),
        Property(type: .location, title: "The Maxwell",
                 description: "The Maxwell Los Angeles",
                 imageURL: "https://picsum.photos/224/416",
                 lat: 34.042660653219855,
                 long: -118.23353256137416),
    ]
}

class MapProperty: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D

    init(_ coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

enum PropertyType: CaseIterable {
    case location, room
}
