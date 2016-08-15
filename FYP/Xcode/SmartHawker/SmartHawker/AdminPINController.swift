//
//  AdminPINController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 15/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

class AdminPINController {
    
    // Import DAO to connect to database.
    let dao = connectionDAO()
    
    // Shared Data
    let shared = ShareData.sharedInstance
    
    // Sync records to ensure local datastore and database are the same.
    func sync() -> Bool {
        
        // Sync part 1: Save records from local datastore into database.
        let saveSucceed = dao.saveRecordsIntoDatabase()
        if (saveSucceed == false) {
            return false
        }
        // Sync part 2: Retrieve all records from database and pin into local datastore
        let loadSucceed = dao.loadRecordsIntoLocalDatastore()
        if (loadSucceed == false) {
            return false
        }
        return true
    }
    
    // Verifies the PIN entered by the user. Returns 0 if admin PIN, 1 if subuser PIN, 2 if invalid PIN.
    func submitPIN(pinEntered: String, adminPIN: String) -> Int {
        
        // Pin entered == Admin's PIN
        if (pinEntered == adminPIN) {
            shared.isSubUser = false
            return 0
        }
        
        // Check if pin entered belongs to any of subuser's PIN
        else {
            let subuser = dao.getSubuserFromLocalDatastore(pinEntered)
            if (subuser != nil) {
                shared.isSubUser = true
                shared.subuser = subuser!["name"] as! String
                return 1
            }
        }
        
        // Invalid PIN
        return 2
    }
    
    func loadDatesToCalendar(){
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: PFUser.currentUser()!)
        do{
            let array = try query.findObjects()
            var arrayForAllDates = [String]()
            var dates = [String:[String]]()
            // subuser is found, proceed to delete.
            for object in array {
                let dateString = object["date"] as! String
                let subuserName = object["subuser"] as! String
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
            
            if shared.isSubUser == true{
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(dates[shared.subuser], forKey: "SavedDateArray")
            }else{
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(arrayForAllDates, forKey: "SavedDateArray")
            }
        } catch {
        }
        
        
    }
}