//
//  UpdateRecordViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 11/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class UpdateExpensesViewController: UIViewController {
    
    // MARK: Properties
    // Variables
    var shared = ShareData.sharedInstance
    let user = PFUser.currentUser()
    var tempCounter = 0
    typealias CompletionHandler = (success:Bool) -> Void
    
    // Text Fields
    
    
    
    // MARK: Action
    @IBAction func updateRecord(sender: UIButton) {
        let selectedRecord = shared.selectedRecord
        var typeString = selectedRecord.type
        var amount = selectedRecord.amount
        var description = selectedRecord.description
        
        // Updating the record
        let localIdentifier = selectedRecord.localIdentifier
        let query = PFQuery(className: "Record")
        query.fromLocalDatastore()
        query.whereKey("subUser", equalTo: localIdentifier)
        query.getFirstObjectInBackgroundWithBlock { (record: PFObject?, error: NSError?) -> Void in
            if (error != nil && record != nil) {
                // No object found or some error
                print("No object found or some error")
                print(error)
                print(record)
            } else if let record = record {
                // Record is found, proceed to update.
                var typeInt = Int()
                /*
                typeString = self.newType.text!
                amount = Double(self.newAmount.text!)!
                description = self.newDescription.text
 */
                if (typeString == "Sales") {
                    typeInt = 0
                } else if (typeString == "COGS") {
                    typeInt = 1
                } else if (typeString == "Expenses") {
                    typeInt = 2
                }
                
                record["type"] = typeInt
                record["amount"] = amount
                record["description"] = description
                record.pinInBackground()
                self.updateGlobalRecord({ (success) -> Void in
                    if (success) {
                        // Update success, go back to records
                        self.performSegueWithIdentifier("editComplete", sender: self)
                    } else {
                        print("Some error thrown.")
                    }
                })
            }
        }
        
    }
    @IBAction func deleteRecord(sender: UIButton) {
        // Updating the record
        let selectedRecord = shared.selectedRecord
        let localIdentifier = selectedRecord.localIdentifier
        let query = PFQuery(className: "Record")
        query.fromLocalDatastore()
        query.whereKey("subUser", equalTo: localIdentifier)
        query.getFirstObjectInBackgroundWithBlock { (record: PFObject?, error: NSError?) -> Void in
            if (error != nil && record != nil) {
                // No object found or some error
                print("No object found or some error")
                print(error)
                print(record)
            } else if let record = record {
                // Record is found, proceed to delete.
                record["amount"] = 0
                var array = NSUserDefaults.standardUserDefaults().objectForKey("SavedDateArray") as? [String] ?? [String]()
                
                for var i in 0..<array.count{
                    if array[i] == record["date"] as! String{
                        array.removeAtIndex(i)
                        i -= 1
                        break
                    }
                    
                }
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(array, forKey: "SavedDateArray")
                record.pinInBackground() // Updates the local store to $0. (Work-around step 1)
                record.deleteEventually() // Deletes from the DB when there is network.
                record.unpinInBackground() // Deletes from the local store when there is network. (Work-around step 2)
                self.updateGlobalRecord({ (success) -> Void in
                    if (success) {
                        print("Delete success")
                    } else {
                        print("Delete failed")
                    }
                })
            }
        }
    }
    
    // This updates the array "records" in ShareData.
    func updateGlobalRecord(completionHandler: CompletionHandler) {
        var records = [RecordTable]()
        let dateString = self.shared.dateString
        let query = PFQuery(className: "Record")
        let isSubUser = shared.isSubUser
        if (isSubUser) {
            query.whereKey("subuser", equalTo: shared.subuser)
        }
        query.whereKey("user", equalTo: user!)
        query.whereKey("date", equalTo: dateString)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let date = object["date"] as! String
                        let type = object["type"] as! Int
                        let amount = object["amount"] as! Double
                        var description = object["description"]
                        var localIdentifierString = object["subUser"]
                        var typeString = ""
                        if (type == 0) {
                            typeString = "Sales"
                        } else if (type == 1) {
                            typeString = "COGS"
                        } else if (type == 2) {
                            typeString = "Expenses"
                        }
                        
                        if (localIdentifierString == nil) {
                            localIdentifierString = String(self.tempCounter += 1)
                        }
                        
                        if (description == nil || description as! String == "") {
                            description = "No description"
                        }
                        let newRecord = RecordTable(date: date, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String)
                        records.append(newRecord)
                    }
                    self.shared.records = records
                    completionHandler(success: true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        // Populate the text field with the previous records.
        let selectedRecord = shared.selectedRecord
        let typeString = selectedRecord.type
        let amount = selectedRecord.amount
        let description = selectedRecord.description
        self.newType.text = typeString
        self.newAmount.text = String(amount)
        if(description != "No description") {
            self.newDescription.text = description
        }
        */
    }
}
