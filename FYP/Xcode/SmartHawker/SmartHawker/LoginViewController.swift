//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var usernameOrEmailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    var toShare = ShareData.sharedInstance
    
    @IBAction func loginButton(sender: UIButton) {
        
        PFUser.logInWithUsernameInBackground(usernameOrEmailTextField.text!, password: passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                
                // Do stuff after successful login.
                self.toShare.password = self.passwordTextField.text!
                self.errorMessageLabel.text = "Logging in..."
                self.errorMessageLabel.hidden = false
                self.performSegueWithIdentifier("loginSuccess", sender: self)
            } else {
                
                // There was a problem, show user the error message.
                self.errorMessageLabel.text = error?.localizedDescription
                self.errorMessageLabel.textColor = UIColor.redColor()
                self.errorMessageLabel.hidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
