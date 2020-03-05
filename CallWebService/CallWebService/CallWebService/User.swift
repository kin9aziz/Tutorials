//
//  User.swift
//  CallWebService
//
//  Created by Quang Tran on 1/23/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

class User: NSObject {
  var id : Double
  var name : String
  
  init(id: Double, name: String) {
    self.id = id
    self.name = name
  }
}
