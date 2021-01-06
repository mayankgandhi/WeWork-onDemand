//
//  AccountCell.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/21/20.
//

import UIKit

/// `AccountCell`: Custom TableViewCell for the TableView View in the AccountViewController that represents account info.
class AccountCell: UITableViewCell {
    static let reuseID = "AccountCell"

    func configure(for item: AccountViewController.Item) {
        imageView?.image = UIImage(systemName: item.systemImage)
        textLabel?.text = item.title
    }
}
