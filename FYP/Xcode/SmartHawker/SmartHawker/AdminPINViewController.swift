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
        
        // Getting PINS for the subuser of current logged in user.
        let defaults = NSUserDefaults()
        if defaults.objectForKey("allPINS") == nil{
            let defaults = NSUserDefaults.standardUserDefaults()
            let adminPins = [String]()
            defaults.setObject(adminPins, forKey: "allPINS")
        }
        PINS = (defaults.objectForKey("allPINS") as? [String])!
        print(PINS)
    }
    
    override func viewDidAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        let justLoggedIn = defaults.boolForKey("justLoggedIn")
        if (justLoggedIn == true) {
            // Set first time logged in to False, so this popup appears only once, when you just logged in.
            defaults.setBool(false, forKey: "justLoggedIn")
            let alertController = UIAlertController(title: "Welcome", message: "Do you want to retrieve past records online?", preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Yes", style: .Default, handler: { (action) -> Void in
                
                self.saveRecordsIntoDatabase({ (success) -> Void in
                    if (success) {
                        self.loadRecordsIntoLocalDatastore({ (success) -> Void in
                            if (success) {
                                let alertController = UIAlertController(title: "Retrieval Complete!", message: "Please proceed.", preferredStyle: .Alert)
                                let ok = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                                alertController.addAction(ok)
                                self.presentViewController(alertController, animated: true,completion: nil)
                            } else {
                                print("Retrieval failed!")
                            }
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
        // Check if the PIN is correct
        let pin = user!["adminPin"]
        if ((pin as! String == adminPINTextField.text!) == true) {
            // Admin logs in
            self.performSegueWithIdentifier("toMain", sender: self)
            
        } else if (PINS.contains(adminPINTextField.text!)) {
            // Sub User logging-in
            
            self.shared.isSubUser = true
            getSubuser(adminPINTextField.text!, completionHandler: { (success) in
                self.shared.subuser = self.subuser
                self.loadDatesToCalendar()
                self.performSegueWithIdentifier("toMain", sender: self)
            })

        } else {
            // Validate if admin pin entered is the one registered.
            adminPINTextField.text = ""
            adminPINTextField.attributedPlaceholder = NSAttributedString(string:"Incorrect PIN".localized(), attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        // Logs the user out if they are click Cancel
        PFUser.logOutInBackground()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadDatesToCalendar(){
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        do{
            let array = try query.findObjects()
            // subuser is found, proceed to delete.
            for object in array {
                let dateString = object["date"] as! String
                let subuserName = object["subuser"] as! String
                if self.dates[subuserName] == nil{
                    let array = [dateString]
                    self.dates.updateValue(array, forKey: subuserName)
                }else{
                    var array = self.dates[subuserName]
                    array?.append(dateString)
                    self.dates.updateValue(array!, forKey: subuserName)
                }
                
            }
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(self.dates[subuser], forKey: "SavedDateArray")
        
        } catch {}

        
    }
    


    func loadRecordsIntoLocalDatastore(completionHandler: CompletionHandler) {
        // Part 1: Load from DB and pin into local datastore.
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Pin records found into local datastore.
                PFObject.pinAllInBackground(objects)
                for object in objects! {
                    self.objectRecords.append(object)
                    
                }
                completionHandler(success: true)
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
    }
    
    func getSubuser(pin: String, completionHandler: CompletionHandler){
        let query = PFQuery(className: "SubUser")
        query.whereKey("pin", equalTo: pin)
        query.whereKey("user", equalTo: user!)
        query.fromLocalDatastore()
        query.getFirstObjectInBackgroundWithBlock {
            (object: PFObject?, error: NSError?) in
            if error == nil {
                self.subuser = String(object!["name"])
                completionHandler(success: true)
            } else {
                print("retrieval failed")
            }
        }
    }
    
    
    func saveRecordsIntoDatabase(completionHandler: CompletionHandler) {
        let query = PFQuery(className: "Record")
        let isSubUser = shared.isSubUser
        if (isSubUser) {
            query.whereKey("subuser", equalTo: shared.subuser)
        }
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
    }
    
}
