# WeWork-onDemand

This project is a basic MVP version of the Wework OnDemand App. 

On a very high level, It contains 3 main tabs:
  - Search(SearchViewController) - Where users can look for coworking places to reserve
  - Reservations(ReservationsViewController) - Where users can track existing/past/upcoming reservations
  - Profile(ProfileViewController) - Where users can view/edit their credentials and other information
  
This project uses Coordinator Pattern to push the root view controller. Each of the viewControllers in the TabView are programmatically configured. The SearchViewController itself consists of 2 major components - a MapView and a CollecionView to depict the relevant Place or Room. The data for the viewControllers are programmatically coded. In a production scenario - the Codable Models can be used to serialize from the JSON.

The CollectionView consists of 2 sections: filters and properties. Filter is the option to select from between a Place and room. Another section of extra filters can be added to show date selector and other filters. The Datasource for the collectionView uses the new DiffableDataSource, Dequeuing reusable Cells, SectionSnapshots which makes it very performant. All the Layout is programmatically coded for each of the cells as well as the overall layout using UICollectionViewCompositionalLayout.

# The images used on the app are stock images that are randomly generated with a third party API. 
![](ezgif-3-a0679dc3255f.gif)
