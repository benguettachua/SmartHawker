//
//  User.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 19/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class User {
    
    // MARK: Properties
    var businessName: String
    var businessRegNo: String
    var businessAddress: String
    var username: String
    var email: String
    var phoneNumber: String
    var password: String
    var confirmPassword: String
    var adminPIN: String
    var isIOS: Bool
    var profilePicture: UIImage?
    
    // Initialization 
    init?(businessName: String, businessRegNo: String, businessAddress: String, username: String, email: String, phoneNumber: String, password: String, confirmPassword: String, adminPIN: String, isIOS: Bool, profilePicture: UIImage?) {
        
        // Initialize stored properties.
        self.businessName = businessName
        self.businessRegNo = businessRegNo
        self.businessAddress = businessAddress
        self.username = username
        self.email = email
        self.phoneNumber = phoneNumber
        self.password = password
        self.confirmPassword = confirmPassword
        self.adminPIN = adminPIN
        self.isIOS = true
        self.profilePicture = profilePicture
        
        // Incorrect registration errors
        if (password != confirmPassword) {
            return nil
        }
    }
    
}
