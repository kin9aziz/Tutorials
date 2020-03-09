/*
 Abstract:
 The table view controller responsible for displaying the filtered products as the user types in the search field.
 */

import UIKit

class ResultsTableController: UITableViewController {
  
  var filteredProducts = [Product]()
  
  let tableViewCellIdentifier = "cellID"
  let tableViewCellName = "TableCell"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let nib = UINib(nibName: tableViewCellName, bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: tableViewCellIdentifier)
  }
  
  
  // MARK: - UITableViewDataSource
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredProducts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)
    let product = filteredProducts[indexPath.row]
    cell.textLabel?.text = product.title
    
    return cell
  }
  
}
