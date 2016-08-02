//
//  AdminPINViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 16/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class AdminPINViewController: UIViewController {
    
    // MARK: Properties
    // Variables
    typealias CompletionHandler = (success:Bool) -> Void
    let user = PFUser.currentUser()
    var shared = ShareData.sharedInstance
    var PINS = [String]()
    
    // Text Fields
    @IBOutlet weak var adminPINTextField: UITextField!
    
    // Buttons
    @IBOutlet weak var cancelAndLogout: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    // Labels
    @IBOutlet weak var adminPINLabel: UILabel!
    
    // Nav Bar
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.topItem!.title = "Enter Admin PIN".localized()
        submitButton.setTitle("Submit".localized(), forState: .Normal)
        cancelAndLogout.setTitle("Cancel and logout".localized(), forState: .Normal)
        adminPINLabel.text = "Admin PIN".localized()
        adminPINTextField.placeholder = "Enter your PIN here".localized()
        
        // Getting PINS for the subuser of current logged in user.
        let defaults = NSUserDefaults()
        PINS = (defaults.objectForKey("allPINS") as? [String])!
        print(PINS)
        
    }
    
    // MARK: Action
    @IBAction func submitPIN(sender: UIButton) {
        // Check if the PIN is correct
        let pin = user!["adminPin"]
        if ((pin as! String == adminPINTextField.text!) == true) {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let firstTimeLogin = defaults.boolForKey("firstTimeLogin")
            if (firstTimeLogin == true) {
                let alertController = UIAlertController(title: "Welcome", message: "Do you want to retrieve past records online?", preferredStyle: .Alert)
                let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
                    
                    self.loadRecordsIntoLocalDatastore({ (success) -> Void in
                        if (success) {
                            defaults.setBool(false, forKey: "firstTimeLogin")
                            self.performSegueWithIdentifier("toMain", sender: self)
                        } else {
                            print("Retrieval failed!")
                        }
                    })
                    
                })
                let cancel = UIAlertAction(title: "No", style: .Cancel) { (action) -> Void in
                    defaults.setBool(false, forKey: "firstTimeLogin")
                    self.performSegueWithIdentifier("toMain", sender: self)
                }
                alertController.addAction(ok)
                alertController.addAction(cancel)
                presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.performSegueWithIdentifier("toMain", sender: self)
            }
        } else if (PINS.contains(adminPINTextField.text!)) {
            // Sub User logging-in
            self.shared.isSubUser = true
            self.performSegueWithIdentifier("toMain", sender: self)
        } else {
            // Validate if admin pin entered is the one registered.
            adminPINTextField.text = ""
            adminPINTextField.attributedPlaceholder = NSAttributedString(string:"Incorrect PIN".localized(), attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        // Logs the user out if they are click Cancel
        PFUser.logOutInBackground()
        self.performSegueWithIdentifier("backToWelcome", sender: self)
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
}
