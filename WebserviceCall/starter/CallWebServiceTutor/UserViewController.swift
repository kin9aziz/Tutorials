//
//  NewUserViewController.swift
//  CallWebService
//
//  Created by Quang Tran on 1/23/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the keyboard
        nameTextField.becomeFirstResponder()
        nameTextField.delegate = self
        
        if let user = user {
            navigationItem.title = user.name
            nameTextField.text = user.name
        }
        
        // Enable the Save button only if the text field has a valid User name.
        updateSaveButtonState()
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddUserMode = presentingViewController is UINavigationController
        
        if isPresentingInAddUserMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let user = user {
            updateUserWithID(id: user.id, name: nameTextField.text!) { (userID, error) in
                guard userID != nil else {
                    print(error ?? "No returned error")
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
        else {
            addUserWithName(name: nameTextField.text!) { (userID, error) in
                guard userID != nil else {
                    print(error ?? "No returned error")
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    private func addUserWithName(name: String, added: @escaping (_ data: [String: Any]?, _ error: Error?) -> Void) {
        added(nil, nil)
    }
    
    private func updateUserWithID(id: Double, name: String, updated: @escaping (_ data: [String: Any]?, _ error: Error?) -> Void) {
        let endpoint: String = K.Server.Host + K.Server.UpdateUserPath
        var urlRequest = URLRequest(url: URL(string: endpoint)!)
        urlRequest.httpMethod = "PUT"
        
        let userDict: [String: Any] = ["id": id, "name": name]
        let userData: Data
        do {
            userData = try JSONSerialization.data(withJSONObject: userDict, options: [])
            urlRequest.httpBody = userData
        } catch {
            print("Error: cannot create JSON from new user")
            return
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil else {
                print("error calling PUT on \(K.Server.UpdateUserPath)")
                print(error!)
                
                DispatchQueue.main.async {
                    updated(nil, error)
                }
                
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let userID = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    return
                }
                print("The updated user ID is: " + userID.description)
                
                DispatchQueue.main.async {
                    updated(userID, nil)
                }
            } catch  {
                print("error parsing response from POST on /addUser")
                return
            }
        }
        task.resume()
    }
}
