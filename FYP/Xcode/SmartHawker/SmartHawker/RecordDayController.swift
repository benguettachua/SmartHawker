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
    
    // Loads all records made on the day and return an array of RecordTable
    func loadRecord() -> [PFObject]{
        
        var records = [PFObject]()
        var PFRecords: [PFObject]?
        let isSubuser = shared.isSubUser
        let dateToLoad = shared.dateString
        let subuser = shared.subuser
        
        // Load records of the day.
        PFRecords = dao.loadRecordOfTheDay(isSubuser, date: dateToLoad, subuser: subuser)
        
        // There are records found.
        if (PFRecords != nil) {
            
            // Process all records found into [RecordTable] array.
            for record in PFRecords! {
                
                records.append(record)
            }
        }
        return records
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
}
