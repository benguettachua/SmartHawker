//
//  SyncViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class ProfileViewController: UITableViewController {
    // MARK: Properties
    // Image View
    @IBOutlet weak var profilePicture: UIImageView!
    
    // Label
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var rightprofile: UILabel!
    
    @IBOutlet weak var rightsync: UILabel!
    
    
    @IBOutlet weak var rightsetting: UILabel!
    
    
    @IBOutlet weak var syncicon: UILabel!
    
    
    @IBOutlet weak var settingicon: UILabel!
    // Variables
    let user = PFUser.currentUser()
    
    // MARK: Action
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Load the Top Bar
        let user = PFUser.currentUser()
        // Populate the top bar
        if user != nil{
            var name = user!["name"]
            if (name == nil) {
                name = "No name"
            }
            let nameString = name as! String
            let phoneNumber = user!["phoneNumber"] as! String
            profileName.text! = nameString + "\r\n" + phoneNumber
            
            
            // Getting the profile picture
            if let userPicture = user!["profilePicture"] as? PFFile {
                userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        self.profilePicture.image = UIImage(data: imageData!)
                    }
                }
            }
        }
        
        var faicon = [String: UniChar]()
        faicon["faright"] = 0xf105
        faicon["fasync"] = 0xf021
        faicon["fasetting"] = 0xf013

        rightprofile.font = UIFont(name: "FontAwesome", size: 20)
        
        rightprofile.text = String(format: "%C", faicon["faright"]!)
    
        rightsync.font = UIFont(name: "FontAwesome", size: 20)
        
        rightsync.text = String(format: "%C", faicon["faright"]!)
        
        rightsetting.font = UIFont(name: "FontAwesome", size: 20)
        
        rightsetting.text = String(format: "%C", faicon["faright"]!)
        
        syncicon.font = UIFont(name: "FontAwesome", size: 20)
        
        syncicon.text = String(format: "%C", faicon["fasync"]!)
        
        settingicon.font = UIFont(name: "FontAwesome", size: 20)
        
        settingicon.text = String(format: "%C", faicon["fasetting"]!)
        
        
    }
    func syncData() {
        let alertController = UIAlertController(title: "Sync Records", message: "Are you sure?", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            
            // Pop up telling the user that you are currently syncing
            let popup = UIAlertController(title: "Syncing", message: "Please wait.", preferredStyle: .Alert)
            self.presentViewController(popup, animated: true, completion: {
                let syncSucceed = ProfileController().sync()
                if (syncSucceed) {
                    
                    // Retrieval succeed, inform the user that records are synced.
                    popup.dismissViewControllerAnimated(true, completion: {
                        let alertController = UIAlertController(title: "Sync Complete!", message: "Please proceed.", preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                        alertController.addAction(ok)
                        self.presentViewController(alertController, animated: true,completion: nil)
                    })
                    
                } else {
                    
                    // Retrieval failed, inform user that he can sync again after he log in.
                    popup.dismissViewControllerAnimated(true, completion: {
                        let alertController = UIAlertController(title: "Sync Failed!", message: "Please try again later.", preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                        alertController.addAction(ok)
                        self.presentViewController(alertController, animated: true,completion: nil)
                    })
                }
            })
        })
        let no = UIAlertAction(title: "No", style: .Cancel, handler: nil)
        alertController.addAction(ok)
        alertController.addAction(no)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
//    @IBAction func Logout(sender: UIBarButtonItem) {
//        let refreshAlert = UIAlertController(title: "Logout".localized(), message: "Are You Sure?".localized(), preferredStyle: UIAlertControllerStyle.Alert)
//        
//        refreshAlert.addAction(UIAlertAction(title: "Yes".localized(), style: .Default, handler: { (action: UIAlertAction!) in
//            ProfileController().logout()
//        }))
//        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { (action: UIAlertAction!) in
//            
//            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
//            
//            
//        }))
//        
//        presentViewController(refreshAlert, animated: true, completion: nil)
//        
//        
//    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Do something depending on which row is selected.
        let selectedRow = indexPath.row
        let section = indexPath.section
        
        // User click the profile bar
        if (section == 0) {
            self.performSegueWithIdentifier("editProfile", sender: self)
        }
        
        // User click Sync or Settings
        if (section == 1) {
            // Sync
            if (selectedRow == 0) {
                syncData()
            }
            // Setting
            if (selectedRow == 1) {
                self.performSegueWithIdentifier("toSettings", sender: self)
            }
        }
    }


}
