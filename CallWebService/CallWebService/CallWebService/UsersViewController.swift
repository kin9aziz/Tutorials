//
//  UserTableViewController.swift
//  CallWebService
//
//  Created by Quang Tran on 1/23/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class UsersViewController: UITableViewController {
  
  var users = [User]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    WebServiceHelper.getUsers { (users, error) in
      guard error == nil else { return }
      self.users = users!
      self.tableView.reloadData()
    }
  }
  
  
  
  @IBAction func addButtonDidTap(_ sender: UIBarButtonItem) {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddUpdateUserViewController")
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true, completion: nil)
  }
  
}

// MARK: - UITableViewDataSource
extension UsersViewController {
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath)
    let user = users[indexPath.row]
    cell.textLabel?.text = "ID: " + String(format: "%.0f", user.id)
    cell.detailTextLabel?.text = user.name
    return cell
  }
  
  override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    guard editingStyle == .delete else { return }
    
    let userID = users[indexPath.row].id
    WebServiceHelper.deleteUser(id: userID) { error in
      guard error == nil else { return }
      self.users.remove(at: indexPath.row)
      self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
  }
  
}

// MARK: UITableViewDelegate
extension UsersViewController {
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddUpdateUserViewController") as! AddUpdateUserViewController
    vc.user = users[indexPath.row]
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: true, completion: nil)
  }
  
}
