//
//  UpdateSalesViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 5/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class UpdateSalesViewController: UIViewController{
    
    // Properties
    // Variables
    var type = 0
    var shared = ShareData.sharedInstance
    var tempCounter = 0
    typealias CompletionHandler = (success:Bool) -> Void
    let user = PFUser.currentUser()
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    // MARK: Action
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: UIButton) {
        updateRecord()
    }
    
    @IBAction func add(sender: UIButton) {
    }
    
    func updateRecord() {
        let selectedRecord = shared.selectedRecord
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
                amount = Double(self.amountTextField.text!)!
                description = self.descriptionTextField.text
                
                record["type"] = self.type
                record["amount"] = amount
                record["description"] = description
                do {try record.pin()} catch {}
                self.updateGlobalRecord( { (success) -> Void in
                    
                    if (success) {
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    }
                )
                
            }
        }
        
    }
    
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
        do {
            let objects = try query.findObjects()
            for object in objects {
                let date = object["date"] as! String
                let type = object["type"] as! Int
                let amount = object["amount"] as! Double
                var description = object["description"]
                var localIdentifierString = object["subUser"]
                var recordedBy = object["subuser"]
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
                }
                
                if (localIdentifierString == nil) {
                    localIdentifierString = String(self.tempCounter += 1)
                }
                
                if (description == nil || description as! String == "") {
                    description = "No description"
                }
                let newRecord = RecordTable(date: date, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String, recordedUser: recordedBy as! String)
                records.append(newRecord)
            }
            self.shared.records = records
            completionHandler(success: true)
        } catch {
            print("Error caught")
        }
    }
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedRecord = shared.selectedRecord
        let amount = selectedRecord.amount
        let description = selectedRecord.description
        self.amountTextField.text = String(amount)
        self.descriptionTextField.text = description
    }
}