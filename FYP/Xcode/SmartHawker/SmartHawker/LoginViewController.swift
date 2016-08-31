//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import Material
import FontAwesome_iOS

class LoginViewController: UIViewController {
    
    // MARK: Properties
    // Controller
    let loginController = LoginController()
    
    // Text Fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var mobileicon: UILabel!
    @IBOutlet weak var passwordicon: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var smarthawkerLogo: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    // Shared Data
    let shared = ShareData.sharedInstance
    // MARK: Action
    // This function is called when the user clicks log in at the login page.
    @IBAction func login(sender: UIButton) {
        if connectionDAO().isConnectedToNetwork(){
        // There is an alert to inform the user that it is currently logging in.
        let loggingInAlert = UIAlertController(title: "Logging In".localized(), message: "Please wait.".localized(), preferredStyle: .Alert)
        self.presentViewController(loggingInAlert, animated: true, completion: {
            let username = self.usernameTextField.text
            let password = self.passwordTextField.text
            
            // Calls controller to log in using the entered parameters.
            let loginSuccess = self.loginController.login(username!, password: password!)
            if (loginSuccess) {
                
                self.shared.clearData()
                
                // Set just logged in to true to prompt to retrieve record
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "justLoggedIn")
                
                // Pin all subusers of this account to local datastore
                self.loginController.pinSubusers()
                
                // Logging in success, logging in alert is dissmissed, scene is moved to admin page.
                loggingInAlert.dismissViewControllerAnimated(false, completion: {
                    self.performSegueWithIdentifier("loginSuccess", sender: self)
                })
            } else {
                
                // Logging in failed, logging in alert is dismissed, login failed alert is shown
                loggingInAlert.dismissViewControllerAnimated(false, completion: {
                    let alert = UIAlertController(title: "Error".localized(), message: "Login not successful, please try again.".localized(), preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Close".localized(), style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        })
        }else{
            let alert = UIAlertController(title: "Internet Connection is down.".localized(), message: "Login not successful, please try again.".localized(), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close".localized(), style: UIAlertActionStyle.Default, handler: nil))
        }
    }
    
    // This function is called when the user clicks on forget password at the login page.
    @IBAction func forgetPassword(sender: UIButton) {
        
        // An alert window will pop up asking the user to enter their email.
        let alert = UIAlertController(title: "Forgot password".localized(), message: "Enter your email".localized(), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Send".localized(), style: .Default, handler: { (Void) in
            let emailTextField = alert.textFields![0] as UITextField
            let email = emailTextField.text
            
            // Upon clicking "Send" from the pop up, this alert will show to inform the user that the server is now sending mail to their email.
            let sendingMailAlert = UIAlertController(title: "Sending mail".localized(), message: "Please wait.".localized(), preferredStyle: .Alert)
            self.presentViewController(sendingMailAlert, animated: true, completion: {
                
                let emailSent = self.loginController.forgetPassword(email!)
                if (emailSent) {
                    
                    // Sending mail success, the user will receive an email to change their password.
                    sendingMailAlert.dismissViewControllerAnimated(true, completion: {
                        let successAlert = UIAlertController(title: "Success".localized(), message: "Password change have been sent to: ".localized() + emailTextField.text!.lowercaseString, preferredStyle: .Alert)
                        successAlert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: nil))
                        self.presentViewController(successAlert, animated: true, completion: nil)
                    })
                } else {
                    
                    // Sending mail failed, the user will see this pop up notifying them to try again later.
                    sendingMailAlert.dismissViewControllerAnimated(true, completion: {
                        let failAlert = UIAlertController(title: "Failed".localized(), message: "An error has occured, please try again later.".localized(), preferredStyle: .Alert)
                        failAlert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: nil))
                        self.presentViewController(failAlert, animated: true, completion: nil)
                    })
                    
                }
            })
        }))
        alert.addTextFieldWithConfigurationHandler({ (emailTextField) in
            emailTextField.placeholder = "Enter your email".localized()
            emailTextField.keyboardType = UIKeyboardType.EmailAddress
        })
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        usernameTextField.placeholder = "Username".localized()
        passwordTextField.placeholder = "Password".localized()
        smarthawkerLogo.text? = "SmartHawker © 2016".localized()
        loginButton.setTitle("LOGIN".localized(), forState: UIControlState.Normal)
        forgotPasswordButton.setTitle("Forgot Password", forState: UIControlState.Normal)
        registerLabel.text = "Don't have an account?".localized()
        registerButton.setTitle("Sign Up".localized(), forState: UIControlState.Normal)
        
        var faicon = [String: UniChar]()
        faicon["famobilephone"] = 0xf10b
        faicon["fapassword"] = 0xf023
        
        mobileicon.font = UIFont(name: "FontAwesome", size: 40)
        
        mobileicon.text = String(format: "%C", faicon["famobilephone"]!)
        
        passwordicon.font = UIFont(name: "FontAwesome", size: 40)
        
        passwordicon.text = String(format: "%C", faicon["fapassword"]!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.placeholder = "Username".localized()
        passwordTextField.placeholder = "Password".localized()
    }
    
    override func viewDidAppear(animated: Bool) {
        if (PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("loginSuccess", sender: self)
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
}
