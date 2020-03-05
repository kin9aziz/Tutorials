//
//  WebServiceHelper.swift
//  CallWebService
//
//  Created by Quang Tran on 3/5/20.
//  Copyright © 2020 Quang Tran. All rights reserved.
//

import UIKit

class WebServiceHelper: NSObject {

  static let host = "http://127.0.0.1:8081/"
  static let addUserPath = "addUser"
  static let updateUserPath = "updateUser"
  static let listUsersPath = "listUsers"
  static let deleteUserPath = "deleteUser/%.0f"
  
  static func getUsers(completionHandler: @escaping (_ users: [User]?, _ error: Error?) -> Void) {
    let endpointUrl = URL(string: host + listUsersPath)!
    let urlRequest = URLRequest(url: endpointUrl)
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      guard error == nil else {
        print("error calling GET on \(listUsersPath): \(error!)")
        DispatchQueue.main.async {
          completionHandler(nil, error)
        }
        return
      }
      
      let usersData = try! JSONSerialization.jsonObject(with: data!, options: []) as! [Any]
      var users = [User]()
      for userData in usersData {
        let userDict = userData as! Dictionary<String, Any>
        let name = userDict["name"] as! String
        let id = userDict["id"] as! Double
        let user = User(id: id, name: name)
        users.append(user)
      }
      DispatchQueue.main.async {
        completionHandler(users, nil)
      }
    }
    task.resume()
  }
 
  static func deleteUser(id: Double, comletionHandler: @escaping (_ error: Error?) -> Void) {
    let endpointUrl = URL(string: String(format: host + deleteUserPath, id))!
    var urlRequest = URLRequest(url: endpointUrl)
    urlRequest.httpMethod = "DELETE"
    
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      guard error == nil else {
        print("error calling DELETE on \(deleteUserPath): \(error!)")
        DispatchQueue.main.async {
          comletionHandler(error)
        }
        return
      }
      
      DispatchQueue.main.async {
        comletionHandler(nil)
      }
    }
    task.resume()
  }

  static func addUser(name: String, completionHandler: @escaping (_ userID: Double?, _ error: Error?) -> Void) {
    let endpointUrl = URL(string: host + addUserPath)!
    var urlRequest = URLRequest(url: endpointUrl)
    urlRequest.httpMethod = "POST"
    
    let newUser: [String: Any] = ["name": name]
    let jsonUser = try! JSONSerialization.data(withJSONObject: newUser, options: [])
    urlRequest.httpBody = jsonUser
    
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      guard error == nil else {
        print("error calling POST on \(addUserPath): \(error!)")
        DispatchQueue.main.async {
          completionHandler(nil, error)
        }
        return
      }
      
      let userData = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Double]
      let userID = userData["id"]
      DispatchQueue.main.async {
        completionHandler(userID, nil)
      }
    }
    task.resume()
  }
  
  static func updateUser(id: Double, name: String, completionHandler: @escaping (_ userID: Double?, _ error: Error?) -> Void) {
    let endpointUrl = URL(string: host + updateUserPath)!
    var urlRequest = URLRequest(url:  endpointUrl)
    urlRequest.httpMethod = "PUT"
    
    let userDict: [String: Any] = ["id": id, "name": name]
    let userData = try! JSONSerialization.data(withJSONObject: userDict, options: [])
    urlRequest.httpBody = userData
    
    let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
      guard error == nil else {
        print("error calling PUT on \(updateUserPath): \(error!)")
        DispatchQueue.main.async {
          completionHandler(nil, error)
        }
        return
      }
      
      let userData = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Double]
      let userID = userData["id"]
      DispatchQueue.main.async {
        completionHandler(userID, nil)
      }
    }
    task.resume()
  }
}
