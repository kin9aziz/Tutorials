/*
 Abstract:
 The application's primary table view controller showing a list of products.
 */

import UIKit

class MainTableViewController: BaseTableViewController {
  
  let products = [
    Product(title: "Ginger", yearIntroduced: 2007, introPrice: 49.98),
    Product(title: "Gladiolus", yearIntroduced: 2001, introPrice: 51.99),
    Product(title: "Orchid", yearIntroduced: 2007, introPrice: 16.99),
    Product(title: "Poinsettia", yearIntroduced: 2010, introPrice: 31.99),
    Product(title: "Red Rose", yearIntroduced: 2010, introPrice: 24.99),
    Product(title: "White Rose", yearIntroduced: 2012, introPrice: 24.99),
    Product(title: "Tulip", yearIntroduced: 1997, introPrice: 39.99),
    Product(title: "Carnation", yearIntroduced: 2006, introPrice: 23.99),
    Product(title: "Sunflower", yearIntroduced: 2008, introPrice: 25.00),
    Product(title: "Gardenia", yearIntroduced: 2006, introPrice: 25.00)
  ]
  
  /// NSPredicate expression keys.
  private enum ExpressionKeys: String {
    case title
    case yearIntroduced
    case introPrice
  }
  
  /// Search controller to help us with filtering.
  private var searchController: UISearchController!
  
  /// Secondary search results table view.
  private var resultsTableController: ResultsTableController!
  
  // MARK: - View Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    let cell = tableView.dequeueReusableCell(withIdentifier: BaseTableViewController.tableViewCellIdentifier, for: indexPath)
    
    let product = products[indexPath.row]
    configureCell(cell, forProduct: product)
    
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
  
  private func findMatches(searchString: String) -> NSCompoundPredicate {
    /** Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
     Example if searchItems contains "Gladiolus 51.99 2001":
     name CONTAINS[c] "gladiolus"
     name CONTAINS[c] "gladiolus", yearIntroduced ==[c] 2001, introPrice ==[c] 51.99
     name CONTAINS[c] "ginger", yearIntroduced ==[c] 2007, introPrice ==[c] 49.98
     */
    var searchItemsPredicate = [NSPredicate]()
    
    /** Below we use NSExpression represent expressions in our predicates.
     NSPredicate is made up of smaller, atomic parts:
     two NSExpressions (a left-hand value and a right-hand value).
     */
    
    // Name field matching.
    let titleExpression = NSExpression(forKeyPath: ExpressionKeys.title.rawValue)
    let searchStringExpression = NSExpression(forConstantValue: searchString)
    let titleSearchComparisonPredicate = NSComparisonPredicate(
      leftExpression: titleExpression,
      rightExpression: searchStringExpression,
      modifier: .direct,
      type: .contains,
      options: [.caseInsensitive, .diacriticInsensitive])
    searchItemsPredicate.append(titleSearchComparisonPredicate)
    
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .none
    numberFormatter.formatterBehavior = .default
    
    // The `searchString` may fail to convert to a number.
    if let targetNumber = numberFormatter.number(from: searchString) {
      // Use `targetNumberExpression` in both the following predicates.
      let targetNumberExpression = NSExpression(forConstantValue: targetNumber)
      
      // The `yearIntroduced` field matching.
      let yearIntroducedExpression = NSExpression(forKeyPath: ExpressionKeys.yearIntroduced.rawValue)
      let yearIntroducedPredicate = NSComparisonPredicate(
        leftExpression: yearIntroducedExpression,
        rightExpression: targetNumberExpression,
        modifier: .direct,
        type: .equalTo,
        options: [.caseInsensitive, .diacriticInsensitive])
      searchItemsPredicate.append(yearIntroducedPredicate)
      
      // The `price` field matching.
      let introPriceExpression = NSExpression(forKeyPath: ExpressionKeys.introPrice.rawValue)
      let finalPredicate = NSComparisonPredicate(
        leftExpression: introPriceExpression,
        rightExpression: targetNumberExpression,
        modifier: .direct,
        type: .equalTo,
        options: [.caseInsensitive, .diacriticInsensitive])
      searchItemsPredicate.append(finalPredicate)
    }
    
    let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: searchItemsPredicate)
    return orMatchPredicate
  }
  
  func updateSearchResults(for searchController: UISearchController) {
    // Update the filtered array based on the search text.
    let searchResults = products
    
    // Strip out all the leading and trailing spaces.
    let strippedString = searchController.searchBar.text!.trimmingCharacters(in: CharacterSet.whitespaces)
    let searchItems = strippedString.components(separatedBy: " ") as [String]
    
    // Build all the "AND" expressions for each value in searchString.
    let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
      findMatches(searchString: searchString)
    }
    
    // Match up the fields of the Product object.
    let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
    let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }
    
    // Apply the filtered results to the search results table.
    if let resultsController = searchController.searchResultsController as? ResultsTableController {
      resultsController.filteredProducts = filteredResults
      resultsController.tableView.reloadData()
    }
  }
  
}
