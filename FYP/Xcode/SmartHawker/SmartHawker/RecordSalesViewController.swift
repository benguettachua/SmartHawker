//
//  RecordViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 27/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//
import UIKit

class RecordSalesViewController: UIViewController, UITextFieldDelegate {
    
    // Mark: Properties
    var type = 0
    
    // Categories
    @IBOutlet weak var saleButton: UIButton!
    @IBOutlet weak var expensesButton: UIButton!
    
    // Labels
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var recordSuccessLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    // Button
    @IBOutlet weak var submitRecordButton: UIButton!
    
    // Navigation Bar
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var settings: UIBarButtonItem!
    
    // Variables
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void
    var shared = ShareData.sharedInstance // This is the date selected from Main Calendar.
    
    // Array to store the records
    var records = [RecordTable]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        
        // Populate the date selected
        let dateString = self.shared.dateString
        todayDateLabel.text = dateString
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    
    // Mark: Action
    @IBAction func selectSales(sender: UIButton) {
        type = 0
    }
    // Clicking this button will return the user back to the previous page.
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // Clicking this button will save the record, then return the user back to the previous page.
    @IBAction func save(sender: UIButton) {
        SubmitRecord({ (success) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        
    }
    // Clicking this button will save the record, stay at the same page for user to save another record.
    @IBAction func add(sender: UIButton) {
        SubmitRecord({ (success) -> Void in
        })
    }
    
    func SubmitRecord(completionHandler: CompletionHandler) {
        let descriptionToRecord = descriptionTextField.text
        let amountToRecord = Double(amountTextField.text!)
        var didRecord = false
        let isSubUser = shared.isSubUser
        
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
            if (isSubUser) {
                toRecord["subuser"] = shared.subuser
            } else {
                toRecord["subuser"] = PFUser.currentUser()?.username
            }
            toRecord["subUser"] = NSUUID().UUIDString // This creates a unique identifier for this particular record.
            toRecord["description"] = descriptionToRecord
            // Save to local datastore
            do{ try toRecord.pin() } catch {}
            array.append(dateString)
            didRecord = true
        }
        
        
        if (didRecord == true) {
            // If there is any new record, shows success message, then refresh the view.
            recordSuccessLabel.text = "Recording success!"
            recordSuccessLabel.textColor = UIColor.blackColor()
            recordSuccessLabel.hidden = false
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(array, forKey: "SavedDateArray")
            
            completionHandler(success: true)
        } else {
            // No record or only "0" entered. Shows error message.
            self.recordSuccessLabel.text = "Recording failed. Please try again."
            self.recordSuccessLabel.textColor = UIColor.redColor()
            self.recordSuccessLabel.hidden = false
            
        }

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        recordSuccessLabel.resignFirstResponder()
        submitRecordButton.resignFirstResponder()
        return true
    }
    
}
