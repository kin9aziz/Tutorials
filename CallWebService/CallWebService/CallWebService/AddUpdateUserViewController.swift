//
//  NewUserViewController.swift
//  CallWebService
//
//  Created by Quang Tran on 1/23/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class AddUpdateUserViewController: UIViewController {
  
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
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func save(_ sender: UIBarButtonItem) {
    if let user = user {
      WebServiceHelper.updateUser(id: user.id, name: nameTextField.text!) { (userID, error) in
        self.dismiss(animated: true, completion: nil)
      }
    }
    else {
      WebServiceHelper.addUser(name: nameTextField.text!) { (userID, error) in
        self.dismiss(animated: true, completion: nil)
      }
    }
  }
  
  //MARK: Private Methods
  
  private func updateSaveButtonState() {
    // Disable the Save button if the text field is empty.
    let text = nameTextField.text ?? ""
    saveButton.isEnabled = !text.isEmpty
  }

}

//MARK: UITextFieldDelegate
extension AddUpdateUserViewController: UITextFieldDelegate {
  
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
  
}
