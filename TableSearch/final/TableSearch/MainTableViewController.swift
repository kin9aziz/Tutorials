/*
 Abstract:
 The application's primary table view controller showing a list of products.
 */

import UIKit

class MainTableViewController: UITableViewController {
  
  let products = [
    Product(title: "Ginger"),
    Product(title: "Gladiolus"),
    Product(title: "Orchid"),
    Product(title: "Poinsettia"),
    Product(title: "Red Rose"),
    Product(title: "White Rose"),
    Product(title: "Tulip"),
    Product(title: "Carnation"),
    Product(title: "Sunflower"),
    Product(title: "Gardenia")
  ]
  
  /// NSPredicate expression keys.
  private enum ExpressionKeys: String {
    case title
  }
  
  /// Search controller to help us with filtering.
  private var searchController: UISearchController!
  
  /// Secondary search results table view.
  private var resultsTableController: ResultsTableController!
  
  let tableViewCellIdentifier = "cellID"
  let tableViewCellName = "TableCell"
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nib = UINib(nibName: tableViewCellName, bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: tableViewCellIdentifier)
    
    resultsTableController = ResultsTableController()
    
    searchController = UISearchController(searchResultsController: resultsTableController)
    searchController.searchResultsUpdater = self
    searchController.searchBar.autocapitalizationType = .none
    searchController.obscuresBackgroundDuringPresentation = false // The default is true.
    searchController.searchBar.delegate = self // Monitor when the search button is tapped.
    
    navigationItem.searchController = searchController
    navigationItem.hidesSearchBarWhenScrolling = false // Make the search bar always visible.
  }
  
}

// MARK: - UITableViewDataSource
extension MainTableViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
    
    let product = products[indexPath.row]
    cell.textLabel?.text = product.title
    
    return cell
  }
  
}

// MARK: - UISearchBarDelegate
extension MainTableViewController: UISearchBarDelegate {
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
}

// MARK: - UISearchResultsUpdating
extension MainTableViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    // Update the filtered array based on the search text.
    let searchResults = products
    
    // Strip out all the leading and trailing spaces.
    let strippedString = searchController.searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    
    // Create predicate
    let titleExpression = NSExpression(forKeyPath: ExpressionKeys.title.rawValue)
    let searchStringExpression = NSExpression(forConstantValue: strippedString)
    let titleSearchComparisonPredicate = NSComparisonPredicate(
      leftExpression: titleExpression,
      rightExpression: searchStringExpression,
      modifier: .direct,
      type: .contains,
      options: [.caseInsensitive, .diacriticInsensitive])
    
    let filteredResults = searchResults.filter { titleSearchComparisonPredicate.evaluate(with: $0) }
    
    // Apply the filtered results to the search results table.
    if let resultsController = searchController.searchResultsController as? ResultsTableController {
      resultsController.filteredProducts = filteredResults
      resultsController.tableView.reloadData()
    }
  }
  
}
