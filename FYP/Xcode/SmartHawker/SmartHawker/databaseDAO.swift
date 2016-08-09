//
//  ReportsViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//


import UIKit

class databaseDAO {
    
    // Mark: Properties
    // General Variables
    let user = PFUser.currentUser()
    // Mark: Action
    
    //loading from local datastore into controller
    func loadRecords() -> [PFObject]{
        let query = PFQuery(className: "Record")
        var records = [PFObject]()
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: user!)
        do{
            records = try query.findObjects()
        } catch {
            
        }
        return records
    }
    
    func loadRecordsIntoLocalDatastore(){
        // Part 1: Load from DB and pin into local datastore.
        let query = PFQuery(className: "Record")
        var records = [PFObject]()
        var objectRecords = [PFObject]()
        query.whereKey("user", equalTo: user!)
        do{
            records = try query.findObjects()
                // Pin records found into local datastore.
                PFObject.pinAllInBackground(records)
                
        }catch {
            
        }
    }
    
    
    
    
}
