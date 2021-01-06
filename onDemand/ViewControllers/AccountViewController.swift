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
    tableView.register(AccountProgrammaticCell.self, forCellReuseIdentifier: AccountProgrammaticCell.reuseID)
    tableView.rowHeight = UITableView.automaticDimension
    tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    self.accountTableView = tableView
    view.addSubview(accountTableView)
    NSLayoutConstraint.activate([
      accountTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
      accountTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      accountTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      accountTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
    ])
  }

  func configureDataSource() {
    dataSource = UITableViewDiffableDataSource<Section, Item>(tableView: accountTableView, cellProvider: { (tableView, indexPath, item) -> UITableViewCell? in
      let cell = tableView.dequeueReusableCell(withIdentifier: AccountProgrammaticCell.reuseID, for: indexPath) as! AccountProgrammaticCell
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
