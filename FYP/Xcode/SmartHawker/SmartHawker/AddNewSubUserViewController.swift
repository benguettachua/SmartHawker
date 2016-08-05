//
//  AddNewSubUserViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 1/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class AddNewSubUserViewController: UIViewController {
    
    // MARK: Properties
    // Text Field
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var PINTextField: UITextField!
    
    // Variables
    let user = PFUser.currentUser()
    var PINS = [String]()
    
    // MARK: Action
    @IBAction func addSubUser(sender: UIButton) {
        let subUser = PFObject(className: "SubUser")
        subUser.ACL = PFACL(user: user!)
        var uniquePin = false
        var validationCounter = 0
        
        if (nameTextField.text?.characters.count > 0) {
            // Validation to see if name is entered.
            validationCounter += 1
        }
        
        if (addressTextField.text?.characters.count > 0) {
            // Validation to see if address is entered.
            validationCounter += 1
        }
        
        if (PINTextField.text?.characters.count == 4) {
            // Validation to insist 4 character for PIN
            validationCounter++
        }
        
        if (validationCounter == 3) {
            // All validation pass
            let pinToRecord = PINTextField.text
            // Sub User Properties
            subUser["user"] = user
            subUser["name"] = nameTextField.text
            if (PINS.contains(pinToRecord!) == false) {
                subUser["pin"] = PINTextField.text
                uniquePin = true
            } else {
                uniquePin = false
            }
            subUser["address"] = addressTextField.text
            if (uniquePin) {
                do{
                    try subUser.save()
                    updateLocalSubuserList()
                    self.dismissViewControllerAnimated(true, completion: nil)
                } catch {
                    // do something to show save failed.
                    let alert = UIAlertController(title: "Save failed", message: "PIN entered is used for another user, PIN must be unique!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                // do something to show save failed.
                let alert = UIAlertController(title: "Save failed", message: "PIN entered is used for another user, PIN must be unique!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Save failed", message: "All fields are required. PIN must be 4 digits, please try again!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Got it!", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // Back
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get all PINS that are used
        let defaults = NSUserDefaults.standardUserDefaults()
        PINS = defaults.objectForKey("allPINS") as! [String]
    }
    
    func updateLocalSubuserList() {
        let query = PFQuery(className: "SubUser")
        var objects = [PFObject]()
        query.whereKey("user", equalTo: user!)
        do {
            objects = try query.findObjects()
            try PFObject.pinAll(objects)
            for object in objects {
                let PIN = object["pin"] as! String
                PINS.append(PIN)
                
            }
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(PINS, forKey: "allPINS")
            
        } catch {
            print("Error")
        }
        
    }
}
