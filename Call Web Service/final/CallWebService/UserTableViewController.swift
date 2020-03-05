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
                print("Can not get users list")
                print(error!)
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
        // Set up the URL request
        let endpoint = K.Server.Host + K.Server.ListUsersPath
        let urlRequest = URLRequest(url: URL(string: endpoint)!)
        
        // make the request
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("error calling GET on \(K.Server.ListUsersPath)")
                print(error!)
                
                DispatchQueue.main.async {
                    fetched(nil, error)
                }
                
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let users = try JSONSerialization.jsonObject(with: responseData, options: []) as? [Any] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                // let's just print it to prove we can access it
                print("The users list are: " + users.description)
                
                DispatchQueue.main.async {
                    fetched(users, nil)
                }
            }
            catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    func deleteUserWithID(id: Double, deleted: @escaping (_ data: [String: Any]?, _ error: Error?) -> Void) {
        let endpoint: String = String(format: K.Server.Host + K.Server.deleteUserPath, id)
        var urlRequest = URLRequest(url: URL(string: endpoint)!)
        urlRequest.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling DELETE on \(K.Server.deleteUserPath)")
                print(error!)
                
                DispatchQueue.main.async {
                    deleted(nil, error)
                }
                
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let deletedUser = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                
                print("The deleted user ID is: " + deletedUser.description)
                
                DispatchQueue.main.async {
                    deleted(deletedUser, nil)
                }
            }
            catch  {
                print("error parsing response from DELETE on \(K.Server.deleteUserPath)")
                return
            }
        }
        task.resume()
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
