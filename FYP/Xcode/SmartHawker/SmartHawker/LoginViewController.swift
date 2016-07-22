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
    var errorMsg = String()
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var loginNavBar: UINavigationBar!
    @IBAction func loginButton(sender: UIButton) {
        
        PFUser.logInWithUsernameInBackground(usernameOrEmailTextField.text!, password: passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                
                // Do stuff after successful login.
                self.toShare.password = self.passwordTextField.text!
                self.errorMessageLabel.text = "Logging in...".localized()
                self.errorMessageLabel.hidden = false
                self.performSegueWithIdentifier("loginSuccess", sender: self)
            } else {
                
                // There was a problem, show user the error message.
                
                self.errorMessageLabel.text = error?.localizedDescription
                if self.errorMessageLabel.text!.containsString("invalid"){
                    self.errorMessageLabel.text = "Invalid Login Credentials".localized()
                }
               self.errorMessageLabel.textColor = UIColor.redColor()
               self.errorMessageLabel.hidden = false
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        
        usernameOrEmailTextField.placeholder = "Username or Email".localized()
        passwordTextField.placeholder = "Password".localized()
        loginNavBar.topItem!.title = "Login".localized()
        login.setTitle("Login".localized(), forState: .Normal)
        back.title = "Back".localized()
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
}
