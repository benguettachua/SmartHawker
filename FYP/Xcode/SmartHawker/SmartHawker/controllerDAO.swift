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
    func loadRecordsIntoLocalDatastore() -> [PFObject]{
        // Part 1: Load from DB and pin into local datastore.
        let query = PFQuery(className: "Record")
        var records = [PFObject]()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        do{
            records = try query.findObjects()
            
        } catch {
            
        }
        return records
    }
    
    // Find subuser from local datastore with a specific pin
    func getSubuserFromLocalDatastore(pin: String) -> PFObject{
        let query = PFQuery(className: "SubUser")
        var subuser = PFObject()
        query.whereKey("pin", equalTo: pin)
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.fromLocalDatastore()
        do {
            subuser = try query.getFirstObject()
        } catch {
            
        }
        return subuser
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
    
    // Sends an email to reset password.
    func forgetPassword(email: String) -> Bool {
        do{
            try PFUser.requestPasswordResetForEmail(email)
            return true
        }catch{
            return false
        }
    }
    
    
}
