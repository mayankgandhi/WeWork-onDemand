//
//  PropertyCell.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import UIKit

/// `PropertyCell`: Custom CollectionView Cell for the Collection View in the SearchViewController that represent each property space.
class PropertyCell: UICollectionViewCell {
    private var imageView: UIImageView = {
        let thumbnailImage = UIImageView()
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImage.contentMode = .scaleAspectFill
        thumbnailImage.clipsToBounds = true
        thumbnailImage.layer.cornerRadius = 10
        return thumbnailImage
    }()

    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byClipping
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    fileprivate var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.lineBreakMode = .byClipping
        label.numberOfLines = 0
        label.font = .preferredFont(forTextStyle: .subheadline)
        return label
    }()

    override init(frame _: CGRect) {
        super.init(frame: .zero)

        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel, descriptionLabel])
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.clipsToBounds = true
        stackView.distribution = .equalSpacing
        contentView.addSubview(stackView)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with property: Property) {
        imageView.load(url: URL(string: property.imageURL)!)
        titleLabel.text = property.title
        descriptionLabel.text = property.description
    }
}
