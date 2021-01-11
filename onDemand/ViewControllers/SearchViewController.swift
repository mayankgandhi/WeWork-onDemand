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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coordinator = SearchCoordinator(navigationController: navigationController!)
        layout()
        configureDataSource()
        performQuery()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: searchCollectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in

            if indexPath.section == 1 {
                let property = item as! Property
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PropertyCell.identifier,
                    for: indexPath
                ) as? PropertyCell
                cell?.configure(with: property)
                return cell

            } else {
                let filter = item as! Filter
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: FilterOptionCell.identifier,
                    for: indexPath
                ) as? FilterOptionCell
                cell?.configure(with: filter)
                return cell
            }

        })
    }
}

extension SearchViewController {
    func generatePropertyLayout() -> NSCollectionLayoutSection {
        // 1
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )

        let propertyView = NSCollectionLayoutItem(layoutSize: itemSize)
        propertyView.contentInsets = NSDirectionalEdgeInsets(
            top: .contentInset,
            leading: .contentInset,
            bottom: .contentInset,
            trailing: .contentInset
        )

        // 2
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(4 / 5),
            heightDimension: .fractionalHeight(4 / 5)
        )

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: propertyView,
            count: 1
        )

        // 3
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }

    func generateOptionsLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .absolute(140),
            heightDimension: .absolute(70)
        )
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: .contentInset,
            leading: .contentInset,
            bottom: .contentInset,
            trailing: .contentInset
        )

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }

    func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
                                                            _: NSCollectionLayoutEnvironment)
                -> NSCollectionLayoutSection? in

            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .options:
                return self.generateOptionsLayout()
            case .main:
                return self.generatePropertyLayout()
            }
        }
        return layout
    }

    func layout() {
        view.backgroundColor = .white

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: generateLayout())
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        collectionView.delegate = self
        collectionView.register(PropertyCell.self, forCellWithReuseIdentifier: PropertyCell.identifier)
        collectionView.register(FilterOptionCell.self, forCellWithReuseIdentifier: FilterOptionCell.identifier)

        searchCollectionView = collectionView

        let mapView = MKMapView(frame: .zero)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        searchMapView = mapView

        let stackView = UIStackView(arrangedSubviews: [searchMapView, searchCollectionView])
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
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let filterSelected: Filter = dataSource.itemIdentifier(for: indexPath)! as! Filter
            performQuery(of: filterSelected.type)
        } else {
            let propertySelected: Property = dataSource.itemIdentifier(for: indexPath)! as! Property
            coordinator?.showDetail(for: propertySelected)
        }
    }
}

extension SearchViewController {
    func performQuery(of type: PropertyType = .location) {
        if let properties = coordinator?.getProperties(of: type) {
            performQueryonMap(for: properties)
            performQueryOnCollectionView(for: properties, selected: Filter(type: type, selected: true))
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

    func performQueryOnCollectionView(for properties: [Property], selected: Filter) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(properties, toSection: .main)
        if selected.type == .location {
            let allFilters = [Filter(type: .location, selected: true), Filter(type: .room, selected: false)]
            snapshot.appendItems(allFilters, toSection: .options)
        } else {
            let allFilters = [Filter(type: .location, selected: false), Filter(type: .room, selected: true)]
            snapshot.appendItems(allFilters, toSection: .options)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
