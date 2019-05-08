//
//  Utils.swift
//  UsersInfiniteScrolling
//
//  Created by Quang Tran on 5/8/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import UIKit

extension UIColor {
  static func randomHexCode() -> String {
    var chars = Array("0123456789abcdef")
    var hex = ""
    for _ in 1...6 {
      hex.append(chars[Int(arc4random()) % chars.count])
    }
    return hex
  }
}
