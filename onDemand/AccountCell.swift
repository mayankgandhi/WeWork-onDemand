//
//  AccountCell.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/21/20.
//

import UIKit

class AccountCell: UITableViewCell {
    static let reuseID = "AccountCell"

    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!

    func configure(for item: AccountViewController.Item) {
        itemImageView.image = UIImage(systemName: item.systemImage)
        titleLabel.text = item.title
    }
}