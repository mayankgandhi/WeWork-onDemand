//
//  PropertyCell.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import UIKit

class PropertyCell: UICollectionViewCell {

  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  func configure(with property: Property) {
    self.imageView.load(url: URL(string:property.imageURL)!)
    self.titleLabel.text = property.title
    self.descriptionLabel.text = property.description
  }

}
