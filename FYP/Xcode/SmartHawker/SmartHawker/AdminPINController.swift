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
        dao.loadDatesIntoCalendar(shared.isSubUser, subuser: shared.subuser)
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
    
    // This function loads dates with record into calendar, so that calendar will show.
    func loadDatesToCalendar(){
        let isSubuser = shared.isSubUser
        let subuser = shared.subuser
        dao.loadDatesIntoCalendar(isSubuser, subuser: subuser)
    }
}