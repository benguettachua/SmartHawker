//
//  LoginView.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 13/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class LoginController {
    
    // Import DAO to connect to database.
    let dao = connectionDAO()
    
    // Log in using username and password
    func login(username: String, password: String) -> Bool{
        return dao.login(username, password: password)
    }
    
    // Sends email to reset password
    func forgetPassword(email: String) -> Bool {
        return dao.forgetPassword(email)
    }
}
