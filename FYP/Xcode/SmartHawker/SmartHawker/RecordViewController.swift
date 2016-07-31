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
    var type = 0
    
    // Categories
    @IBOutlet weak var saleButton: UIButton!
    @IBOutlet weak var expensesButton: UIButton!
    @IBOutlet weak var COGSBUtton: UIButton!
    
    // Labels
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var recordSuccessLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    // Button
    @IBOutlet weak var submitRecordButton: UIButton!
    
    // Navigation Bar
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var back: UIBarButtonItem!
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

        submitRecordButton.setTitle("Add Record".localized(), forState: .Normal)

        
        
        // Clear records Array to prevent double counting
        records.removeAll()
        
        // Populate the date selected
        let dateString = self.shared.dateString
        
        self.view.addSubview(scrollView)
        scrollView.scrollEnabled = false
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    /*
    // Mark: Action
    @IBAction func SubmitRecord(sender: UIButton) {
        let descriptionToRecord = descriptionTextField.text
        let amountToRecord = Int(amountTextField.text!)
        
        // Get the date to save in DB.
        let dateString = self.shared.dateString
        var array = NSUserDefaults.standardUserDefaults().objectForKey("SavedDateArray") as? [String] ?? [String]()
        
        let toRecord = PFObject(className: "Record")  // save sales
        toRecord.ACL = PFACL(user: PFUser.currentUser()!)
        
        // Record Sales, if there is any value entered.
        if (amountToRecord != nil && amountToRecord != 0) {
            toRecord["date"] = dateString
            toRecord["amount"] = amountToRecord
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
    */
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
        
        recordSuccessLabel.resignFirstResponder()
        submitRecordButton.resignFirstResponder()
        return true
    }
    
}
