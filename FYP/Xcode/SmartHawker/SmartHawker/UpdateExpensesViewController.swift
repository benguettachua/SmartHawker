//
//  UpdateRecordViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 11/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class UpdateExpensesViewController: UIViewController {
    
    // MARK: Properties
    // Controllers
    let recordController = RecordController()
    
    // Variables
    var shared = ShareData.sharedInstance
    var type = 1
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    // Image Views
    @IBOutlet weak var COGSButtonImage: UIImageView!
    @IBOutlet weak var otherExpensesButtonImage: UIImageView!
    @IBOutlet weak var fixedExpensesButtonImage: UIImageView!
    
    // Button
    @IBOutlet weak var COGSButton: UIButton!
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var fixedExpensesButton: UIButton!
    
    
    
    // MARK: Action
    // Stop editing
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    // Save changes and go back
    @IBAction func save(sender: UIButton) {
        let localIdentifier = shared.selectedRecord["subUser"] as! String
        let amount = Double(amountTextField.text!)
        let description = descriptionTextField.text
        
        let updateSuccess = recordController.update(localIdentifier, type: type, description: description!, amount: amount)
        if (updateSuccess) {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("Update error!")
        }
    }
    
    // Edit this record to be COGS
    @IBAction func selectCOGS(sender: UIButton) {
        type = 1
        COGSButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        othersButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        fixedExpensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        fixedExpensesButtonImage.image = UIImage(named: "record-blue-fade")
        otherExpensesButtonImage.image = UIImage(named: "record-blue-fade")
        COGSButtonImage.image = UIImage(named: "record-blue")
    }
    // Edit this record to be Other Expenses
    @IBAction func selectOthers(sender: UIButton) {
        type = 2
        COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        othersButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        fixedExpensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        fixedExpensesButtonImage.image = UIImage(named: "record-blue-fade")
        otherExpensesButtonImage.image = UIImage(named: "record-blue")
        COGSButtonImage.image = UIImage(named: "record-blue-fade")
    }
    // Edit this record to be Monthly Expenses
    @IBAction func selectMonthlyExpenses(sender: UIButton) {
        type = 3
        COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        othersButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        fixedExpensesButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        fixedExpensesButtonImage.image = UIImage(named: "record-blue")
        otherExpensesButtonImage.image = UIImage(named: "record-blue-fade")
        COGSButtonImage.image = UIImage(named: "record-blue-fade")
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
   
    
    @IBAction func deleteRecord(sender: UIButton) {
        let selectedRecord = shared.selectedRecord
        let deleteSuccess = recordController.deleteRecord(selectedRecord)
        
        if (deleteSuccess) {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("Delete failed")
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the text field with the previous records.
        let selectedRecord = shared.selectedRecord
        let typeString = selectedRecord["type"] as! Int
        let amount = selectedRecord["amount"] as! Double
        let description = selectedRecord.description
        self.amountTextField.text = String(amount)
        if(description != "No description") {
            self.descriptionTextField.text = description
        }
        if (typeString == 1) {
            type = 1
            COGSButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            othersButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            fixedExpensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            fixedExpensesButtonImage.image = UIImage(named: "record-blue-fade")
            otherExpensesButtonImage.image = UIImage(named: "record-blue-fade")
            COGSButtonImage.image = UIImage(named: "record-blue")
        } else if (typeString == 2) {
            type = 2
            COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            othersButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            fixedExpensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            fixedExpensesButtonImage.image = UIImage(named: "record-blue-fade")
            otherExpensesButtonImage.image = UIImage(named: "record-blue")
            COGSButtonImage.image = UIImage(named: "record-blue-fade")
        } else if (typeString == 3) {
            type = 3
            COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            othersButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            fixedExpensesButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            fixedExpensesButtonImage.image = UIImage(named: "record-blue")
            otherExpensesButtonImage.image = UIImage(named: "record-blue-fade")
            COGSButtonImage.image = UIImage(named: "record-blue-fade")
        }
        
    }
}
