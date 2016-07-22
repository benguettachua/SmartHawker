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
    
    @IBOutlet weak var cancelAndLogout: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var adminPINLabel: UILabel!
    @IBOutlet weak var navBar: UINavigationBar!
    //viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        navBar.topItem!.title = "Enter Admin PIN".localized()
        submitButton.setTitle("Submit".localized(), forState: .Normal)
        cancelAndLogout.setTitle("Cancel and logout".localized(), forState: .Normal)
        adminPINLabel.text = "Admin PIN".localized()
        adminPINTextField.placeholder = "Enter your PIN here".localized()
    }
    
    // MARK: Action
    @IBAction func submitPIN(sender: UIButton) {
        // Check if the PIN is correct
        let pin = user!["adminPin"]
        if ((pin as! String == adminPINTextField.text!) == false) {
            // Validate if admin pin entered is the one registered.
            adminPINTextField.text = ""
            adminPINTextField.attributedPlaceholder = NSAttributedString(string:"Incorrect PIN".localized(), attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
        } else {
            self.performSegueWithIdentifier("toMain", sender: self)
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        // Logs the user out if they are click Cancel
        PFUser.logOutInBackground()
        self.performSegueWithIdentifier("backToWelcome", sender: self)
    }
}
