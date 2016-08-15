//
//  RecordDayController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 15/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

class RecordDayController {
    
    // Variables
    let dao = connectionDAO()
    let shared = ShareData.sharedInstance
    var records = [RecordTable]()
    
    // Loads all records made on the day and return an array of RecordTable
    func loadRecord() -> [RecordTable]{
        
        var PFRecords: [PFObject]?
        let isSubuser = shared.isSubUser
        let dateToLoad = shared.dateString
        let subuser = shared.subuser
        
        PFRecords = dao.loadRecordOfTheDay(isSubuser, date: dateToLoad, subuser: subuser)
        
        if (PFRecords != nil) {
            
            // Remove all records to prevent duplicates
            records.removeAll()
            
            // Process all records found into [RecordTable] array.
            for record in PFRecords! {
                let date = record["date"] as! String
                let type = record["type"] as! Int
                let amount = record["amount"] as! Double
                var localIdentifierString = record["subUser"]
                var recordedBy = record["subuser"]
                if (recordedBy == nil) {
                    recordedBy = ""
                }
                var typeString = ""
                if (type == 0) {
                    typeString = "Sales"
                } else if (type == 1) {
                    typeString = "COGS"
                } else if (type == 2) {
                    typeString = "Expenses"
                } else if (type == 3){
                    typeString = "Fixed Monthly Expenses"
                }
                
                var description = record["description"]
                
                if (description == nil || description as! String == "") {
                    description = "No description"
                }
                
                if (localIdentifierString == nil) {
                    localIdentifierString = NSUUID().UUIDString
                }
                
                let newRecord = RecordTable(date: date, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String, recordedUser: recordedBy as! String)
                records.append(newRecord)
            }
        }
        return records
    }
}
