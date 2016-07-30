//
//  RecordDayViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 30/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class RecordDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    @IBOutlet weak var dayNumberLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var monthYearLabel: UILabel!
    var shared = ShareData.sharedInstance
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var storeDate = shared.storeDate
        // Populate the view
        dayNumberLabel.text = String(storeDate.day)
        dayLabel.text = storeDate.weekdayName
        monthYearLabel.text = (storeDate.monthName + ", " + String(storeDate.year))
        
        tableView!.delegate = self
        tableView!.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any recourses that can be recreated.
    }
    
    // MARK: Action
    @IBAction func nextDay(sender: UIButton) {
        print("Go next day")
    }
    @IBAction func previousDay(sender: UIButton) {
        print("Go previous day")
    }
    
    
    // Below this comment are all the methods for table.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RecordCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecordTableViewCell
        
        cell.descriptionLabel.text = "Test"
        cell.amountLabel.text = "test"
        cell.recordTypeLabel.text = "TTT"
        
        cell.backgroundColor = UIColor.lightGrayColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Clicked on row: " + String(indexPath.row))
        self.performSegueWithIdentifier("editRecord", sender: self)
    }
    
    
}
