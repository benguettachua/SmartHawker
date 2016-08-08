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
    var type = 1
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    // Image Views
    @IBOutlet weak var COGSButtonImage: UIImageView!
    @IBOutlet weak var otherExpensesButtonImage: UIImageView!
    @IBOutlet weak var fixedExpensesButtonImage: UIImageView!
    
    // Button
    @IBOutlet weak var COGSButton: UIButton!
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var fixedExpensesButton: UIButton!
    
    
    
    // MARK: Action
    // Stop editing
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // Save changes and go back
    @IBAction func save(sender: UIButton) {
        updateRecord()
    }
    // Save changes and add new record
    @IBAction func add(sender: UIButton) {
    }
    // Edit this record to be COGS
    @IBAction func selectCOGS(sender: UIButton) {
        type = 1
        COGSButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        othersButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        fixedExpensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        fixedExpensesButtonImage.image = UIImage(named: "record-blue-fade")
        otherExpensesButtonImage.image = UIImage(named: "record-blue-fade")
        COGSButtonImage.image = UIImage(named: "record-blue")
    }
    // Edit this record to be Other Expenses
    @IBAction func selectOthers(sender: UIButton) {
        type = 2
        COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        othersButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        fixedExpensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        fixedExpensesButtonImage.image = UIImage(named: "record-blue-fade")
        otherExpensesButtonImage.image = UIImage(named: "record-blue")
        COGSButtonImage.image = UIImage(named: "record-blue-fade")
    }
    // Edit this record to be Monthly Expenses
    @IBAction func selectMonthlyExpenses(sender: UIButton) {
        type = 3
        COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        othersButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        fixedExpensesButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        fixedExpensesButtonImage.image = UIImage(named: "record-blue")
        otherExpensesButtonImage.image = UIImage(named: "record-blue-fade")
        COGSButtonImage.image = UIImage(named: "record-blue-fade")
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        print("Delete failed")
                    }
                })
            }
        }

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
    /*
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
    */
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
        /*
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
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
 
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the text field with the previous records.
        let selectedRecord = shared.selectedRecord
        let typeString = selectedRecord.type
        let amount = selectedRecord.amount
        let description = selectedRecord.description
        self.amountTextField.text = String(amount)
        if(description != "No description") {
            self.descriptionTextField.text = description
        }
        if (typeString == "COGS") {
            type = 1
            COGSButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            othersButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            fixedExpensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            fixedExpensesButtonImage.image = UIImage(named: "record-blue-fade")
            otherExpensesButtonImage.image = UIImage(named: "record-blue-fade")
            COGSButtonImage.image = UIImage(named: "record-blue")
        } else if (typeString == "Expenses") {
            type = 2
            COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            othersButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            fixedExpensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            fixedExpensesButtonImage.image = UIImage(named: "record-blue-fade")
            otherExpensesButtonImage.image = UIImage(named: "record-blue")
            COGSButtonImage.image = UIImage(named: "record-blue-fade")
        } else if (typeString == "Fixed Monthly Expenses") {
            type = 3
            COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            othersButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            fixedExpensesButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            fixedExpensesButtonImage.image = UIImage(named: "record-blue")
            otherExpensesButtonImage.image = UIImage(named: "record-blue-fade")
            COGSButtonImage.image = UIImage(named: "record-blue-fade")
        }
        
    }
}
