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

        
        
        // Clear records Array to prevent double counting
        records.removeAll()
        
        // Populate the date selected
        let dateString = self.shared.dateString
        

        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    
    // Mark: Action
    @IBAction func addRecord(sender: UIButton) {
    }
    
    @IBAction func selectSales(sender: UIButton) {
        type = 0
        saleButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        expensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        COGSBUtton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
    }
    
    @IBAction func selectExpenses(sender: UIButton) {
        type = 2
        saleButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        expensesButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        COGSBUtton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
    }
    
    @IBAction func selectCOGS(sender: UIButton) {
        type = 1
        saleButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        expensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        COGSBUtton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    
    
     
    @IBAction func SubmitRecord(sender: UIButton) {
        let descriptionToRecord = descriptionTextField.text
        let amountToRecord = Int(amountTextField.text!)
        var didRecord = false
        
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
            toRecord["type"] = type
            toRecord["subuser"] = PFUser.currentUser()?.username
            toRecord["subUser"] = NSUUID().UUIDString // This creates a unique identifier for this particular record.
            toRecord["description"] = descriptionToRecord
            // Save to local datastore
            toRecord.pinInBackground()
            array.append(dateString)
            didRecord = true
        }
        
        
        if (didRecord == true) {
            // If there is any new record, shows success message, then refresh the view.
            recordSuccessLabel.text = "Recording success!"
            recordSuccessLabel.textColor = UIColor.blackColor()
            recordSuccessLabel.hidden = false
            
            // Reload the view after 2 seconds, updating the records.
            let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 2 * Int64(NSEC_PER_SEC))
            dispatch_after(time, dispatch_get_main_queue()) {
                
                self.recordSuccessLabel.hidden = true
                self.viewDidLoad()
            }
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(array, forKey: "SavedDateArray")
        } else {
            // No record or only "0" entered. Shows error message then refresh the view.
            self.recordSuccessLabel.text = "Recording failed. Please try again."
            self.recordSuccessLabel.textColor = UIColor.redColor()
            self.recordSuccessLabel.hidden = false
            
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
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
