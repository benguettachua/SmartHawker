//
//  RecordExpensesViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 2/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class RecordExpensesViewController: UIViewController{
    
    // MARK: Properties
    // Variables
    var type = 1
    var shared = ShareData.sharedInstance
    
    // Controller
    let recordController = RecordController()
    
    // Labels
    @IBOutlet weak var todayDateLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    // Buttons
    @IBOutlet weak var COGSButton: UIButton!
    @IBOutlet weak var OTHERSButton: UIButton!
    @IBOutlet weak var recurringButton: UIButton!
    
    // Image View
    @IBOutlet weak var recurringCheckbox: UIImageView!
    @IBOutlet weak var COGSCheckbox: UIImageView!
    @IBOutlet weak var expensesCheckbok: UIImageView!
    
    
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func save(sender: UIButton) {
        
        // Properties of the new record
        let description = descriptionTextField.text
        let amount = Double(amountTextField.text!)
        let isSubuser = shared.isSubUser
        let subuser = shared.subuser
        
        // Check if recording is suceesful.
        let recordSuccess = recordController.record(description!, amount: amount, isSubuser: isSubuser, subuser: subuser, type: type)
        
        if (recordSuccess) {
            
            // Record is sucessful, return to Record Day page.
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            
            // Record failed, popup to inform the user.
            let errorAlert = UIAlertController(title: "Error", message: "Recording failed. Please try again.", preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func add(sender: UIButton) {
        
        // Properties of the new record
        let description = descriptionTextField.text
        let amount = Double(amountTextField.text!)
        let isSubuser = shared.isSubUser
        let subuser = shared.subuser
        
        // Check if recording is successful.
        let recordSuccess = recordController.record(description!, amount: amount, isSubuser: isSubuser, subuser: subuser, type: type)
        
        if (recordSuccess) {
            
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
    
    @IBAction func selectOthersType(sender: UIButton) {
        type = 2
        COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        OTHERSButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        recurringButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        recurringCheckbox.image = UIImage(named: "record-blue-fade")
        expensesCheckbok.image = UIImage(named: "record-blue")
        COGSCheckbox.image = UIImage(named: "record-blue-fade")
    }
    
    @IBAction func selectCOGSType(sender: UIButton) {
        type = 1
        COGSButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        OTHERSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        recurringButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        recurringCheckbox.image = UIImage(named: "record-blue-fade")
        expensesCheckbok.image = UIImage(named: "record-blue-fade")
        COGSCheckbox.image = UIImage(named: "record-blue")
    }
    
    @IBAction func selectRecurring(sender: UIButton) {
        type = 3
        COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        OTHERSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        recurringButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        recurringCheckbox.image = UIImage(named: "record-blue")
        expensesCheckbok.image = UIImage(named: "record-blue-fade")
        COGSCheckbox.image = UIImage(named: "record-blue-fade")
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the date selected
        let dateString = self.shared.dateString
        todayDateLabel.text = dateString
    }
    
    // View will appear
    override func viewWillAppear(animated: Bool) {
        amountTextField.text = ""
        descriptionTextField.text = ""
    }
    
}
