//
//  MonthRecordTableViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 28/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class MonthRecordTableViewController: UITableViewController {
    
    // MARK: Properties
    // Variables
    var shared = ShareData.sharedInstance
    var records = [PFObject]()
    let recordController = RecordController()
    
    // View will appear
    override func viewWillAppear(animated: Bool) {
        records.removeAll()
        records = recordController.loadRecords()
        
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
    }
    
    //  Back
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = self.tableView(tableView, titleForHeaderInSection: section)
        var rows = 0
        for record in records {
            let recordDate = record["date"] as! String
            if (recordDate == title) {
                rows += 1
            }
        }
        return rows
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecordTableViewCell
        
        // Description Label
        var description = records[indexPath.row]["description"] as? String
        if (description == "") {
            description = "No description"
        }
        cell.descriptionLabel.text = description
        
        // Amount Label
        let amount = records[indexPath.row]["amount"] as! Double
        let amountString2dp = "$" + String(format:"%.2f", amount)
        cell.amountLabel.text = amountString2dp
        
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
        
        // Recorded by
        var recordedBy = records[indexPath.row]["subuser"] as? String
        recordedBy = "By: " + recordedBy!
        cell.recordedByLabel.text = recordedBy
        
        // Cell background
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)

        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        // Get the number of days
        let date = NSDate()
        let cal = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)!
        let days = cal.rangeOfUnit(.Day, inUnit: .Month, forDate: date)
        return days.length
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let calendar = NSCalendar.currentCalendar() // you can also ask for a specific calendar (e.g Gregorian)
        let components = calendar.components([.Month, .Year], fromDate:NSDate())
        
        // Day
        let dayComponent = section+1
        var dayComponentString = String(dayComponent)
        if (dayComponent < 10) {
            dayComponentString = "0" + dayComponentString
        }
        
        // Month
        let monthComponent = components.month
        var monthComponentString = String(monthComponent)
        if (monthComponent < 10) {
            monthComponentString = "0" + monthComponentString
        }
        
        let date = dayComponentString + "/" + monthComponentString + "/" + String(components.year)
        return date
    }
}
