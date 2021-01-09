//
//  SpaceDetailViewController.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/21/20.
//

import MapKit
import UIKit

/// `SpaceDetailViewController` shows in depth information of the property that was selected.
class SpaceDetailViewController: UIViewController, Storyboarded {
  weak var coordinator: SearchCoordinator?
  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var descriptionLabel: UILabel!
  @IBOutlet var mapView: MKMapView!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  func configure(for property: Property) {
    navigationItem.title = property.title
    imageView.load(url: URL(string: property.imageURL)!)
    titleLabel.text = property.title
    descriptionLabel.text = property.description

    let annotation = property.getAnnotation() as! MKAnnotation
    mapView.addAnnotation(annotation)
    mapView.showAnnotations([annotation], animated: true)
  }
}
