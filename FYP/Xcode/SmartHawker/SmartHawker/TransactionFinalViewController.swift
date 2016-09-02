//
//  TransactionFinalViewController.swift
//  SmartHawker
//
//  Created by Gao Min on 24/08/2016.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//


import UIKit
import FontAwesome_iOS

class TransactionFinalViewController: UIViewController {
    
    // MARK: Properties
    // Variables from previous VC
    var amount = Double()
    var type = Int()
    var shared = ShareData.sharedInstance
    
    // UIButton
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var todaybtn: UIButton!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var COGSButton: UIButton!
    @IBOutlet weak var otherExpensesButton: UIButton!
    
    // UILabel
    @IBOutlet weak var descicon: UILabel!
    @IBOutlet weak var imageicon: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var recriptUploadLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // View
    @IBOutlet weak var amountView: UIView!
    
    // View Did Load
    override func viewDidLoad() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        
        var faicon = [String: UniChar]()
        faicon["faleftback"] = 0xf053
        faicon["fatick"] = 0xf00c
        faicon["facalendar"] = 0xf274
        faicon["fadesc"] = 0xf044
        faicon["faimage"] = 0xf03e
        
        // UIUX Stuff here


        
        backbtn.titleLabel?.lineBreakMode
        backbtn.titleLabel?.numberOfLines = 2
        backbtn.titleLabel!.textAlignment = .Center
        
        var backs = String(format: "%C", faicon["faleftback"]!)
        
        backs += "\n"
        
        backs += "Back".localized()
        
        backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 15)
        
        backbtn.setTitle(String(backs), forState: .Normal);
        
        donebtn.titleLabel?.lineBreakMode
        donebtn.titleLabel?.numberOfLines = 2
        donebtn.titleLabel!.textAlignment = .Center
        
        var dones = String(format: "%C", faicon["fatick"]!)
        
        dones += "\n"
        
        dones += "Save".localized()
        
        donebtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 15)
        
        donebtn.setTitle(String(dones), forState: .Normal);
        
        todaybtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        todaybtn.setTitle(String(format: "%C", faicon["facalendar"]!), forState: .Normal)
        descicon.font = UIFont(name: "FontAwesome", size: 20)
        descicon.text = String(format: "%C", faicon["fadesc"]!)
        imageicon.font = UIFont(name: "FontAwesome", size: 20)
        imageicon.text = String(format: "%C", faicon["faimage"]!)
        
        COGSButton.setTitle("COGS".localized(), forState: UIControlState.Normal)
        otherExpensesButton.setTitle("Other expenses".localized(), forState: UIControlState.Normal)
        descriptionTextField.placeholder = "Add description".localized()
        recriptUploadLabel.text = "Attach your receipt (etc)".localized()
        // Set amount brought forward from previous page.
        amountLabel.text = String(amount)
        
        // Set selected date to label
        var selectedDate = shared.dateString
        if (selectedDate == nil) {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            selectedDate = dateFormatter.stringFromDate(NSDate())
        }
        todayLabel.text = selectedDate
        
        // Change the background colour of the view
        if (type == 0) {
            amountView.backgroundColor = hexStringToUIColor("006cff")
            
            // Hide COGS and Expenses button
            COGSButton.hidden = true
            otherExpensesButton.hidden = true
        } else {
            amountView.backgroundColor = hexStringToUIColor("ff0000")
        }
        
    }
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
        let comingSoonAlert = UIAlertController(title: "Coming soon".localized(), message: "Function currently developing!".localized(), preferredStyle: .Alert)
        comingSoonAlert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: nil))
        self.presentViewController(comingSoonAlert, animated: true, completion: nil)
    }
    
    // Click Save to save edit or new record.
    @IBAction func save(sender: UIButton) {
        
        let recordController = RecordController()
        let description = descriptionTextField.text
        let amount = Double(amountLabel.text!)
        let isSubuser = shared.isSubUser
        let subuser = shared.subuser
        
        // Check if this is a new record.
        
        // New record, save the new record.
        let saveSuccess = recordController.record(description!, amount: amount, isSubuser: isSubuser, subuser: subuser, type: type)
        
        if (saveSuccess) {
            
            // Updates controller
            recordController.loadDatesToCalendar()
            
            // Recording successful, inform the user that they can enter another record.
            let alert = UIAlertController(title: "Success".localized(), message: "Record success, please continue.".localized(), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: { (Void) in
                self.presentingViewController?.presentingViewController!.dismissViewControllerAnimated(false, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            // Recording failed, popup to inform the user.
            let errorAlert = UIAlertController(title: "Error".localized(), message: "Recording failed. Please try again.".localized(), preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "Try again".localized(), style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
    }
}