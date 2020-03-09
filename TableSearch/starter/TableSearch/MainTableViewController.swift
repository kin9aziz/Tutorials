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
