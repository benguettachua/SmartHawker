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
}
