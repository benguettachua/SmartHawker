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
    func record (description: String, amount: Double?, isSubuser: Bool, subuser: String?, type: Int) -> Bool {
        
        // Make description and subuser mutable.
        var description = description
        var subuser = subuser
        
        // If user did not input any description, save the record as "No description"
        if (description == "") {
            description = "No description"
        }
        
        // Records must have positive value
        if (amount == nil || amount <= 0) {
            return false
        }
        
        // Sets the owner of this record to subuser
        if (isSubuser == false) {
            subuser = (PFUser.currentUser()?.username)!
        }
        
        return dao.addRecord(shared.dateString, amount: amount!, type: type, subuser: subuser!, description: description)
    }
}
