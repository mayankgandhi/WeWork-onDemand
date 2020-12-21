//
//  PropertyCell.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import UIKit

class PropertyCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!

    func configure(with property: Property) {
        imageView.load(url: URL(string: property.imageURL)!)
        titleLabel.text = property.title
        descriptionLabel.text = property.description
    }
}
