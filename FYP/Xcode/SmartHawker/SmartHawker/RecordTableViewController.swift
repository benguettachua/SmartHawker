//
//  RecordTableViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 10/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

protocol MyCustomerCellDelegator {
    func callSegueFromCell (myData dataobject: AnyObject)
    func backToRecordFromCell()
    func unableToDeleteOrEdit()
}

import UIKit

class RecordTableViewController: UITableViewController, MyCustomerCellDelegator {
    
    // MARK: Properties
    var records = [RecordTable]()
    typealias CompletionHandler = (success:Bool) -> Void
    let user = PFUser.currentUser()
    var shared = ShareData.sharedInstance
    @IBOutlet weak var navBarTitle: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    let sections = ["Sales", "COGS", "Other Expenses"]
    var items: [[RecordTable]] = [[], [], []]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        records = shared.records
        navBarTitle.title = "Records for " + shared.dateString
        navBar.frame = CGRectMake(0, 0, 320, 64)
        
        for record in records {
            if (record.type == "Sales") {
                items[0].append(record)
            } else if (record.type == "COGS") {
                items[1].append(record)
            } else if (record.type == "Expenses") {
                items[2].append(record)
            }
        }
        shared.items = items
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any recourses that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items[section].count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecordTableViewCell
        
        cell.descriptionLabel.text = self.items[indexPath.section][indexPath.row].description
        cell.amountLabel.text = String(self.items[indexPath.section][indexPath.row].amount)
        
        cell.backgroundColor = UIColor.lightGrayColor()
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Futura", size: 38)!
        header.textLabel?.textColor = UIColor.lightGrayColor()
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func callSegueFromCell(myData dataobject: AnyObject) {
        //try not to send self, just to avoid retain cycles(depends on how you handle the code on the next controller)
        self.performSegueWithIdentifier("updateRecord", sender: dataobject )
        
    }
    
    func backToRecordFromCell() {
        
        // Moves back to Record Table View Controller
        self.performSegueWithIdentifier("backToRecord", sender: self)
    }
    
    func unableToDeleteOrEdit() {
        let alertController = UIAlertController(title: "Unable to edit/delete", message: "Record is not saved. Please check your network connection and try again.", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in}
        alertController.addAction(cancel)
        presentViewController(alertController, animated: true, completion: nil)
    }
}
