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
    
    tableView.prefetchDataSource = self
  }
  
  //  MARK: - Populate
  private func createUsersCounterIfNeeded(completed: @escaping (_ error: Error?)->Void) {
    let usersCounter = Firestore.firestore().collection("counters").document("users")
    usersCounter.getDocument { (doc, error) in
      guard let doc = doc else {
        completed(error)
        return
      }
      
      if doc.exists {
        completed(nil)
      }
      else {
        // Create users counter document with attribute count equal zero
        usersCounter.setData(["count": 0]) { (error) in
          if let error = error {
            completed(error)
          }
          else {
            completed(nil)
          }
        }
      }
    }
  }
  
  // Create users and update users counter
  private func populate(addedCount: Int) {
    let db = Firestore.firestore()
    db.runTransaction({ (transaction, errorPointer) -> Any? in
      // Update user counter to added users amount
      let usersCounterRef = db.collection("counters").document("users")
      let usersCounterDoc: DocumentSnapshot
      
      do {
        try usersCounterDoc = transaction.getDocument(usersCounterRef)
      }
      catch let fetchError as NSError {
        errorPointer?.pointee = fetchError
        return nil
      }
      
      guard let oldCount = usersCounterDoc.data()?["count"] as? Int else {
        let error = NSError(
          domain: "AppErrorDomain",
          code: -1,
          userInfo: [
            NSLocalizedDescriptionKey: "Unable to retrieve population from snapshot \(usersCounterDoc)"
          ]
        )
        errorPointer?.pointee = error
        return nil
      }
      
      // Note: this could be done without a transaction
      // by updating the population using FieldValue.increment()
      transaction.updateData(["count": oldCount + addedCount], forDocument: usersCounterRef)
      
      // Create users
      for _ in 0..<addedCount {
        let userRef = db.collection("users").document()
        transaction.setData(User.fake().dictionary, forDocument: userRef)
      }

      return nil
    })
    { (object, error) in
      if let error = error {
        print("Transaction failed: \(error)")
      } else {
        print("Transaction successfully committed!")
      }
    }
  }
  
  @IBAction func populate() {
    createUsersCounterIfNeeded { (error) in
      if let error = error {
        print("Error when creating users counter: \(error)")
      }
      else {
        self.populate(addedCount: self.addedCount)
      }
    }
  }
  
  //  MARK: - Fetch
  @IBAction func fetch() {
    guard !isFetchInProgress else {
      return
    }
    
    isFetchInProgress = true
  
    fetchTotalCountIfNeeded { (totalCount, err) in
      guard err == nil else {
        print("Error when get total count: \(err!)")
        return
      }
      
      self.totalCount = totalCount!
      print("total count: \(self.totalCount)")
      
      self.fetchUsers(completed: { (snapshot, err) in
        guard err == nil else {
          print("Error when get users: \(err!)")
          return
        }
        
        guard let snapshot = snapshot else {
          print("User docs is null")
          return
        }
        
        guard snapshot.documents.count > 0 else {
          print("User docs is empty")
          return
        }
        
        let newUsers = snapshot.documents.map({ User(dictionary: $0.data())! })
        
        print("Fetched \(newUsers.count) users")
        print(newUsers.map({ String(describing: $0) }).joined(separator: "\n"))
        
        self.lastCurrentPageDoc = snapshot.documents.last
        
        if self.users.count == 0 {
          self.users.append(contentsOf: newUsers)
          self.tableView.reloadData()
        }
        else {
          self.users.append(contentsOf: newUsers)
          let range = (self.users.count - newUsers.count)..<self.users.count
          let newIndexPathsToReload = range.map{ IndexPath(row: $0, section: 0) }
          let indexPathsToReload = self.visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
          if indexPathsToReload.count > 0 {
            self.tableView.reloadRows(at: indexPathsToReload, with: .fade)
          }
        }
        
        self.isFetchInProgress = false
      })
    }
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
  
  func fetchTotalCountIfNeeded(completed: @escaping (Int?, Error?)->Void) {
    guard totalCount == 0 else {
      completed(totalCount, nil)
      return
    }
    
    let usersCountRef = Firestore.firestore().collection("counters").document("users")
    usersCountRef.getDocument { (doc, error) in
      if let error = error {
        completed(nil, error)
      }
      else {
        let totalCount = doc!.data()!["count"] as! Int
        completed(totalCount, nil)
      }
    }
  }
  
  private func fetchUsers(completed: @escaping (QuerySnapshot?, Error?)->Void) {
    let usersDB = Firestore.firestore().collection("users")
    var query: Query
    
    if self.users.count == 0 {
      query = usersDB
        .order(by: "firstName")
        .limit(to: countPerPage)
    }
    else {
      query = usersDB
        .order(by: "firstName")
        .limit(to: countPerPage)
        .start(afterDocument: lastCurrentPageDoc!)
    }
    
    query.getDocuments { (snapshot, err) in
      if let err = err {
        completed(nil, err)
      }
      else {
        completed(snapshot, nil)
      }
    }
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

// MARK: - Table View Data Source Prefetching
extension UsersTableViewController: UITableViewDataSourcePrefetching {
  func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
    print("prefetch rows at index paths: \(indexPaths)")
    if indexPaths.contains(where: isLoadingCell) {
      fetch()
    }
  }
}

