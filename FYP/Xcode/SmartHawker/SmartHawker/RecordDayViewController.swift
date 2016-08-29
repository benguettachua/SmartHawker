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
    var records = [PFObject]()
    let recordDayController = RecordDayController()
    
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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Remove all records to prevent duplicates.
        records.removeAll()
        
        // Load records from local datastore into an array.
        records = recordDayController.loadRecord()
        
        if (records.isEmpty) {
            
            // No records are found, inform user that they have not made a record for the day.
            noRecordView.hidden = false
            tableView.hidden = true
        } else {
            
            // There are records found, show the records in a table form.
            noRecordView.hidden = true
            tableView.hidden = false
            
            // Loop through the records, removing all elements that should not be shown.
            for (i,num) in records.enumerate().reverse() {
                
                // Removing records that have amount $0.00 as it means that the record is deleted.
                if (records[i]["amount"] as! Double == 0) {
                    records.removeAtIndex(i)
                    
                // Removing records that have type 3 or 4 as it should not be shown, Monthly Fixed Expenses and Monthly Target.
                } else if (records[i]["type"] as! Int == 3 || records[i]["type"] as! Int == 4){
                    records.removeAtIndex(i)
                }
            }
            
            // After removing unnecessary elements, check if there is any records left, if there is not, inform the user that they do not have any records.
            if (records.isEmpty) {
                noRecordView.hidden = false
                tableView.hidden = true
            }
        }
        
        // Reload the table to show any ammendments made to the data.
        tableView.reloadData()
        tableView!.delegate = self
        tableView!.dataSource = self
        
        // Populate the UI, showing the date currently selected.
        let storeDate = shared.storeDate
        dayNumberLabel.text = String(storeDate.day)
        dayLabel.text = storeDate.weekdayName
        monthYearLabel.text = (storeDate.monthName + ", " + String(storeDate.year))
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any recourses that can be recreated.
    }
    
    // MARK: Action
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func nextDay(sender: UIButton) {
        let dateString = shared.dateString
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.dateFromString(dateString)
        let momentDate = moment(date!)
        let addDay = 1.days
        let nextDay = momentDate.add(addDay)
        let nextDayNSDate = nextDay.date
        let nextDayString = dateFormatter.stringFromDate(nextDayNSDate)
        shared.storeDate = nextDay
        shared.dateString = nextDayString
        self.viewWillAppear(true)
    }
    @IBAction func previousDay(sender: UIButton) {
        let dateString = shared.dateString
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.dateFromString(dateString)
        let momentDate = moment(date!)
        let minusDay = 1.days
        let nextDay = momentDate.subtract(minusDay)
        let nextDayNSDate = nextDay.date
        let nextDayString = dateFormatter.stringFromDate(nextDayNSDate)
        shared.storeDate = nextDay
        shared.dateString = nextDayString
        self.viewWillAppear(true)
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
    
    @IBAction func addRecord(sender: UIButton) {
        self.performSegueWithIdentifier("addRecord", sender: self)
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
        
        // Description Label
        cell.descriptionLabel.text = records[indexPath.row]["description"] as! String
        cell.descriptionLabel.font = UIFont(name: cell.descriptionLabel.font.fontName, size: 12)
        
        // Amount Label
        let amount = records[indexPath.row]["amount"] as! Double
        let amountString2dp = "$" + String(format:"%.2f", amount)
        cell.amountLabel.text = amountString2dp
        cell.amountLabel.font = UIFont(name: cell.amountLabel.font.fontName, size: 12)

        // Type Label
        let type = records[indexPath.row]["type"] as! Int
        var typeString = ""
        if (type == 0) {
            typeString = "Sales"
        } else if (type == 1) {
            typeString = "COGS"
        } else if (type == 2) {
            typeString = "Expenses"
        }
        cell.recordTypeLabel.text = typeString
        cell.recordTypeLabel.font = UIFont.boldSystemFontOfSize(20)
        
        // Image Button Colour
        if (type == 0) {
            cell.buttonImageView.image = UIImage(named: "record-green")
        } else if (type == 1) {
            cell.buttonImageView.image = UIImage(named: "record-red")
        } else if (type == 2) {
            cell.buttonImageView.image = UIImage(named: "record-red")
        } else {
            cell.buttonImageView.hidden = true
        }
        
        // Recorded by
        cell.recordedByLabel.text = records[indexPath.row]["subuser"] as! String
        
        // Cell background
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        shared.selectedRecord = records[indexPath.row]
        //self.performSegueWithIdentifier("updateRecord", sender: self)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let selectedRecord = records[indexPath.row]
            
            // Delete the record
            let deleteSuccess = recordDayController.deleteRecord(selectedRecord)
            if(deleteSuccess) {
                records.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            } else {
                print("Delete failed.")
            }
        }
    }
}
