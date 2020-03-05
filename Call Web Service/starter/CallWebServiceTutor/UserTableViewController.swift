//
//  UserTableViewController.swift
//  CallWebService
//
//  Created by Quang Tran on 1/23/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class UserTableViewController: UITableViewController {
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        handleGetUsers()
    }
    
    func handleGetUsers() {
        getUsers { (data, error) in
            guard let data = data else {
                print(error ?? "No returned error")
                return
            }
            
            self.users.removeAll()
            for userData in data {
                let userDict = userData as! Dictionary<String, Any>
                let name = userDict["name"] as! String
                let id = userDict["id"] as! Double
                let user = User(id: id, name: name)
                self.users.append(user)
            }
            self.tableView.reloadData()
        }
    }
    
    func getUsers(fetched: @escaping (_ data: [Any]?, _ error: Error?) -> Void) {
        fetched(nil, nil)
    }
    
    func deleteUserWithID(id: Double, deleted: @escaping (_ data: [String: Any]?, _ error: Error?) -> Void) {
        deleted(nil, nil)
    }
    
    // MARK: - Table view data source
    
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
        if (editingStyle == .delete) {
            let userID = users[indexPath.row].id
            deleteUserWithID(id: userID) { (userID, error) in
                guard userID != nil else {
                    print(error ?? "No returned error")
                    return
                }
                
                // Get new user list
                self.handleGetUsers()
            }
        }
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch segue.identifier ?? "" {
        case "AddUser":
            break
        case "UpdateUser":
            guard let userViewController = segue.destination as? UserViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedUserCell = sender as? UITableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedUserCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedUser = users[indexPath.row]
            userViewController.user = selectedUser
            break
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}
