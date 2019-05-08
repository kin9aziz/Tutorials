//
//  ViewController.swift
//  UsersInfiniteScrolling
//
//  Created by Quang Tran on 5/6/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import Firebase
import Fakery

class UsersTableViewController: UITableViewController {
  
  private var users: [User] = []
  private var lastCurrentPageDoc: DocumentSnapshot?
  private let addedCount = 200
  private let countPerPage = 10
  private var totalCount = 0
  private var isFetchInProgress = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= users.count
  }
}

// MARK: - Table View Data Source
extension UsersTableViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.totalCount
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserTableViewCell
    
    if isLoadingCell(for: indexPath) {
      cell.user = nil
    }
    else {
      cell.user = self.users[indexPath.row]
    }
    
    return cell
  }
}
