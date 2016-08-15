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
    
    // Sync records to ensure local datastore and database are the same.
    func sync() -> Bool {
        
        var records = [PFObject]()
        
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
}