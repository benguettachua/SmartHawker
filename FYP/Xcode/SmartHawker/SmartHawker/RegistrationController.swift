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
    func register (name: String, username: String, email: String, phone: String, password: String, confirmPassword: String, adminPIN: String) -> Int {
        
        // Name is not entered
        if (name == "") {
            return 1
        }
        
        // Username is not entered
        if (username == "") {
            return 2
        }
        
        // Email is not entered
        if (email == "") {
            return 3
        }
        
        // Phone is not entered
        if (phone == "") {
            return 4
        }
        
        // Phone is does not starts with 8 or 9
        let phoneInt = Int(phone)
        if (phoneInt < 80000000 || phoneInt > 99999999) {
            return 5
        }
        
        // Password is not entered
        if (password == "") {
            return 6
        }
        
        // Password does not match confirm password.
        if (password != confirmPassword) {
            return 7
        }
        
        // Admin PIN is not entered
        if (adminPIN == "") {
            return 8
        }
        
        // Admin PIN is not 4 digit
        if (adminPIN.characters.count != 4) {
            return 9
        }
        
        // Return 0 if regisration success, 202 if username is taken, 203 if email is taken.eA
        return dao.register(username, password: password, name: name, email: email, phoneNumber: phone, adminPIN: adminPIN)
    }
}
