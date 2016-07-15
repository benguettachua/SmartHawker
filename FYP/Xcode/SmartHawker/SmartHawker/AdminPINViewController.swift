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
    @IBOutlet weak var adminPINTextField: UITextField!
    let user = PFUser.currentUser()
    
    // MARK: Action
    @IBAction func submitPIN(sender: UIButton) {
        // Check if the PIN is correct
        let pin = user!["adminPin"]
        if ((pin as! String == adminPINTextField.text!) == false) {
            // Validate if admin pin entered is the one registered.
            adminPINTextField.text = ""
            adminPINTextField.attributedPlaceholder = NSAttributedString(string:"Incorrect PIN", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        } else {
            self.performSegueWithIdentifier("toMain", sender: self)
        }
    }
    
}
