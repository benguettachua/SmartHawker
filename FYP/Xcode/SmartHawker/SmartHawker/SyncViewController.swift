//
//  SyncViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class SyncViewController: UIViewController {
    // MARK: Properties
    // Top Bar
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void
    
    // MARK: Action
    @IBAction func Logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    @IBAction func retrievePastRecord(sender: UIButton) {
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to retrieve records?", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            
            self.loadRecordsIntoLocalDatastore({ (success) -> Void in
                if (success) {
                    let alert = UIAlertController(title: "Retrieval success!", message: "You may continue to use the app.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Retrieval failed!", message: "Please try again later.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            
        })
        let cancel = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in}
        alertController.addAction(ok)
        alertController.addAction(cancel)
        presentViewController(alertController, animated: true, completion: nil)
    
    }

    @IBAction func uploadRecordsOnline(sender: UIButton) {
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want to sync records to database?", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
            
            self.saveRecordsIntoDatabase({ (success) -> Void in
                if (success) {
                    let alert = UIAlertController(title: "Save success!", message: "You may continue to use the app.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Save failed!", message: "Please try again later.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
            
        })
        let cancel = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in}
        alertController.addAction(ok)
        alertController.addAction(cancel)
        presentViewController(alertController, animated: true, completion: nil)
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the Top Bar
        let user = PFUser.currentUser()
        // Populate the top bar
        businessName.text! = user!["businessName"] as! String
        username.text! = user!["username"] as! String
        
        // Getting the profile picture
        if let userPicture = user!["profilePicture"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.profilePicture.image = UIImage(data: imageData!)
                }
            }
        }
        
    }
    
    func loadRecordsIntoLocalDatastore(completionHandler: CompletionHandler) {
        // Part 1: Load from DB and pin into local datastore.
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            var dates = [String]()
            if error == nil {
                // Pin records found into local datastore.
                PFObject.pinAllInBackground(objects)
                for object in objects! {
                    let dateString = object["date"] as! String
                    dates.append(dateString)
                    
                }
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(dates, forKey: "SavedDateArray")
                completionHandler(success: true)
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
    }
    
    func saveRecordsIntoDatabase(completionHandler: CompletionHandler) {
        
        // Remove all records in DB.
       // removeRecordsFromDB { (success) in
        //    if (success) {
                // Save all local records into DB.
                let query = PFQuery(className: "Record")
                query.fromLocalDatastore()
                query.whereKey("user", equalTo: self.user!)
                query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if error == nil {
                        for object in objects! {
                            object.pinInBackground()
                            object.saveInBackground()
                        }
                        completionHandler(success: true)
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                        completionHandler(success: false)
                    }
                }

          //  } else {
            //    print("Failed to delete records.")
           // }
       // }
        
    }
    
    func removeRecordsFromDB(completionHandler: CompletionHandler) {
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                for object in objects! {
                    object.deleteInBackground()
                }
                completionHandler(success: true)
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
    }
}
