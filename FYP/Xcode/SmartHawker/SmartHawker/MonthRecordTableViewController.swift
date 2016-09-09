//
//  MonthRecordTableViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 28/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class MonthRecordTableViewController: UITableViewController {
    @IBOutlet weak var back: UIBarButtonItem!
    
    // MARK: Properties
    // Variables
    var shared = ShareData.sharedInstance
    var records = [PFObject]()
    let recordController = RecordController()
    var sections = [String]()
    var rows = [[PFObject]]()
    
    // View will appear
    override func viewWillAppear(animated: Bool) {
        
        // Remove all from all arrays to prevent duplication
        back.title = "Back".localized()
        records.removeAll()
        sections.removeAll()
        rows.removeAll()
        
        // Load records
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
        
        // Populate into sections
        sections = [String]()
        
        // Get the month selected
        var monthDate = shared.monthSelected
        if (monthDate == nil) {
            monthDate = NSDate()
        }
        let calendar = NSCalendar.currentCalendar()
        var components = calendar.components([.Day , .Month , .Year], fromDate: monthDate)
        let month = components.month
        
        // Save the date into sections
        for record in records {
            let dateString = record["date"] as! String
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let date = dateFormatter.dateFromString(dateString)
            components = calendar.components([.Day , .Month , .Year], fromDate: date!)
            let recordMonth = components.month
            if (month == recordMonth) {
                if (sections.contains(dateString) == false) {
                    sections.append(dateString)
                }
            }
            
        self.navigationController?.topViewController?.title="Monthly Record".localized();
        }
        
        // Sort the section array to be increasing date.
        sections.sortInPlace(before)
        
        // Save the rows.
        for sectionStr in sections {
            var sectionRecord = [PFObject]()
            for record in records {
                let date = record["date"] as! String
                if (date == sectionStr) {
                    sectionRecord.append(record)
                }
            }
            sectionRecord.sortInPlace({$1["type"] as! Int > $0["type"] as! Int})
            rows.append(sectionRecord)
        }
        
//        // Sort the records by types
//        for i in 0...rows.count-1 {
//            print(i)
//            var currentSection = rows[i]
//            print("BEFORE")
//            print(currentSection)
//            currentSection.sortInPlace({$0["type"] as! Int > $1["type"] as! Int})
//            print("AFTER")
//            print(currentSection)
//        }
        tableView.reloadData()
    }
    
    //  Back
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows[section].count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecordTableViewCell
        
        // Description Label
        var description = rows[indexPath.section][indexPath.row]["description"] as? String
        if (description == "") {
            description = "No description"
        }
        cell.descriptionLabel.text = description
        
        // Amount Label
        let amount = rows[indexPath.section][indexPath.row]["amount"] as! Double
        let amountString2dp = "$" + String(format:"%.2f", amount)
        cell.amountLabel.text = amountString2dp
        
        // Type Label
        let type = rows[indexPath.section][indexPath.row]["type"] as! Int
        var typeString = ""
        if (type == 0) {
            typeString = "Sales"
        } else if (type == 1) {
            typeString = "COGS"
        } else if (type == 2) {
            typeString = "Expenses"
        }
        cell.recordTypeLabel.text = typeString.localized()
        
        // Recorded by
        var recordedBy = rows[indexPath.section][indexPath.row]["subuser"] as? String
        recordedBy = "By: " + recordedBy!
        cell.recordedByLabel.text = recordedBy
        
        // Cell background
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)

        
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedRecord = rows[indexPath.section][indexPath.row]
        shared.selectedRecord = selectedRecord
        let storyboard = UIStoryboard(name: "Recording", bundle: nil)
        let updateRecordVC = storyboard.instantiateViewControllerWithIdentifier("updateRecord")
        self.presentViewController(updateRecordVC, animated: true, completion: nil)
    }
    
    // For sorting array in ascending order.
    func before(value1: String, value2: String) -> Bool {
        return value1 < value2;
    }
}
