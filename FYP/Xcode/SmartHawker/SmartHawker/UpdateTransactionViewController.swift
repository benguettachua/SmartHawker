//
//  UpdateTransactionViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 29/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class UpdateTransactionViewController: UIViewController {
    
    // MARK: Properties
    // Variables
    var shared = ShareData.sharedInstance
    var type = Int()
    
    // TextField
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // Buttons
    @IBOutlet weak var COGSButton: UIButton!
    @IBOutlet weak var otherExpensesButton: UIButton!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var todaybtn: UIButton!
    @IBOutlet weak var addbtn: UIButton!
    
    // Label
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var descicon: UILabel!
    @IBOutlet weak var imageicon: UILabel!
    
    // Bar Button Item
    @IBOutlet weak var expensesBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var salesBarButtonItem: UIBarButtonItem!
    
    
    @IBOutlet weak var trashicon: UIButton!
    
    // View
    @IBOutlet weak var amountView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the selectedRecord to update.
        let selectedRecord = shared.selectedRecord
        
        // Set selected date to label
        let selectedDate = selectedRecord["date"] as! String
        todayLabel.text = selectedDate
        
        // Get the type of the record
        type = selectedRecord["type"] as! Int
        
        // Get the description of the record
        var description = selectedRecord["description"] as! String
        if (description == "") {
            description = "No description"
        }
        descriptionTextField.text = description
        
        // Get the amount of the record
        let amount = selectedRecord["amount"] as! Double
        amountTextField.text = String(amount)
        
        var faicon = [String: UniChar]()
        faicon["fatrash"] = 0xf1f8
        
        trashicon.titleLabel!.font = UIFont(name: "FontAwesome", size: 40)
        
        trashicon.setTitle(String(format: "%C", faicon["fatrash"]!), forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        // Change the background colour of the view
        if (type == 0) {
            amountView.backgroundColor = hexStringToUIColor("006cff")
            
            // Hide COGS and Expenses button
            COGSButton.hidden = true
            otherExpensesButton.hidden = true
            
            // UI Bar Button Item Change
            salesBarButtonItem.tintColor = hexStringToUIColor("006cff")
            expensesBarButtonItem.tintColor = UIColor.lightGrayColor()
        } else {
            amountView.backgroundColor = hexStringToUIColor("ff0000")
            
            // Show COGS and Expenses button
            COGSButton.hidden = false
            otherExpensesButton.hidden = false
            
            // UI Bar Button Item Change
            salesBarButtonItem.tintColor = UIColor.lightGrayColor()
            expensesBarButtonItem.tintColor = hexStringToUIColor("ff0000")
        }
    }
    // Changing colour based on colour code
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Select COGS as the type of expenses.
    @IBAction func selectCOGS(sender: UIButton) {
        // Change the type
        type = 1
        
        // Change the colour of buttons
        COGSButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        otherExpensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
    }
    
    // Select other expenses as the type.
    @IBAction func seelctExpenses(sender: UIButton) {
        // Change the type
        type = 2
        
        // Change the colour of buttons
        COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        otherExpensesButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    // Attach receipt for Audit Purpose
    @IBAction func attachedReceipt(sender: UIButton) {
        let comingSoonAlert = UIAlertController(title: "Coming soon", message: "Function currently developing!", preferredStyle: .Alert)
        comingSoonAlert.addAction(UIAlertAction(title: "ok", style: .Default, handler: nil))
        self.presentViewController(comingSoonAlert, animated: true, completion: nil)
    }
    
    // Click Save to save edit or new record.
    @IBAction func save(sender: UIButton) {
        
        let recordController = RecordController()
        let description = descriptionTextField.text
        let amount = Double(amountTextField.text!)
        let isSubuser = shared.isSubUser
        let subuser = shared.subuser
        
        
        let localIdentifier = shared.selectedRecord["subUser"] as! String
        let updateSuccess = recordController.update(localIdentifier, type: type, description: description!, amount: amount)
        
        if (updateSuccess) {
            
            // Updates controller
            recordController.loadDatesToCalendar()
            
            // Recording successful, inform the user that they can enter another record.
            let alert = UIAlertController(title: "Success", message: "Update success, please continue.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (Void) in
                self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            // Recording failed, popup to inform the user.
            let errorAlert = UIAlertController(title: "Error", message: "Updating failed. Please try again.", preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        
    }
    
    
    // Change the type to sale
    @IBAction func typeSales(sender: UIBarButtonItem) {
        type = 0
        self.viewWillAppear(true)
    }
    
    // Change the type to expenses
    @IBAction func typeExpenses(sender: UIBarButtonItem) {
        type = 1
        self.viewWillAppear(true)
    }
    
    
    @IBAction func deleteRecord(sender: UIButton) {
        let selectedRecord = shared.selectedRecord
        let recordController = RecordController()
        
        let warningAlert = UIAlertController(title: "Are you sure?", message: "Record will be permanently deleted.", preferredStyle: .Alert)
        warningAlert.addAction(UIAlertAction(title: "No", style: .Default, handler: nil))
        warningAlert.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { void in
            let deleteSuccess = recordController.deleteRecord(selectedRecord)
            
            if (deleteSuccess) {
                // Updates controller
                recordController.loadDatesToCalendar()
                
                // Deleting successful, inform the user
                let alert = UIAlertController(title: "Success", message: "Record deleted, please continue.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (Void) in
                    self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                
                // Delete failed, popup to inform the user.
                let errorAlert = UIAlertController(title: "Error", message: "Deleting failed. Please try again.", preferredStyle: .Alert)
                errorAlert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: nil))
                self.presentViewController(errorAlert, animated: true, completion: nil)
            }
        }))
        self.presentViewController(warningAlert, animated: true, completion: nil)
    }
    
}

