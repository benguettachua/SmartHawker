//
//  RecordDayViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 30/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import SwiftMoment

class RecordDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    // Variable
    var shared = ShareData.sharedInstance
    let user = PFUser.currentUser()
    var records = [RecordTable]()
    typealias CompletionHandler = (success:Bool) -> Void
    var tempCounter = 0
    
    // Labels
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var noRecordLabel: UILabel!
    
    // Views
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noRecordView: UIView!
    
    // Buttons
    @IBOutlet weak var buttonName: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storeDate = shared.storeDate
        // Populate the view
        dayNumberLabel.text = String(storeDate.day)
        dayLabel.text = storeDate.weekdayName
        monthYearLabel.text = (storeDate.monthName + ", " + String(storeDate.year))
        
        tableView!.delegate = self
        tableView!.dataSource = self
        
        loadRecordsFromLocaDatastore({ (success) -> Void in
            
            if (self.records.isEmpty) {
                self.noRecordView.hidden = false
                self.tableView.hidden = true
            } else {
                self.noRecordView.hidden = true
                self.tableView.hidden = false
                
                
                for (i,num) in self.records.enumerate().reverse() {
                    if (self.records[i].amount == 0) {
                        self.records.removeAtIndex(i)
                    }
                }
            }
            
            self.viewDidAppear(true)
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any recourses that can be recreated.
    }
    
    // MARK: Action
    @IBAction func nextDay(sender: UIButton) {
        let dateString = shared.dateString
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.dateFromString(dateString)
        let momentDate = moment(date!)
        let addDay = 1.days
        let nextDay = momentDate.add(addDay)
        let nextDayNSDate = nextDay.toNSDate()
        let nextDayString = dateFormatter.stringFromDate(nextDayNSDate!)
        shared.storeDate = nextDay
        shared.dateString = nextDayString
        self.viewDidLoad()
    }
    @IBAction func previousDay(sender: UIButton) {
        let dateString = shared.dateString
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.dateFromString(dateString)
        let momentDate = moment(date!)
        let minusDay = 1.days
        let nextDay = momentDate.subtract(minusDay)
        let nextDayNSDate = nextDay.toNSDate()
        let nextDayString = dateFormatter.stringFromDate(nextDayNSDate!)
        shared.storeDate = nextDay
        shared.dateString = nextDayString
        self.viewDidLoad()
    }
    
    @IBAction func editTable(sender: UIButton) {
        if (self.tableView.editing == false) {
            self.tableView.editing = true
            self.buttonName.setTitle("Done", forState: UIControlState.Normal)
        } else {
            self.tableView.editing = false
            self.buttonName.setTitle("Edit Table", forState: UIControlState.Normal)
        }
    }
    
    
    
    // Below this comment are all the methods for table.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.records.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RecordCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecordTableViewCell
        
        cell.descriptionLabel.text = records[indexPath.row].description
        cell.amountLabel.text = String(records[indexPath.row].amount)
        cell.recordTypeLabel.text = records[indexPath.row].type
        
        cell.backgroundColor = UIColor.lightGrayColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Clicked on row: " + String(indexPath.row))
        shared.selectedRecord = records[indexPath.row]
        self.performSegueWithIdentifier("editRecord", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            // Updating the record
            let selectedRecord = records[indexPath.row]
            print(selectedRecord.toString())
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
                    record["amount"] = 0
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
                            
                            self.records.removeAtIndex(indexPath.row)
                            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                        } else {
                            print("Some error thrown.")
                        }
                    })
                }
            }
            
        }
    }
    
    // Loading of records
    func loadRecordsFromLocaDatastore(completionHandler: CompletionHandler) {
        // Load from local datastore into UI.
        records.removeAll()
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.whereKey("date", equalTo: shared.dateString)
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
                        var localIdentifierString = object["subUser"]
                        var typeString = ""
                        if (type == 0) {
                            typeString = "Sales"
                        } else if (type == 1) {
                            typeString = "COGS"
                        } else if (type == 2) {
                            typeString = "Expenses"
                        } else if (type == 3){
                            typeString = "fixMonthlyExpenses"
                        }
                        
                        var description = object["description"]
                        
                        if (description == nil || description as! String == "") {
                            description = "No description"
                        }
                        
                        if (localIdentifierString == nil) {
                            localIdentifierString = String(self.tempCounter += 1)
                        }
                        
                        let newRecord = RecordTable(date: date, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String)
                        self.records.append(newRecord)
                    }
                    completionHandler(success: true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
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
    
}
