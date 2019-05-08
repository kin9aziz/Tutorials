//
//  User.swift
//  UsersInfiniteScrolling
//
//  Created by Quang Tran on 5/6/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit
import Fakery

struct User {
  var firstName: String
  var lastName: String
  var company: String
  var email: String
  var avatarBackgroundColor: String
  
  var dictionary: [String: Any] {
    return [
      "firstName": firstName,
      "lastName": lastName,
      "company": company,
      "email": email,
      "avatarBackgroundColor": avatarBackgroundColor
    ]
  }
  
  static func fake() -> User {
    let faker = Faker()
    return User(
      firstName: faker.name.firstName(),
      lastName: faker.name.lastName(),
      company: faker.company.name(),
      email: faker.internet.safeEmail(),
      avatarBackgroundColor: UIColor.randomHexCode())
  }
}

protocol DocumentSerializable {
  init?(dictionary: [String: Any])
}

extension User: DocumentSerializable {
  init?(dictionary: [String : Any]) {
    guard let firstName = dictionary["firstName"] as? String,
    let lastName = dictionary["lastName"] as? String,
    let company = dictionary["company"] as? String,
    let email = dictionary["email"] as? String,
    let avatarBackgroundColor = dictionary["avatarBackgroundColor"] as? String else {
      return nil
    }
    
    self.init(
      firstName: firstName,
      lastName: lastName,
      company: company,
      email: email,
      avatarBackgroundColor: avatarBackgroundColor
    )
  }
}

extension User: CustomStringConvertible {
  var description: String {
    return "firstName: \(firstName)"
    + "\nlastName: \(lastName)"
    + "\ncompany: \(company)"
    + "\nemail: \(email)"
    + "\navatarBackgroundColor: \(avatarBackgroundColor)"
  }
}
