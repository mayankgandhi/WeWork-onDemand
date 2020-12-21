//
//  SpaceDetailViewController.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/21/20.
//

import UIKit

class SpaceDetailViewController: UIViewController, Storyboarded {

  weak var coordinator: SearchCoordinator?
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  func configure(for property: Property) {
    navigationItem.title = property.title
    titleLabel.text = property.title
    descriptionLabel.text = property.description
  }

}
