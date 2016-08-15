//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class connectionDAO{
    
    //load records into controller
    func loadRecords() -> [PFObject]{
        let query = PFQuery(className: "Record")
        var records = [PFObject]()
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        do{
            records = try query.findObjects()
        } catch {
            
        }
        return records
    }
    
    //load records into local datastore
    func loadRecordsIntoLocalDatastore() -> Bool{
        // Part 1: Load from DB and pin into local datastore.
        let query = PFQuery(className: "Record")
        var records = [PFObject]()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        do{
            records = try query.findObjects()
            try PFObject.pinAll(records)
            return true
        } catch {
            return false
        }
    }
    
    // Find subuser from local datastore with a specific pin
    func getSubuserFromLocalDatastore(pin: String) -> PFObject?{
        let query = PFQuery(className: "SubUser")
        var subuser: PFObject?
        query.whereKey("pin", equalTo: pin)
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.fromLocalDatastore()
        do {
            subuser = try query.getFirstObject()
        } catch {
            subuser = nil
        }
        return subuser!
    }
    
    // Find all subuser and load into local datastore
    func getSubuserFromDatabase(){
        let query = PFQuery(className: "SubUser")
        var subusers = [PFObject]()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        do {
            subusers = try query.findObjects()
            try PFObject.pinAll(subusers)
        } catch {
            
        }
    }
    
    // Saves Records into Database
    func saveRecordsIntoDatabase() -> Bool{
        let query = PFQuery(className: "Record")
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        var objects = [PFObject]()
        do{
            objects = try query.findObjects()
            for object in objects {
                try object.pin()
                try object.save()
            }
            return true
        } catch {
            return false
        }
    }
    
    // Log in using username and password input, return true if login successful.
    func login(username: String, password: String) -> Bool {
        do {
            try PFUser.logInWithUsername(username, password: password)
            return true
        } catch {
            return false
        }
    }
    
    // Log out the current user
    func logout() {
        PFUser.logOut()
    }
    
    // Sends an email to reset password.
    func forgetPassword(email: String) -> Bool {
        do{
            try PFUser.requestPasswordResetForEmail(email)
            return true
        }catch{
            return false
        }
    }
    
    // Register a new acount
    func register(username:String, password: String, name: String, email: String, phoneNumber: String, adminPIN: String) -> Int{
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        newUser.email = email
        newUser["name"] = name
        newUser["phoneNumber"] = phoneNumber
        newUser["adminPin"] = adminPIN
        do {
            try newUser.signUp()
            return 0
        } catch {
            let errorCode = error as NSError!
            // 202 = username taken
            // 203 = email taken
            return errorCode.code
        }
    }
    
    // Edit user's information
    func edit(name: String, email: String, phoneNumber: String, adminPIN: String, businessAddress: String, businessName: String, businessNumber: String, profilePicture: PFFile) -> Bool {
        let user = PFUser.currentUser()
        user!["name"] = name
        user!["phoneNumber"] = phoneNumber
        user!["email"] = email
        user!["adminPin"] = adminPIN
        user!["businessAddress"] = businessAddress
        user!["businessName"] = businessName
        user!["businessNumber"] = businessNumber
        user!["profilePicture"] = profilePicture
        do {
            try user!.save()
            return true
        } catch {
            return false
        }
    }
    
    // Save record to local datastore
    func addRecord(date: String, amount: Double, type: Int, subuser: String, description: String) -> Bool {
        let toRecord = PFObject(className: "Record")
        toRecord.ACL = PFACL(user: PFUser.currentUser()!)
        toRecord["user"] = PFUser.currentUser()
        toRecord["date"] = date
        toRecord["amount"] = amount
        toRecord["type"] = type
        toRecord["subuser"] = subuser
        toRecord["description"] = description
        toRecord["subUser"] = NSUUID().UUIDString
        do{
            try toRecord.pin()
            return true
        } catch {
            return false
        }
        
    }
    
    // Update record in local datastore
    func updateRecord(localIdentifier: String, type: Int, amount: Double, description: String) -> Bool {
        let query = PFQuery(className: "Record")
        var recordToUpdate = PFObject()
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("subUser", equalTo: localIdentifier)
        do{
            recordToUpdate = try query.getFirstObject()
            recordToUpdate["amount"] = amount
            recordToUpdate["type"] = type
            recordToUpdate["description"] = description
            try recordToUpdate.pin()
            return true
        } catch {
            return false
        }
    }
    
    // Delete record
    func deleteRecord(localIdentifier: String) -> Bool {
        let query = PFQuery(className: "Record")
        var recordToDelete = PFObject()
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("subUser", equalTo: localIdentifier)
        do {
            recordToDelete = try query.getFirstObject()
            try recordToDelete.unpin()
            recordToDelete.deleteEventually()
            return true
        } catch {
            return false
        }
    }
    
    // Delete subuser
    func deleteSubuser(PIN: String) -> Bool {
        let query = PFQuery(className: "SubUser")
        var subuser = PFObject()
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("pin", equalTo: PIN)
        do {
            subuser = try query.getFirstObject()
            try subuser.unpin()
            subuser.deleteEventually()
            return true
        } catch {
            return false
        }
    }
    
    // Edit subuser's PIN
    func editPIN(currentPIN: String, newPIN: String) -> Bool{
        let query = PFQuery(className: "SubUser")
        var subuser = PFObject()
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("pin", equalTo: currentPIN)
        do {
            subuser = try query.getFirstObject()
            subuser["pin"] = newPIN
            try subuser.pin()
            subuser.saveEventually()
            return true
        } catch {
            return false
        }
    }
}
