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
    
    // Controllers
    let adminPINController = AdminPINController()
    
    // Variables
    typealias CompletionHandler = (success:Bool) -> Void
    let user = PFUser.currentUser()
    var shared = ShareData.sharedInstance
    var PINS = [String]()
    var subuser = "Standard Sub User"
    var records = []
    var dates = [String:[String]]()
    var objectRecords = [PFObject]()
    
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
        
        // Activity Indicator
        shared.dateString = nil
        submitButton.setTitle("Submit".localized(), forState: .Normal)
        cancelAndLogout.setTitle("Cancel and logout".localized(), forState: .Normal)
        adminPINTextField.placeholder = "Enter your PIN here".localized()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let justLoggedIn = defaults.boolForKey("justLoggedIn")
        if (justLoggedIn == true) {
            
            // Set first time logged in to False, so this popup appears only once, when you just logged in.
            defaults.setBool(false, forKey: "justLoggedIn")
            let alertController = UIAlertController(title: "Welcome", message: "Do you want to retrieve past records online?", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
                
                // Pop up telling the user that you are currently syncing
                let popup = UIAlertController(title: "Syncing", message: "Please wait.", preferredStyle: .Alert)
                self.presentViewController(popup, animated: true, completion: {
                    let syncSucceed = self.adminPINController.sync()
                    if (syncSucceed) {
                        
                        // Retrieval succeed, inform the user that records are synced.
                        popup.dismissViewControllerAnimated(true, completion: {
                            let alertController = UIAlertController(title: "Retrieval Complete!", message: "Please proceed.", preferredStyle: .Alert)
                            let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                            alertController.addAction(ok)
                            self.presentViewController(alertController, animated: true,completion: nil)
                        })
                        
                    } else {
                        
                        // Retrieval failed, inform user that he can sync again after he log in.
                        popup.dismissViewControllerAnimated(true, completion: {
                            let alertController = UIAlertController(title: "Retrieval Failed!", message: "You may sync your data again at settings page.", preferredStyle: .Alert)
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
    }
    
    // MARK: Action
    @IBAction func submitPIN(sender: UIButton) {
        
        let adminPin = user!["adminPin"] as! String
        let pinEntered = adminPINTextField.text
        
        let pinType = adminPINController.submitPIN(pinEntered!, adminPIN: adminPin)
        if (pinType == 2) {
            
            // Invalid PIN, inform the user that the PIN entered is incorrect.
            adminPINTextField.text = ""
            adminPINTextField.attributedPlaceholder = NSAttributedString(string:"Incorrect PIN".localized(), attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            
        } else {
            
            // Load dates with records into calendar.
            adminPINController.loadDatesToCalendar()
            self.performSegueWithIdentifier("toMain", sender: self)
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        // Logs the user out if they are click Cancel
        PFUser.logOutInBackground()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
