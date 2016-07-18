//
//  UpdateRecordViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 11/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class UpdateRecordViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var newType: UITextField!
    @IBOutlet weak var newAmount: UITextField!
    @IBOutlet weak var newDescription: UITextField!
    
    
    var shared = ShareData.sharedInstance
    let user = PFUser.currentUser()
    var tempCounter = 0
    typealias CompletionHandler = (success:Bool) -> Void
    
    // MARK: Action
    @IBAction func updateRecord(sender: UIButton) {
        let selectedRecord = shared.selectedRecord
        var typeString = selectedRecord.type
        var amount = selectedRecord.amount
        var description = selectedRecord.description
        
        // Updating the record
        let objectId = selectedRecord.objectId
        let query = PFQuery(className: "Record")
        query.fromLocalDatastore()
        query.getObjectInBackgroundWithId(objectId)
        {
            (record: PFObject?, error: NSError?) -> Void in
            if (error != nil) {
                print(error)
            } else if let record = record {
                var typeInt = Int()
                typeString = self.newType.text!
                amount = Int(self.newAmount.text!)!
                description = self.newDescription.text
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
                //
                record.pinInBackground()
                record.saveEventually()
                self.updateGlobalRecord({ (success) -> Void in
                    if (success) {
                        // Update success, go back to records
                        self.performSegueWithIdentifier("backToRecord", sender: self)
                    } else {
                        print("Some error thrown.")
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
                        let amount = object["amount"] as! Int
                        var description = object["description"]
                        var objectIdString = object.objectId
                        var typeString = ""
                        if (type == 0) {
                            typeString = "Sales"
                        } else if (type == 1) {
                            typeString = "COGS"
                        } else if (type == 2) {
                            typeString = "Expenses"
                        }
                        
                        if (objectIdString == nil) {
                            objectIdString = String(self.tempCounter += 1)
                        }
                        
                        if (description == nil || description as! String == "") {
                            description = "No description"
                        }
                        let newRecord = RecordTable(date: date, type: typeString, amount: amount, objectId: objectIdString!, description: description as! String)
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
        
        // Populate the text field with the previous records.
        let selectedRecord = shared.selectedRecord
        let typeString = selectedRecord.type
        let amount = selectedRecord.amount
        self.newType.text = typeString
        self.newAmount.text = String(amount)
        
    }
}
