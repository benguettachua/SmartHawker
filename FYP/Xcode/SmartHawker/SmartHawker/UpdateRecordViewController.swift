//
//  UpdateRecordViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 11/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class UpdateRecordViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var newType: UITextField!
    @IBOutlet weak var newAmount: UITextField!
    var shared = ShareData.sharedInstance
    
    // MARK: Action
    @IBAction func updateRecord(sender: UIButton) {
        let selectedRecord = shared.selectedRecord
        var typeString = selectedRecord.type
        var amount = selectedRecord.amount
        
        // Updating the record
        let objectId = selectedRecord.objectId
        let query = PFQuery(className: "Record")
        
        query.getObjectInBackgroundWithId(objectId)
        {
            (record: PFObject?, error: NSError?) -> Void in
            if (error != nil) {
                print(error)
            } else if let record = record {
                var typeInt = Int()
                typeString = self.newType.text!
                amount = Int(self.newAmount.text!)!
                if (typeString == "Sales") {
                    typeInt = 0
                } else if (typeString == "COGS") {
                    typeInt = 1
                } else if (typeString == "Expenses") {
                    typeInt = 2
                }
                
                record["type"] = typeInt
                record["amount"] = amount
                record.saveEventually()
                self.performSegueWithIdentifier("backToRecord", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the text field with the previous records.
        let selectedRecord = shared.selectedRecord
        let typeString = selectedRecord.type
        let amount = selectedRecord.amount
        self.newType.text = typeString
        self.newAmount.text = String(amount)
        
    }
}
