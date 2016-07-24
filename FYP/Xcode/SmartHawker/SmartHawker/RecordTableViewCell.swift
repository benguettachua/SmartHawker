//
//  RecordTableViewCell.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 10/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var sectionSelected: Int!
    var rowSelected: Int!
    var shared = ShareData.sharedInstance
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void
    var tempCounter = 0
    
    // Delegate
    var delegate: MyCustomerCellDelegator!
    
    // MARK: Action
    @IBAction func editButton(sender: UIButton) {
        let items = shared.items
        let selectedRecord = items[sectionSelected][rowSelected]
        
        if (self.delegate != nil) {
            shared.selectedRecord = selectedRecord
            self.delegate.callSegueFromCell(myData: selectedRecord)
        }
        
        
    }
    
    @IBAction func deleteButton(sender: UIButton) {
        let items = shared.items
        let selectedRecord = items[sectionSelected][rowSelected]
        let amount = 0
        
        // Updating the record
        let localIdentifier = selectedRecord.localIdentifier
        let query = PFQuery(className: "Record")
        query.fromLocalDatastore()
        query.whereKey("subUser", equalTo: localIdentifier)
        query.getFirstObjectInBackgroundWithBlock { (record: PFObject?, error: NSError?) -> Void in
            if (error != nil && record != nil) {
                // No object found or some error
                print("No object found or some error")
                print(error)
                print(record)
            } else if let record = record {
                // Record is found, proceed to delete.
                record["amount"] = amount
                var array = NSUserDefaults.standardUserDefaults().objectForKey("SavedDateArray") as? [String] ?? [String]()
                
                for var i in 0..<array.count{
                    if array[i] == record["date"] as! String{
                        array.removeAtIndex(i)
                        i -= 1
                        break
                    }
                    
                }
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(array, forKey: "SavedDateArray")
                record.pinInBackground() // Updates the local store to $0. (Work-around step 1)
                record.deleteEventually() // Deletes from the DB when there is network.
                record.unpinInBackground() // Deletes from the local store when there is network. (Work-around step 2)
                self.updateGlobalRecord({ (success) -> Void in
                    if (success) {
                        // Update success, go back to records
                        self.delegate.backToRecordFromCell()
                    } else {
                        print("Some error thrown.")
                    }
                })
            }
        }
        
        /*
         query.getObjectInBackgroundWithId(localIdentifier){
         (record: PFObject?, error: NSError?) -> Void in
         if (error != nil) {
         print(error)
         } else if let record = record {
         
         record["amount"] = amount
         var array = NSUserDefaults.standardUserDefaults().objectForKey("SavedDateArray") as? [String] ?? [String]()
         
         for var i in 0..<array.count{
         if array[i] == record["date"] as! String{
         array.removeAtIndex(i)
         i -= 1
         break
         }
         
         }
         let defaults = NSUserDefaults.standardUserDefaults()
         defaults.setObject(array, forKey: "SavedDateArray")
         record.pinInBackground() // Updates the local store to $0. (Work-around step 1)
         record.deleteEventually() // Deletes from the DB when there is network.
         record.unpinInBackground() // Deletes from the local store when there is network. (Work-around step 2)
         self.updateGlobalRecord({ (success) -> Void in
         if (success) {
         // Update success, go back to records
         self.delegate.backToRecordFromCell()
         } else {
         print("Some error thrown.")
         }
         })
         
         }
         }*/
        
        
        
    }
    
    // This updates the array "records" in ShareData.
    func updateGlobalRecord(completionHandler: CompletionHandler) {
        var records = [RecordTable]()
        let dateString = self.shared.dateString
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.whereKey("date", equalTo: dateString)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let date = object["date"] as! String
                        let type = object["type"] as! Int
                        let amount = object["amount"] as! Int
                        var description = object["description"]
                        var localIdentifierString = object["subUser"]
                        var typeString = ""
                        if (type == 0) {
                            typeString = "Sales"
                        } else if (type == 1) {
                            typeString = "COGS"
                        } else if (type == 2) {
                            typeString = "Expenses"
                        }
                        
                        if (localIdentifierString == nil) {
                            localIdentifierString = String(self.tempCounter += 1)
                        }
                        
                        if (description == nil || description as! String == "") {
                            description = "No description"
                        }
                        let newRecord = RecordTable(date: date, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String)
                        records.append(newRecord)
                    }
                    self.shared.records = records
                    completionHandler(success: true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
