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

    var accountTableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, Item>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        layout()
        configureDataSource()
        generateSnapShot(animated: false)
    }
}

extension AccountViewController {
    func layout() {
        navigationItem.title = "List"
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(AccountCell.self, forCellReuseIdentifier: AccountCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        accountTableView = tableView
        view.addSubview(accountTableView)
        NSLayoutConstraint.activate([
            accountTableView.topAnchor.constraint(equalTo: view.topAnchor),
            accountTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            accountTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            accountTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: accountTableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountCell.identifier, for: indexPath) as! AccountCell
            cell.configure(for: item)
            return cell
        })

        dataSource.defaultRowAnimation = .fade
    }

    func generateSnapShot(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let properties = [
            Item(systemImage: "person.crop.circle.fill", title: "Profile"),
            Item(systemImage: "creditcard.circle.fill", title: "Payment"),
            Item(systemImage: "cross.case.fill", title: "Health & Safety"),
            Item(systemImage: "message.circle.fill", title: "Help & Feedback"),
        ]
        snapshot.appendSections([.main])
        snapshot.appendItems(properties)
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}
