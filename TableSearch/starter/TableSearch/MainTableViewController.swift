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
