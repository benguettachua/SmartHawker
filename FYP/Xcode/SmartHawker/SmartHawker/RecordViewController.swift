//
//  RecordViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 27/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//
import UIKit

class RecordViewController: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var newRecord: UILabel!
    @IBOutlet weak var recordedProfit: UILabel!
    @IBOutlet weak var recordedSales: UILabel!
    @IBOutlet weak var recordedCOGS: UILabel!
    @IBOutlet weak var recordedExpenses: UILabel!
    @IBOutlet weak var todaySales: UILabel!
    @IBOutlet weak var todayCOGS: UILabel!
    @IBOutlet weak var todayExpenses: UILabel!
    @IBOutlet weak var salesDescriptionLabel: UILabel!
    @IBOutlet weak var salesDescriptionTextField: UITextField!
    @IBOutlet weak var COGSDescriptionLabel: UILabel!
    @IBOutlet weak var COGSDescriptionTextField: UITextField!
    @IBOutlet weak var expensesDescriptionLabel: UILabel!
    @IBOutlet weak var expensesDescriptionTextField: UITextField!
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var viewRecordsButton: UIButton!
    @IBOutlet weak var submitRecordButton: UIButton!
    @IBOutlet weak var settings: UIBarButtonItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    var tempCounter = 0
    
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void


    var shared = ShareData.sharedInstance // This is the date selected from Main Calendar.
    
    // Array to store the records
    var records = [RecordTable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        
        //for translation
        navBar.title = "Record".localized()
        back.title = "Back".localized()
        settings.title = "Settings".localized()
        recordedSales.text = "Total Sales($):".localized()
        recordedCOGS.text = "Total COGS($):".localized()
        recordedExpenses.text = "Total Other Expenses($):".localized()
        recordedProfit.text = "Total Profit($):".localized()
        viewRecordsButton.setTitle("View All Records".localized(), forState: .Normal)
        
        newRecord.text = "Add New Record".localized()
        todaySales.text = "Sales($):".localized()
        todayCOGS.text = "COGS($):".localized()
        todayExpenses.text = "Other Expenses($):".localized()
        salesTextField.placeholder = "Sales($)".localized()
        COGSTextField.placeholder = "Cost of Goods Sold($)".localized()
        expensesTextField.placeholder = "Other Expenses($)".localized()
        submitRecordButton.setTitle("Add Record".localized(), forState: .Normal)
        
        expensesDescriptionLabel.text = "Description".localized()
        COGSDescriptionLabel.text = "Description".localized()
        salesDescriptionLabel.text = "Description".localized()
        expensesDescriptionTextField.placeholder = "Other Expenses Description".localized()
        COGSDescriptionTextField.placeholder = "COGS Description".localized()
        salesDescriptionTextField.placeholder = "Sales Description".localized()
        
        
        // Clear records Array to prevent double counting
        records.removeAll()
        
        // Populate the date selected
        let dateString = self.shared.dateString
        let toDisplayDate = self.shared.toDisplayDate
        dateSelectedLabel.text = toDisplayDate
        
        self.view.addSubview(scrollView)
        scrollView.scrollEnabled = false
        
        
        // Load records from local datastore to UI.
        loadRecordsFromLocaDatastore({ (success) -> Void in
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
                if profit > 0{
                    self.profit.textColor = UIColor.greenColor()
                }else if profit < 0{
                    self.profit.textColor = UIColor.redColor()
                }else{
                    self.profit.textColor = UIColor.greenColor()
                }
                self.sales.text = String(salesAmount)

                self.COGS.text = String(COGSamount)
                self.COGS.textColor = UIColor.redColor()
                self.expenses.text = String(expensesAmount)
                self.expenses.textColor = UIColor.redColor()
                self.shared.records = self.records
            } else {
                print("Some error thrown.")
            }
        })
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    func loadRecordsFromLocaDatastore(completionHandler: CompletionHandler) {
        // Part 2: Load from local datastore into UI.
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
                        var localIdentifierString = object["subUser"]
                        var typeString = ""
                        if (type == 0) {
                            typeString = "Sales"
                        } else if (type == 1) {
                            typeString = "COGS"
                        } else if (type == 2) {
                            typeString = "Expenses"
                        }
                        
                        var description = object["description"]
                        
                        if (description == nil || description as! String == "") {
                            description = "No description"
                        }
                        
                        if (localIdentifierString == nil) {
                            localIdentifierString = String(self.tempCounter += 1)
                        }
                        let newRecord = RecordTable(date: date, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String)
                        self.records.append(newRecord)
                    }
                    self.records.sortInPlace({$0.amount > $1.amount}) // Sort the records in descending order of amount.
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
        var array = NSUserDefaults.standardUserDefaults().objectForKey("SavedDateArray") as? [String] ?? [String]()
        
        let toRecord = PFObject(className: "Record")  // save sales
        toRecord.ACL = PFACL(user: PFUser.currentUser()!)
        
        let toRecord2 = PFObject(className: "Record") // save COGS
        toRecord2.ACL = PFACL(user: PFUser.currentUser()!)
        
        let toRecord3 = PFObject(className: "Record") // save expenses
        toRecord3.ACL = PFACL(user: PFUser.currentUser()!)
        
        // Record Sales, if there is any value entered.
        if (salesToRecord != nil && salesToRecord != 0) {
            toRecord["date"] = dateString
            toRecord["amount"] = salesToRecord
            toRecord["user"] = PFUser.currentUser()
            toRecord["type"] = 0
            toRecord["subuser"] = PFUser.currentUser()?.username
            toRecord["subUser"] = NSUUID().UUIDString // This creates a unique identifier for this particular record.
            toRecord["description"] = String(salesDescriptionTextField.text!)
            // Save to local datastore
            toRecord.pinInBackground()
            array.append(dateString)
            didRecord = true
        }
        
        // Record COGS, if there is any value entered.
        if (COGSToRecord != nil && COGSToRecord != 0) {
            toRecord2["date"] = dateString
            toRecord2["amount"] = COGSToRecord
            toRecord2["user"] = PFUser.currentUser()
            toRecord2["type"] = 1
            toRecord2["subuser"] = PFUser.currentUser()?.username
            toRecord2["subUser"] = NSUUID().UUIDString // This creates a unique identifier for this particular record.
            toRecord2["description"] = String(COGSDescriptionTextField.text!)
            // Save to local datastore
            toRecord2.pinInBackground()
            array.append(dateString)
            didRecord = true
        }
        
        // Record Expenses, if there is any value entered.
        if (expensesToRecord != nil && expensesToRecord != 0) {
            toRecord3["date"] = dateString
            toRecord3["amount"] = expensesToRecord
            toRecord3["user"] = PFUser.currentUser()
            toRecord3["type"] = 2
            toRecord3["subuser"] = PFUser.currentUser()?.username
            toRecord3["subUser"] = NSUUID().UUIDString // This creates a unique identifier for this particular record.
            toRecord3["description"] = String(expensesDescriptionTextField.text!)
            // Save to local datastore
            toRecord3.pinInBackground()
            array.append(dateString)
            didRecord = true
        }
        
        
        if (didRecord == true) {
            // If there is any new record, shows success message, then refresh the view.
            recordSuccessLabel.text = "Recording success, reloading view..."
            recordSuccessLabel.textColor = UIColor.blackColor()
            recordSuccessLabel.hidden = false
            
            // Reload the view after 2 seconds, updating the records.
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.salesTextField.text = ""
                self.COGSTextField.text = ""
                self.expensesTextField.text = ""
                self.salesDescriptionTextField.text = ""
                self.COGSDescriptionTextField.text = ""
                self.expensesDescriptionTextField.text = ""
                
                self.recordSuccessLabel.hidden = true
                self.viewDidLoad()
            }
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(array, forKey: "SavedDateArray")
        } else {
            // No record or only "0" entered. Shows error message then refresh the view.
            self.recordSuccessLabel.text = "No records submitted."
            self.recordSuccessLabel.textColor = UIColor.redColor()
            self.recordSuccessLabel.hidden = false
            
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentSize = CGSize(width:self.view.frame.width, height: 900)
        
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 175), animated: true)
        scrollView.scrollEnabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        scrollView.scrollEnabled = false
    }
    

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        profit.resignFirstResponder()
        sales.resignFirstResponder()
        COGS.resignFirstResponder()
        expenses.resignFirstResponder()
        salesTextField.resignFirstResponder()
        COGSTextField.resignFirstResponder()
        expensesTextField.resignFirstResponder()
        recordSuccessLabel.resignFirstResponder()
        dateSelectedLabel.resignFirstResponder()
        newRecord.resignFirstResponder()
        recordedProfit.resignFirstResponder()
        recordedSales.resignFirstResponder()
        recordedCOGS.resignFirstResponder()
        recordedExpenses.resignFirstResponder()
        todaySales.resignFirstResponder()
        todayCOGS.resignFirstResponder()
        todayExpenses.resignFirstResponder()
        viewRecordsButton.resignFirstResponder()
        submitRecordButton.resignFirstResponder()
        salesDescriptionLabel.resignFirstResponder()
        salesDescriptionTextField.resignFirstResponder()
        COGSDescriptionLabel.resignFirstResponder()
        COGSDescriptionTextField.resignFirstResponder()
        expensesDescriptionLabel.resignFirstResponder()
        expensesDescriptionTextField.resignFirstResponder()
        return true
    }
    
}
