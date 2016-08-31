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
    
    // Shared Data
    let shared = ShareData.sharedInstance
    
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
    
    // Sync records to ensure local datastore and database are the same.
    func sync() -> Bool {
        
        // Sync part 1: Save records from local datastore into database.
        let saveSucceed = connectionDAO().saveRecordsIntoDatabase()
        if (saveSucceed == false) {
            return false
        }
        // Sync part 2: Retrieve all records from database and pin into local datastore
        let loadSucceed = connectionDAO().loadRecordsIntoLocalDatastore()
        if (loadSucceed == false) {
            return false
        }
        connectionDAO().loadDatesIntoCalendar(shared.isSubUser, subuser: shared.subuser)
        
        return true
    }
}