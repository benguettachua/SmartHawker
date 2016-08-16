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
    
    // Controllers
    let recordController = RecordController()
    
    // Categories
    @IBOutlet weak var saleButton: UIButton!
    @IBOutlet weak var expensesButton: UIButton!
    
    // Labels
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    // Button
    @IBOutlet weak var submitRecordButton: UIButton!
    
    // Variables
    var type = 0
    var shared = ShareData.sharedInstance 

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the date selected
        let dateString = self.shared.dateString
        todayDateLabel.text = dateString
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
        
        // Properties of the new record
        let description = descriptionTextField.text
        let amount = Double(amountTextField.text!)
        let isSubuser = shared.isSubUser
        let subuser = shared.subuser
        
        // Check if recording is suceesful.
        let recordSuccess = recordController.record(description!, amount: amount, isSubuser: isSubuser, subuser: subuser, type: type)
        
        if (recordSuccess) {
            
            // Updates controller
            recordController.loadDatesToCalendar()
            
            // Record is sucessful, return to Record Day page.
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            
            // Record failed, popup to inform the user.
            let errorAlert = UIAlertController(title: "Error", message: "Recording failed. Please try again.", preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
    }
    
    // Clicking this button will save the record, stay at the same page for user to save another record.
    @IBAction func add(sender: UIButton) {
        
        // Properties of the new record
        let description = descriptionTextField.text
        let amount = Double(amountTextField.text!)
        let isSubuser = shared.isSubUser
        let subuser = shared.subuser
        
        // Check if recording is successful.
        let recordSuccess = recordController.record(description!, amount: amount, isSubuser: isSubuser, subuser: subuser, type: type)
        
        if (recordSuccess) {
            
            // Updates controller
            recordController.loadDatesToCalendar()
            
            // Recording successful, inform the user that they can enter another record.
            let alert = UIAlertController(title: "Success", message: "You may enter another record.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (Void) in
                self.viewWillAppear(true)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            // Recording failed, popup to inform the user.
            let errorAlert = UIAlertController(title: "Error", message: "Recording failed. Please try again.", preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        descriptionTextField.text = ""
        amountTextField.text = ""
    }
    
}
