//
//  FilterOptionCell.swift
//  onDemand
//
//  Created by Mayank Gandhi on 1/9/21.
//

import Foundation
import UIKit

/// `FilterOptionCell` is the cell that is populated in the top section of the collectionView in the Search View Controller.
class FilterOptionCell: UICollectionViewCell {
    fileprivate var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.sizeToFit()
        label.lineBreakMode = .byClipping
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()

    override init(frame _: CGRect) {
        super.init(frame: .zero)

        let stackView = UIStackView(arrangedSubviews: [titleLabel])
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.clipsToBounds = true
        contentView.addSubview(stackView)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with filter: Filter) {
        titleLabel.text = String(describing: filter.type).capitalized
        if filter.selected {
            titleLabel.textColor = .blue
        } else {
            titleLabel.textColor = .darkText
        }
    }
}
