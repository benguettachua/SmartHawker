//
//  UpdateSalesViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 5/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class UpdateSalesViewController: UIViewController{
    
    // Properties
    
    // Controllers
    let recordController = RecordController()
    
    // Variables
    var type = 0
    var shared = ShareData.sharedInstance
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    // MARK: Action
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
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
   
    @IBAction func deleteRecord(sender: UIButton) {
        
        let selectedRecord = shared.selectedRecord
        let deleteSuccess = recordController.deleteRecord(selectedRecord)
        
        if (deleteSuccess) {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            print("Delete failed")
        }
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedRecord = shared.selectedRecord
        let amount = selectedRecord["amount"] as! Double
        let description = selectedRecord.description
        self.amountTextField.text = String(amount)
        self.descriptionTextField.text = description
    }
}