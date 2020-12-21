//
//  SearchViewController.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import UIKit

class SearchViewController: UIViewController {

  @IBOutlet weak var searchCollectionView: UICollectionView!


  var allProperties = [Property(type: .location,
                                title: "1150 S Olive St",
                                description: "WeWork Downtown Los Angeles",
                                imageURL: "https://picsum.photos/220/301",
                                lat: 34.03975457554052,
                                long: -118.26118191629129),
                       Property(type: .location, title: "1031 S Broadway", description: "Wework Los Angeles", imageURL: "https://picsum.photos/204/341", lat: 34.04072237799053, long: -118.25835261527308)]

  enum Section: CaseIterable {
    case main
  }

  var dataSource: UICollectionViewDiffableDataSource<Section,Property>!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    configureDataSource()
    performQuery()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

}

extension SearchViewController {

  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Property>(collectionView: searchCollectionView, cellProvider: { (collectionView, indexPath, property) -> UICollectionViewCell? in
      let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyCell", for: indexPath) as! PropertyCell
      cell.configure(with: property)
      return cell
    })
  }

  func performQuery(of type: PropertyType? = .location) {
    let properties = allProperties.filter { (prop) -> Bool in
      prop.type == type
    }

    var snapshot = NSDiffableDataSourceSnapshot<Section, Property>()
    snapshot.appendSections([.main])
    snapshot.appendItems(properties)
    dataSource.apply(snapshot, animatingDifferences: true)
  }

}
