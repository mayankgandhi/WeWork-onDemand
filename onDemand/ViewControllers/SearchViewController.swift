//
//  SearchViewController.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import MapKit
import UIKit

/// `SearchViewController` handles everything concerned with the search property tab in the TabView.
class SearchViewController: UIViewController, UICollectionViewDelegate, Storyboarded {
  var coordinator: SearchCoordinator?
  

  /// Action triggered when the user selects preferred property type.
  /// - Parameter sender: Segmented control that allows the user to switch between `spaces` and `rooms`
  func propertyTypeChanged(_ sender: UISegmentedControl) {
    print(#function)
    performQuery(of: sender.selectedSegmentIndex == 0 ? .location : .room)
  }
  

  var annotations = [MapProperty]()
  
  enum Section: CaseIterable {
    case main
  }

  var searchCollectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, Property>!
  
  override func viewDidLoad() {
    print(#function)
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    layout()
    configureDataSource()
    performQuery()
    coordinator = SearchCoordinator(navigationController: navigationController!)
  }

  func layout() {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.delegate = self
    collectionView.register(PropertyCell.self, forCellWithReuseIdentifier: PropertyCell.reuseID)
    self.searchCollectionView = collectionView

    let stackView = UIStackView(arrangedSubviews: [searchCollectionView!])
    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: self.view.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
    ])
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print(self.searchCollectionView!.numberOfItems(inSection: 0))
  }

  func configureDataSource() {
    dataSource = UICollectionViewDiffableDataSource<Section, Property>(collectionView: searchCollectionView!, cellProvider: { (collectionView, indexPath, property) -> UICollectionViewCell? in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyCell", for: indexPath) as! PropertyCell
      cell.configure(with: property)
      return cell
    })
  }

  func performQuery(of type: PropertyType? = .location) {
    print(#function)

    let properties = Property.allProperties.filter { (prop) -> Bool in
      prop.type == type
    }
    print(properties.count)
//    performQueryonMap(for: properties)
    performQueryonTableView(for: properties)
  }

}

extension SearchViewController {

//  func performQueryonMap(for properties: [Property]) {
//    mapView.removeAnnotations(annotations)
//    annotations.removeAll()
//    properties.forEach { prop in
//      annotations.append(prop.getAnnotation())
//    }
//    mapView.addAnnotations(annotations)
//    mapView.showAnnotations(annotations, animated: true)
//  }

  func performQueryonTableView(for properties: [Property]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, Property>()
    snapshot.appendSections([.main])
    snapshot.appendItems(properties)
    dataSource.apply(snapshot, animatingDifferences: true)
  }
  
  func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let propertySelected: Property = dataSource.itemIdentifier(for: indexPath)!
    coordinator?.showDetail(for: propertySelected)
  }
}
