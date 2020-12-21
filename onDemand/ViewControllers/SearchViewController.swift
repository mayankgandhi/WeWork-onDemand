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
        let properties = Property.allProperties.filter { (prop) -> Bool in
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
