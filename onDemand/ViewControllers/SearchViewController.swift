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
        case main
    }

    var searchCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Property>!
    var searchMapView: MKMapView!
    var placeTypeSegmentedControl: UISegmentedControl {
        let segmentItems = ["First", "Second"]
        let segmentedControl = UISegmentedControl(items: segmentItems)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.addTarget(self, action: #selector(segmentControl(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 1
        return segmentedControl
    }

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
        view.backgroundColor = .white

        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .red
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.delegate = self
        collectionView.register(PropertyCell.self, forCellWithReuseIdentifier: PropertyCell.reuseID)
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
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchMapView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(searchCollectionView!.numberOfItems(inSection: 0))
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
        dataSource = UICollectionViewDiffableDataSource<Section, Property>(collectionView: searchCollectionView!, cellProvider: { (collectionView, indexPath, property) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PropertyCell", for: indexPath) as! PropertyCell
            cell.configure(with: property)
            return cell
        })
    }
}

extension SearchViewController {
    func performQuery(of type: PropertyType? = .location) {
        let properties = Property.allProperties.filter { (prop) -> Bool in
            prop.type == type
        }
        print(properties.count)
        performQueryonMap(for: properties)
        performQueryOnCollectionView(for: properties)
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
        var snapshot = NSDiffableDataSourceSnapshot<Section, Property>()
        snapshot.appendSections([.main])
        snapshot.appendItems(properties)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let propertySelected: Property = dataSource.itemIdentifier(for: indexPath)!
        coordinator?.showDetail(for: propertySelected)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        CGSize(width: searchCollectionView.frame.width / 1.5, height: searchCollectionView.frame.height / 1.25)
    }
}
