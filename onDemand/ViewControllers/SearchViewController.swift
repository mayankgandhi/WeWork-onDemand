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

  var annotations = [MapProperty]()

  enum Section: CaseIterable {
    case options
    case main
  }

  var searchCollectionView: UICollectionView!
  var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
  var searchMapView: MKMapView!
  var placeTypeSegmentedControl: UISegmentedControl {
    let segmentItems = ["Spaces", "Rooms"]
    let segmentedControl = UISegmentedControl(items: segmentItems)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
    segmentedControl.selectedSegmentIndex = 0
    return segmentedControl
  }

  override func viewDidLoad() {
    print(#function)
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    coordinator = SearchCoordinator(navigationController: navigationController!)
    layout()
    configureDataSource()
    performQuery()
  }

//  func createPerSectionLayout() -> UICollectionViewLayout {
//
//    let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
//                                                        layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
//      let columns = sectionIndex == 0 ? 2 : 4
//      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                            heightDimension: .fractionalHeight(1.0))
//      let item = NSCollectionLayoutItem(layoutSize: itemSize)
//      let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                             heightDimension: .absolute(250))
//      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                     subitem: item,
//                                                     count: columns)
//      let section = NSCollectionLayoutSection(group: group)
//      return section
//    }
//
//    let config = UICollectionViewCompositionalLayoutConfiguration()
//    config.interSectionSpacing = 200
//    config.scrollDirection = .horizontal
//    layout.configuration = config
//    return layout
//  }

  func generateLayout() -> UICollectionViewLayout {
    //1
    let itemSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(1.0),
      heightDimension: .fractionalHeight(1.0))
    let propertyView = NSCollectionLayoutItem(layoutSize: itemSize)
    propertyView.contentInsets = NSDirectionalEdgeInsets(
      top: 2,
      leading: 2,
      bottom: 2,
      trailing: 2)
    //2
    let groupSize = NSCollectionLayoutSize(
      widthDimension: .fractionalWidth(2/3),
      heightDimension: .fractionalHeight(1))
    let group = NSCollectionLayoutGroup.horizontal(
      layoutSize: groupSize,
      subitem: propertyView,
      count: 1)
    //3
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }


  func layout() {
    view.backgroundColor = .white

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
    collectionView.backgroundColor = .systemBackground
    collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    collectionView.delegate = self
    collectionView.register(PropertyCell.self, forCellWithReuseIdentifier: PropertyCell.identifier)
    //    collectionView.register(FilterOptionCell.self, forCellWithReuseIdentifier: FilterOptionCell.reuseID)

    searchCollectionView = collectionView

    let mapView = MKMapView(frame: .zero)
    mapView.translatesAutoresizingMaskIntoConstraints = false
    searchMapView = mapView

    let stackView = UIStackView(arrangedSubviews: [searchMapView, placeTypeSegmentedControl, searchCollectionView])
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.distribution = .fill
    view.addSubview(stackView)

    NSLayoutConstraint.activate([
      stackView.topAnchor.constraint(equalTo: view.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      searchMapView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.5),
    ])
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.navigationController?.setNavigationBarHidden(true, animated: animated)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print(searchCollectionView!.numberOfItems(inSection: 0))
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.navigationController?.setNavigationBarHidden(false, animated: animated)
  }

  @objc func segmentControl(_ segmentedControl: UISegmentedControl) {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      // First segment tapped
      performQuery(of: .location)
    case 1:
      // Second segment tapped
      performQuery(of: .room)
    default:
      break
    }
  }

  func configureDataSource() {

    dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: searchCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in

      if let property = item as? Property {
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: PropertyCell.identifier,
          for: indexPath) as? PropertyCell
        cell?.configure(with: property)
        return cell

      }

      if let filter = item as? Filter {
        let cell = collectionView.dequeueReusableCell(
          withReuseIdentifier: FilterOptionCell.identifier,
          for: indexPath) as? FilterOptionCell
        cell?.configure(with: filter)
        return cell

      }
      return nil
    })

  }


}

extension SearchViewController {

  func performQuery(of type: PropertyType = .location) {
    if let properties = coordinator?.getProperties(of: type) {
      performQueryonMap(for: properties)
      performQueryOnCollectionView(for: properties)
    }
  }

  func performQueryonMap(for properties: [Property]) {
    searchMapView.removeAnnotations(annotations)
    annotations.removeAll()
    properties.forEach { prop in
      annotations.append(prop.getAnnotation())
    }
    searchMapView.addAnnotations(annotations)
    searchMapView.showAnnotations(annotations, animated: true)
  }

  func performQueryOnCollectionView(for properties: [Property]) {
    var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
    snapshot.appendSections(Section.allCases)
    snapshot.appendItems(properties, toSection: .main)
    snapshot.appendItems(Property.allProperties, toSection: .options)
    dataSource.apply(snapshot, animatingDifferences: true)
  }

}

extension SearchViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let propertySelected: Property = dataSource.itemIdentifier(for: indexPath)! as! Property
    coordinator?.showDetail(for: propertySelected)
  }

}
