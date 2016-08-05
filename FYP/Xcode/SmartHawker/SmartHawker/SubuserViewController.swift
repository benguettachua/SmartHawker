//
//  SubuserViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 5/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class SubuserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    let user = PFUser.currentUser()
    var subusers = [PFObject]()
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveSubuser()
        tableView!.delegate = self
        tableView!.dataSource = self
        self.viewWillAppear(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.viewDidLoad()
    }
    
    // Retrieve all subusers.
    func retrieveSubuser() {
        
        let query = PFQuery(className: "SubUser")
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: user!)
        do{
            subusers = try query.findObjects()
        } catch {
            print("Something wrong")
        }
    }
    // Below this comment are all the methods for table.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subusers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SubuserCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SubuserTableViewCell
        
        // Address
        let address = subusers[indexPath.row]["address"]
        cell.businessAddressLabel.text = address as? String
        // Name
        let name = subusers[indexPath.row]["name"]
        cell.subuserNameLabel.text = name as? String
        // Profile Pic
        cell.userProfilePicImageView.image = UIImage(named: "defaultProfilePic")
        
        // Cell background transparent
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Clicked on row: " + String(indexPath.row))
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
        }
    }
}
