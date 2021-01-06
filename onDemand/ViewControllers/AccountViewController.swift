//
//  AccountViewController.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import UIKit

class AccountViewController: UIViewController, Storyboarded {
    enum Section: CaseIterable {
        case main
    }

    struct Item: Hashable {
        let systemImage: String
        let title: String
    }

    @IBOutlet var accountTableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        accountTableView.rowHeight = UITableView.automaticDimension
        accountTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        configureDataSource()
        generateSnapShot()
    }
}

extension AccountViewController {
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: accountTableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            guard self != nil else { return nil }

            let cell = tableView.dequeueReusableCell(withIdentifier: AccountCell.reuseID, for: indexPath) as! AccountCell
            cell.configure(for: item)
            return cell
        })

        dataSource.defaultRowAnimation = .fade
    }

    func generateSnapShot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let properties = [
            Item(systemImage: "person.crop.circle.fill", title: "Profile"),
            Item(systemImage: "creditcard.circle.fill", title: "Payment"),
            Item(systemImage: "cross.case.fill", title: "Health & Safety"),
            Item(systemImage: "message.circle.fill", title: "Help & Feedback"),
        ]
        snapshot.appendSections([.main])
        snapshot.appendItems(properties)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
