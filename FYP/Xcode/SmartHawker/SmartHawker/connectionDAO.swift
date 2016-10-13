//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import Foundation


class connectionDAO{
    
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.
    
    let default1 = NSUserDefaults.standardUserDefaults()
    
    //load records into controller
    func loadRecords() -> [PFObject]{
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.fromLocalDatastore()
        query.limit = 1000
        var records = [PFObject]()
        var counter = 0
        while (records.count >= counter * 1000) {
            query.skip = 1000 * counter
            do{
                let thousandRecords = try query.findObjects()
                records += thousandRecords
            } catch {
                
            }
            counter += 1
        }
        
        return records
    }
    
    // Load dates with records into Calendar
    func loadDatesIntoCalendar(isSubuser: Bool, subuser: String?) {
        let query = PFQuery(className: "Record")
        query.limit = 1000
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        var counter = 0
        var records = [PFObject]()
        while records.count >= counter * 1000 {
            query.skip = 1000 * counter
            do{
                let array = try query.findObjects()
                var arrayForAllDates = [String]()
                var dates = [String:[String]]()
                
                for object in array {
                    let dateString = object["date"] as! String
                    let subuserName = object["subuser"] as! String
                    let type = object["type"] as! Int
                    
                    if type == 0 || type == 1 || type == 2 {
                        if dates[subuserName] == nil{
                            let arrayForDates = [dateString]
                            dates.updateValue(arrayForDates, forKey: subuserName)
                        }else{
                            var arrayForDates = dates[subuserName]
                            arrayForDates?.append(dateString)
                            dates.updateValue(arrayForDates!, forKey: subuserName)
                        }
                        arrayForAllDates.append(dateString)
                    }
                }
                
                if isSubuser == true{
                    toShare.datesWithRecords = dates[subuser!]!
                }else{
                    toShare.datesWithRecords = arrayForAllDates
                }
                records += array
                counter += 1
            } catch {
                
            }
        }
    }
    
    //loads autocomplete words
    func loadStringIntoAutoFill() {
        let query = PFQuery(className: "Record")
        query.limit = 1000
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        var records = [PFObject]()
        var counter = 0
        while (records.count >= counter * 1000) {
            query.skip = 1000 * counter
            do{
                let array = try query.findObjects()
                var descriptions = [String]()
                
                for object in array {
                    if object["description"] != nil {
                        let description = object["description"] as! String
                        if description != "" {
                            descriptions.append(description)
                        }
                    }
                }
                toShare.stringsWithAutoFill = descriptions
                records += array
                counter += 1
            } catch {
                
            }
        }
    }
    
    
    //unloads all data on the calendar
    func unloadRecords(){
        // Part 1: Load from DB and pin into local datastore.
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.fromLocalDatastore()
        query.limit = 1000
        var records = [PFObject]()
        var counter = 0
        while (records.count >= counter * 1000) {
            query.skip = 1000 * counter
            do{
                let array = try query.findObjects()
                for record in records {
                    try record.unpin()
                }
                records += array
                counter += 1
            } catch {
            }
        }
        
    }
    //load records into local datastore
    func loadRecordsIntoLocalDatastore() -> Bool{
        // Part 1: Load from DB and pin into local datastore.
        let query = PFQuery(className: "Record")
        query.limit = 1000
        var records = [PFObject]()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        var counter = 0
        while (records.count >= counter * 1000) {
            query.skip = 1000 * counter
            do{
                let array = try query.findObjects()
                for record in array {
                    if (record["subUser"] == nil) {
                        record["subUser"] = NSUUID().UUIDString
                    }
                    try record.pin()
                }
                records += array
                counter += 1
            } catch {
                return false
            }
        }
        return true
    }
    
    // Saves Records into Database
    func saveRecordsIntoDatabase() -> Bool{
        let query = PFQuery(className: "Record")
        query.limit = 1000
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        var objects = [PFObject]()
        var counter = 0
        while (objects.count >= counter * 1000) {
            query.skip = 1000 * counter
            do{
                let array = try query.findObjects()
                try PFObject.pinAll(array)
                try PFObject.saveAll(array)
                objects += array
                counter += 1
            } catch {
                return false
            }
        }
        return true
    }
    
    // Loads all record from a day to an array
    func loadRecordOfTheDay(isSubuser: Bool, date: String, subuser: String?) -> [PFObject]?{
        var records: [PFObject]?
        let query = PFQuery(className: "Record")
        query.limit = 1000
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("date", equalTo: date)
        var counter = 0
        records = [PFObject]()
        while (records != nil && records!.count >= counter * 1000) {
            query.skip = counter * 1000
            do {
                let array = try query.findObjects()
                for record in array {
                    records?.append(record)
                }
                counter += 1
            } catch {
                records = nil
            }
        }
        return records
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
            try PFUser.requestPasswordResetForEmail(email )
            return true
        }catch{
            return false
        }
    }
    
    // Register a new acount
    func register(username:String, password: String, email: String, phoneNumber: String, adminPIN: String) -> Int{
        let newUser = PFUser()
        let image = UIImageJPEGRepresentation(UIImage(named: "defaultProfilePic")!, 0.0)
        let imageFile = PFFile(name: "defaultProfilePic", data: image!)
        newUser.username = username
        newUser.password = password
        newUser.email = email
        newUser["phoneNumber"] = phoneNumber
        newUser["adminPin"] = adminPIN
        newUser["profilePicture"] = imageFile
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
        return false
    }
    
    // Save record to local datastore
    func addRecord(date: String, amount: Double, type: Int, subuser: String, description: String, receipt: PFFile?) -> Bool {
        let toRecord = PFObject(className: "Record")
        toRecord.ACL = PFACL(user: PFUser.currentUser()!)
        toRecord["user"] = PFUser.currentUser()
        toRecord["date"] = date
        toRecord["amount"] = amount
        toRecord["type"] = type
        toRecord["subuser"] = subuser
        toRecord["description"] = description
        toRecord["subUser"] = NSUUID().UUIDString
        
        if (receipt != nil) {
            toRecord["receipt"] = receipt
        }
        do{
            if (receipt == nil) {
                try toRecord.pin()
            } else {
                try toRecord.pin()
                try toRecord.save()
            }
            
            if toShare.autoSync{
                saveRecordsIntoDatabase()
                return true
            }
            return true
        } catch {
            return false
        }
        
    }
    
    // Update record in local datastore
    func updateRecord(localIdentifier: String, type: Int, amount: Double, description: String, receipt: PFFile?, hasReceipt: Bool) -> Bool {
        let query = PFQuery(className: "Record")
        var recordToUpdate = PFObject(className: "Record")
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("subUser", equalTo: localIdentifier)
        do{
            recordToUpdate = try query.getFirstObject()
            recordToUpdate["amount"] = amount
            recordToUpdate["type"] = type
            recordToUpdate["description"] = description
            recordToUpdate["date"] = toShare.dateString
            if (receipt != nil) {
                recordToUpdate["receipt"] = receipt
            }
            
            if (receipt == nil) {
                if (hasReceipt == false) {
                    try recordToUpdate.pin()
                } else {
                    recordToUpdate.removeObjectForKey("receipt")
                    try recordToUpdate.pin()
                    try recordToUpdate.save()
                }
            } else {
                try recordToUpdate.pin()
                try recordToUpdate.save()
            }
            
            if toShare.autoSync{
                saveRecordsIntoDatabase()
                return true
            }
            return true
        } catch {
            return false
        }
    }
    
    // Delete record
    func deleteRecord(localIdentifier: String) -> Bool {
        let query = PFQuery(className: "Record")
        var recordToDelete = PFObject(className: "Record")
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("subUser", equalTo: localIdentifier)
        do {
            
            recordToDelete = try query.getFirstObject()
            
            //Remove it from calendar.
            var array = toShare.datesWithRecords
            for var i in 0..<array.count{
                if array[i] == recordToDelete["date"] as! String{
                    array.removeAtIndex(i)
                    i -= 1
                    break
                }
            }
            toShare.datesWithRecords = array
            
            // Set the amount to 0 to "unpin" it.
            recordToDelete["amount"] = 0
            try recordToDelete.pin()
            
            // This method may not work, a defect from Parse.
            try recordToDelete.unpin()
            
            // Delete it eventually.
            recordToDelete.deleteEventually()
            
            if toShare.autoSync{
                saveRecordsIntoDatabase()
                return true
            }
            return true
        } catch {
            return false
        }
    }
    
    // Edit subuser's PIN
    func editPIN(currentPIN: String, newPIN: String) -> Bool{
        let query = PFQuery(className: "SubUser")
        query.limit = 1000
        var subuser = PFObject(className: "SubUser")
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("pin", equalTo: currentPIN)
        do {
            subuser = try query.getFirstObject()
            subuser["pin"] = newPIN
            try subuser.pin()
            try subuser.save()
            return true
        } catch {
            return false
        }
    }
    
    func checkEmail(newEmail: String) -> Bool{
        // Part 1: Load from DB and pin into local datastore.
        
        let query = PFQuery(className: "_User")
        query.limit = 1000
        var emails = [PFObject]()
        let array = [newEmail, newEmail.lowercaseString]
        query.whereKey("email", containedIn: array)
        do{
            emails = try query.findObjects()
            if emails.count == 1{
                // false means email is taken
                return false
            }
            // true means ready to change
            return true
        } catch {
            // false means theres some connection proble,
            return false
        }
    }
    
    func isConnectedToNetwork()->Bool{
        
        let urlPath: String = "http://www.parse.com"
        var url: NSURL = NSURL(string: urlPath)!
        
        // Notice the timeoutInterval property.
        // Since this is a synchronous request you do not want it last for a long time
        var request = NSURLRequest(URL: url,
                                   cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData,
                                   timeoutInterval: 3)
        var response: NSURLResponse?
        var error: NSError?
        do{
            let urlData = try NSURLConnection.sendSynchronousRequest(request,
                                                                     returningResponse: &response)
        }catch{}
        
        if let httpResponse = response as? NSHTTPURLResponse {
            
            if(httpResponse.statusCode == 200) {
                return true
            }
        }
        
        return false
    }
    
    // get the last recorded allowable business expenses
    func getAllowableBusinessExpenses () -> PFObject?{
        
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("type", equalTo: 5)
        query.fromLocalDatastore()
        do {
            let ABE = try query.getFirstObject()
            return ABE
            
        } catch {
            let errorCode = error as NSError!
            
            // Record is not created in the DB before, create new record
            if (errorCode.code == 101) {
                let newRecord = PFObject(className: "Record")
                newRecord.ACL = PFACL(user: PFUser.currentUser()!)
                newRecord["type"] = 5
                newRecord["amount"] = 0.0
                newRecord["user"] = PFUser.currentUser()
                newRecord["subuser"] = PFUser.currentUser()?.username
                newRecord["subUser"] = NSUUID().UUIDString
                newRecord["date"] = "12/12/1212"
                newRecord["lastUpdated"] = NSDate()
                
                do{
                    try newRecord.pin()
                    return newRecord
                } catch {
                    return nil
                }
            } else {
                return nil
            }
        }
    }
    
    // Update the allowaable business expenses
    func updateAllowableBusinessExpenses(amount: Double) -> PFObject? {
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        query.whereKey("type", equalTo: 5)
        query.fromLocalDatastore()
        do {
            let ABE = try query.getFirstObject()
            ABE["amount"] = amount
            ABE["lastUpdated"] = NSDate()
            try ABE.pin()
            return ABE
        } catch {
            return nil
        }
        
    }
}
