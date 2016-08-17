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
    
    // Controllers
    let subuserController = SubuserController()
    
    // Text Field
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var PINTextField: UITextField!
    
    // MARK: Action
    @IBAction func addSubUser(sender: UIButton) {
        
        let name = nameTextField.text
        let address = addressTextField.text
        let pin = PINTextField.text
        
        let processingAlert = UIAlertController(title: "Processing", message: "Adding subuser, please wait.", preferredStyle: .Alert)
        self.presentViewController(processingAlert, animated: true) {
            let addSucess = self.subuserController.addNewSubuser(name!, address: address!, pin: pin!)
            
            if (addSucess) {
                
                // Dismiss the processing alert and inform success.
                processingAlert.dismissViewControllerAnimated(true, completion: {
                    
                    // Subuser is added successfully, popup to inform success.
                    let successAlert = UIAlertController(title: "Success", message: "Subuser has been added.", preferredStyle: .Alert)
                    successAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { Void in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    self.presentViewController(successAlert, animated: true, completion: nil)
                })
                
            } else {
                
                // Dismiss the processing alert and inform fail.
                processingAlert.dismissViewControllerAnimated(true, completion: {
                    
                    // Subuser is added failed, popup to inform fail.
                    let successAlert = UIAlertController(title: "Failed", message: "Please try again later.", preferredStyle: .Alert)
                    successAlert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: nil))
                    self.presentViewController(successAlert, animated: true, completion: nil)
                })
            }
        }
    }
    
    // Back
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
