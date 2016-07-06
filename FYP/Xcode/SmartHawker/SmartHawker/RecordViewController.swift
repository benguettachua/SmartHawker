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
    
    @IBOutlet weak var dateSelectedLabel: UILabel!
    var shared = ShareData.sharedInstance // This is the date selected from Main Calendar.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the date selected
        let dateString = self.shared.dateString
        dateSelectedLabel.text = dateString
        print(dateString)
        
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd/MM/yyyy"
        //let dateString = dayTimePeriodFormatter.stringFromDate(date)
        
        let user = PFUser.currentUser()
        
        // Query to extract sales
        var totalSales = 0
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.whereKey("type", equalTo: 0)
        query.whereKey("date", equalTo: dateString)
        do {
            let salesArray = try query.findObjects()
            for sales in salesArray {
                totalSales += sales["amount"] as! Int
            }
            self.sales.text = String(totalSales)
        } catch {
            // Do nothing since should not get error, to add on to handle error in future
        }
       
        
        // Query to extract COGS
        var totalCOGS = 0
        let query2 = PFQuery(className: "Record")
        query2.whereKey("user", equalTo: user!)
        query2.whereKey("type", equalTo: 1)
        query2.whereKey("date", equalTo: dateString)
        do {
            let COGSArray = try query2.findObjects()
            for COGS in COGSArray {
                totalCOGS += COGS["amount"] as! Int
            }
            self.COGS.text = String(totalCOGS)
        } catch {
            // Do nothing since should not get error, to add on to handle error in future
        }
        
        // Query to extract Expenses
        var totalExpenses = 0
        let query3 = PFQuery(className: "Record")
        query3.whereKey("user", equalTo: user!)
        query3.whereKey("type", equalTo: 2)
        query3.whereKey("date", equalTo: dateString)
        do {
            let expensesArray = try query3.findObjects()
            for expenses in expensesArray {
                totalExpenses += expenses["amount"] as! Int
            }
            self.expenses.text = String(totalExpenses)
        } catch {
            // Do nothing since should not get error, to add on to handle error in future
        }
        
        // Calculate total profit.
        let totalProfit = totalSales - totalCOGS - totalExpenses
        self.profit.text = String(totalProfit)
        
    }
    
    // MARK: Table
    /*
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // User
        let user = PFUser.currentUser()
        
        // Date
        let date = self.shared.date
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dayTimePeriodFormatter.stringFromDate(date)
        
        // Query
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.whereKey("date", equalTo: dateString)
        do {
            let records = try query.findObjects()
            return records.count
        } catch {
            // Do nothing since should not get error, to add on the handle error in future
            return 0
        }
    }
 */
    /*
    // Mark: Action
    @IBAction func SubmitRecord(sender: UIButton) {
        let salesToRecord = Int(salesTextField.text!)
        let COGSToRecord = Int(COGSTextField.text!)
        let expensesToRecord = Int(expensesTextField.text!)
        var didRecord = false
        
        // Get the date to save in DB.
        //let date = self.shared.date
        let dayTimePeriodFormatter = NSDateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = dayTimePeriodFormatter.stringFromDate(date)
        
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
    */
}
