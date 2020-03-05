//
//  Constant.swift
//  CallWebService
//
//  Created by Quang Tran on 1/24/19.
//  Copyright © 2019 Quang Tran. All rights reserved.
//

import Foundation

struct K {
    struct Server {
        static let Host = "http://127.0.0.1:8081/"
        static let AddUserPath = "addUser"
        static let UpdateUserPath = "updateUser"
        static let ListUsersPath = "listUsers"
        static let deleteUserPath = "deleteUser/%.0f"
    }
}
