//
//  RecordExpensesController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 16/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

class RecordController {
    
    // Import dao to access database.
    let dao = connectionDAO()
    let shared = ShareData.sharedInstance
    
    // This function records the submitted record.
    func record (description: String, amount: Double?, isSubuser: Bool, subuser: String?, type: Int, receipt: PFFile!) -> Bool {
        
        // Make subuser mutable.
        var subuser = subuser
        
        // Records must have positive value
        if (amount == nil || amount <= 0) {
            return false
        }
        
        // Sets the owner of this record to subuser
        if (isSubuser == false) {
            subuser = (PFUser.currentUser()?.username)!
        }

        return dao.addRecord(shared.dateString, amount: amount!, type: type, subuser: subuser!, description: description, receipt: receipt)
    }
    
    // This function updates the selected record, based on localIdentifier.
    func update(localIdentifier: String, type: Int, description: String, amount: Double?) -> Bool {
        
        // Records must have positive value
        if (amount == nil || amount <= 0) {
            return false
        }
        
        return dao.updateRecord(localIdentifier, type: type, amount: amount!, description: description)
    }
    
    // This function deletes the selected record.
    func deleteRecord(record: PFObject) -> Bool {
        
        let localIdentifier = record["subUser"] as! String
        let deletesuccess = dao.deleteRecord(localIdentifier)
        
        if(deletesuccess) {
            return true
        }
        return false
    }
    
    // This function loads dates with record into calendar, so that calendar will show.
    func loadDatesToCalendar(){
        let isSubuser = shared.isSubUser
        let subuser = shared.subuser
        dao.loadDatesIntoCalendar(isSubuser, subuser: subuser)
    }
    
    // Load all records
    func loadRecords() -> [PFObject] {
        return dao.loadRecords()
    }
}
