//
//  SearchViewController.swift
//  onDemand
//
//  Created by Mayank Gandhi on 12/20/20.
//

import MapKit
import UIKit

class SearchViewController: UIViewController, UICollectionViewDelegate {
    var coordinator: SearchCoordinator?

    @IBOutlet var searchCollectionView: UICollectionView!

    @IBAction func propertyTypeChanged(_ sender: UISegmentedControl) {
        print(#function)
        performQuery(of: sender.selectedSegmentIndex == 0 ? .location : .room)
    }

    @IBOutlet var mapView: MKMapView!
    var annotations = [MapProperty]()

    var allProperties = [
        Property(type: .location,
                 title: "1150 S Olive St",
                 description: "WeWork Downtown Los Angeles",
                 imageURL: "https://picsum.photos/220/301",
                 lat: 34.03975457554052,
                 long: -118.26118191629129),
        Property(type: .location,
                 title: "1031 S Broadway",
                 description: "Wework Los Angeles",
                 imageURL: "https://picsum.photos/204/341",
                 lat: 34.04072237799053,
                 long: -118.25835261527308),
        Property(type: .room, title: "Room 35C",
                 description: "555 West 5th Street, 35th Floor",
                 imageURL: "https://picsum.photos/221/356",
                 lat: 34.04072237791053,
                 long: -118.25835261527310),
        Property(type: .room, title: "Room 36C",
                 description: "555 West 5th Street, 36th Floor",
                 imageURL: "https://picsum.photos/221/456",
                 lat: 34.04072237791053,
                 long: -118.25835261527310),
        Property(type: .location, title: "The Maxwell",
                 description: "The Maxwell Los Angeles",
                 imageURL: "https://picsum.photos/224/416",
                 lat: 34.042660653219855,
                 long: -118.23353256137416),
    ]

    enum Section: CaseIterable {
        case main
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Property>!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchCollectionView.delegate = self
        configureDataSource()
        performQuery()
        coordinator = SearchCoordinator(navigationController: navigationController!)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension SearchViewController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Property>(collectionView: searchCollectionView, cellProvider: { (collectionView, indexPath, property) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyCell", for: indexPath) as! PropertyCell
            cell.configure(with: property)
            return cell
        })
    }

    func performQuery(of type: PropertyType? = .location) {
        let properties = allProperties.filter { (prop) -> Bool in
            prop.type == type
        }

        mapView.removeAnnotations(annotations)
        annotations.removeAll()
        properties.forEach { prop in
            annotations.append(prop.getAnnotation())
        }
        mapView.addAnnotations(annotations)
        mapView.showAnnotations(annotations, animated: true)

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
