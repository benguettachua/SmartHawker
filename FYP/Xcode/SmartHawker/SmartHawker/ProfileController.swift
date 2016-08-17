//
//  ProfileController.swift
//  SmartHawker
//
//  Created by Ben Chua Weilun on 17/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import Foundation

class ProfileController{
    
    var imageFile: PFFile!
    let user = PFUser.currentUser()
    
    func logout() {
        connectionDAO().logout()
    }
    
    func checkEmail(email: String) -> Bool{
        return connectionDAO().checkEmail(email)
    }
    
    func saveChanges(newName: String, newPhoneNumber: String, newEmail: String, newPINNumber: String, newBusinessAddress:String, newBusinessName: String, newBusinessRegNo: String, imageFile: PFFile){
        self.user!["name"] = newName
        self.user!["phoneNumber"] = newPhoneNumber
        self.user!["email"] = newEmail
        self.user!["adminPin"] = newPINNumber
        self.user!["businessAddress"] = newBusinessAddress
        self.user!["businessName"] = newBusinessName
        self.user!["businessNumber"] = newBusinessRegNo
        self.user!["profilePicture"] = imageFile
        self.user?.saveInBackground()
        
    }
}