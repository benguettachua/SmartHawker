//
//  RecordViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 27/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {
    
    // Mark: Properties
    @IBOutlet weak var profit: UILabel!
    @IBOutlet weak var sales: UILabel!
    @IBOutlet weak var COGS: UILabel!
    @IBOutlet weak var expenses: UILabel!
    @IBOutlet weak var salesTextField: UITextField!
    @IBOutlet weak var COGSTextField: UITextField!
    @IBOutlet weak var expensesTextField: UITextField!
    @IBOutlet weak var recordSuccessLabel: UILabel!
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void
    
    @IBOutlet weak var dateSelectedLabel: UILabel!
    var shared = ShareData.sharedInstance // This is the date selected from Main Calendar.
    
    // Array to store the records
    var records = [RecordTable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        
        // Populate the date selected
        let dateString = self.shared.dateString
        dateSelectedLabel.text = dateString
        
        // Load records
        loadRecords({ (success) -> Void in
            if (success) {
                var salesAmount = 0
                var COGSamount = 0
                var expensesAmount = 0
                var profit = 0
                for record in self.records {
                    if (record.type == "Sales" ) {
                        salesAmount += record.amount
                    } else if (record.type == "COGS") {
                        COGSamount += record.amount
                    } else if (record.type == "Expenses") {
                        expensesAmount += record.amount
                    }
                }
                profit = salesAmount - COGSamount - expensesAmount
                
                self.profit.text = String(profit)
                self.sales.text = String(salesAmount)
                self.COGS.text = String(COGSamount)
                self.expenses.text = String(expensesAmount)
                self.shared.records = self.records
            }
        })
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    func loadRecords(completionHandler: CompletionHandler) {
        
        let dateString = self.shared.dateString
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.whereKey("date", equalTo: dateString)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let date = object["date"] as! String
                        let type = object["type"] as! Int
                        let amount = object["amount"] as! Int
                        let objectIdString = object.objectId
                        var typeString = ""
                        if (type == 0) {
                            typeString = "Sales"
                        } else if (type == 1) {
                            typeString = "COGS"
                        } else if (type == 2) {
                            typeString = "Expenses"
                        }
                        let newRecord = RecordTable(date: date, type: typeString, amount: amount, objectId: objectIdString!)
                        self.records.append(newRecord)
                    }
                    completionHandler(success: true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
        
    }
    
    // Mark: Action
    @IBAction func SubmitRecord(sender: UIButton) {
        let salesToRecord = Int(salesTextField.text!)
        let COGSToRecord = Int(COGSTextField.text!)
        let expensesToRecord = Int(expensesTextField.text!)
        var didRecord = false
        
        // Get the date to save in DB.
        let dateString = self.shared.dateString
        
        let toRecord = PFObject(className: "Record")
        let toRecord2 = PFObject(className: "Record")
        let toRecord3 = PFObject(className: "Record")
        
        // Record Sales, if there is any value entered.
        if (salesToRecord != nil) {
            toRecord["date"] = dateString
            toRecord["amount"] = salesToRecord
            toRecord["user"] = PFUser.currentUser()
            toRecord["type"] = 0
            toRecord["subuser"] = PFUser.currentUser()?.username
            toRecord.saveEventually()
            didRecord = true
        }
        
        // Record COGS, if there is any value entered.
        if (COGSToRecord != nil) {
            toRecord2["date"] = dateString
            toRecord2["amount"] = COGSToRecord
            toRecord2["user"] = PFUser.currentUser()
            toRecord2["type"] = 1
            toRecord2["subuser"] = PFUser.currentUser()?.username
            toRecord2.saveEventually()
            didRecord = true
        }
        
        // Record Expenses, if there is any value entered.
        if (COGSToRecord != nil) {
            toRecord3["date"] = dateString
            toRecord3["amount"] = expensesToRecord
            toRecord3["user"] = PFUser.currentUser()
            toRecord3["type"] = 2
            toRecord3["subuser"] = PFUser.currentUser()?.username
            toRecord3.saveEventually()
            didRecord = true
        }
        
        // If there is any new record, shows success message, then refresh the view.
        if (didRecord == true) {
            recordSuccessLabel.hidden = false
            // Reload the view after 2 seconds, updating the records.
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.salesTextField.text = ""
                self.COGSTextField.text = ""
                self.expensesTextField.text = ""
                self.recordSuccessLabel.hidden = true
                self.viewDidLoad()
            }
            
        }

    }
    
}
