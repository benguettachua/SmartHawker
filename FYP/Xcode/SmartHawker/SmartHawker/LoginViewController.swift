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
    // Controller
    let loginController = LoginController()
    
    // Variables
    var toShare = ShareData.sharedInstance
    var errorMsg = String()
    typealias CompletionHandler = (success:Bool) -> Void
    
    // Text Fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Action
    // This function is called when the user clicks log in at the login page.
    @IBAction func login(sender: UIButton) {
        
        // There is an alert to inform the user that it is currently logging in.
        let loggingInAlert = UIAlertController(title: "Logging In", message: "Please wait.", preferredStyle: .Alert)
        self.presentViewController(loggingInAlert, animated: true, completion: {
            let username = self.usernameTextField.text
            let password = self.passwordTextField.text
            
            // Calls controller to log in using the entered parameters.
            let loginSuccess = self.loginController.login(username!, password: password!)
            if (loginSuccess) {
                
                // Logging in success, logging in alert is dissmissed, scene is moved to admin page.
                loggingInAlert.dismissViewControllerAnimated(false, completion: {
                    self.performSegueWithIdentifier("loginSuccess", sender: self)
                })
            } else {
                
                // Logging in failed, logging in alert is dismissed, login failed alert is shown
                loggingInAlert.dismissViewControllerAnimated(false, completion: {
                    let alert = UIAlertController(title: "Error", message: "Login not successful, please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }
        })
    }
    
    // This function is called when the user clicks on forget password at the login page.
    @IBAction func forgetPassword(sender: UIButton) {
        
        // An alert window will pop up asking the user to enter their email.
        let alert = UIAlertController(title: "Forget password", message: "Enter your email", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (Void) in
            let emailTextField = alert.textFields![0] as UITextField
            let email = emailTextField.text
            
            // Upon clicking "Send" from the pop up, this alert will show to inform the user that the server is now sending mail to their email.
            let sendingMailAlert = UIAlertController(title: "Sending mail", message: "Please wait.", preferredStyle: .Alert)
            self.presentViewController(sendingMailAlert, animated: true, completion: {
                
                let emailSent = self.loginController.forgetPassword(email!)
                if (emailSent) {
                    
                    // Sending mail success, the user will receive an email to change their password.
                    sendingMailAlert.dismissViewControllerAnimated(true, completion: {
                        let successAlert = UIAlertController(title: "Success", message: "Password change have been sent to: " + emailTextField.text!.lowercaseString, preferredStyle: .Alert)
                        successAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(successAlert, animated: true, completion: nil)
                    })
                } else {
                    
                    // Sending mail failed, the user will see this pop up notifying them to try again later.
                    sendingMailAlert.dismissViewControllerAnimated(true, completion: {
                        let failAlert = UIAlertController(title: "Failed", message: "An error has occured, please try again later.", preferredStyle: .Alert)
                        failAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                        self.presentViewController(failAlert, animated: true, completion: nil)
                    })
                    
                }
            })
        }))
        alert.addTextFieldWithConfigurationHandler({ (emailTextField) in
            emailTextField.placeholder = "Enter your email"
            emailTextField.keyboardType = UIKeyboardType.EmailAddress
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        usernameTextField.placeholder = "Username".localized()
        passwordTextField.placeholder = "Password".localized()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
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
    
    func getSubUserPINs(user: PFUser, completionHandler: CompletionHandler) {
        let query = PFQuery(className: "SubUser")
        query.whereKey("user", equalTo: user)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            var PINS = [String]()
            if error == nil {
                PFObject.pinAllInBackground(objects)
                for object in objects! {
                    let PIN = object["pin"] as! String
                    PINS.append(PIN)
                    
                }
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(PINS, forKey: "allPINS")
                completionHandler(success: true)
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
    }
    
}
