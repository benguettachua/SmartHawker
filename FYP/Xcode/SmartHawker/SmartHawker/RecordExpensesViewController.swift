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
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void
    var shared = ShareData.sharedInstance
    
    // Labels
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var recordSuccessLabel: UILabel!
    
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    // Buttons
    @IBOutlet weak var COGSButton: UIButton!
    @IBOutlet weak var OTHERSButton: UIButton!
    
    
    // MARK: Action
    @IBAction func selectSales(sender: UIButton) {
        self.performSegueWithIdentifier("toSales", sender: self)
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.performSegueWithIdentifier("backToRecordDay", sender: self)
    }
    
    @IBAction func save(sender: UIButton) {
        SubmitRecord({ (success) -> Void in
            self.performSegueWithIdentifier("backToRecordDay", sender: self)
        })
    }
    
    @IBAction func add(sender: UIButton) {
        SubmitRecord({ (success) -> Void in
        })
    }
    
    @IBAction func selectOthersType(sender: UIButton) {
        type = 2
        COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        OTHERSButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    @IBAction func selectCOGSType(sender: UIButton) {
        type = 1
        COGSButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        OTHERSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
    }
    
    func SubmitRecord(completionHandler: CompletionHandler) {
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
    
    // View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the date selected
        let dateString = self.shared.dateString
        todayDateLabel.text = dateString
    }
    
}
