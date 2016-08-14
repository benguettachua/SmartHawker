//
//  ReigstrationController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 14/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class RegistrationController {
    
    // Import DAO to connect to database.
    let dao = connectionDAO()
    
    // Register a new account with infomration in parameter, return true if success, else false.
    func register (name: String, username: String, email: String, phone: String, password: String, adminPIN: String) -> Bool {
        if (name == "" || username == "" || email == "" || phone == "" || password == "" || adminPIN == "") {
            return false
        }
        return dao.register(username, password: password, name: name, email: email, phoneNumber: phone, adminPIN: adminPIN)
    }
}
