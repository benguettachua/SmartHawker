//
//  RegistrationViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 19/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit


class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    // Variables
    var ok = 0
    let registrationController = RegistrationController()
    let loginController = LoginController()
    
    // Text Fields
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var adminPINTextField: UITextField!
    
    // MARK: Action
    @IBAction func registerAccount(sender: UIButton) {
        
        // Variables to register account.
        let name = nameTextField.text
        let username = usernameTextField.text
        let email = emailTextField.text?.lowercaseString
        let phone = phoneNumberTextField.text
        let password = passwordTextField.text
        let adminPIN = adminPINTextField.text
        
        // Shows a popup to inform the user that the registration is currently being processed.
        let registeringAlert = UIAlertController(title: "Registration", message: "Processing your registration, please wait.", preferredStyle: .Alert)
        self.presentViewController(registeringAlert, animated: true) {
            let registerSuccess = self.registrationController.register(name!, username: username!, email: email!, phone: phone!, password: password!, adminPIN: adminPIN!)
            if (registerSuccess) {
                
                // Register success, dismiss the processing registration popup and show a popup to inform user that registration succeeded.
                registeringAlert.dismissViewControllerAnimated(true, completion: {
                    
                    // This array populates the calendar for any dates with record. For a new user, there should not be any records.
                    let array = [String]()
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(array, forKey: "SavedDateArray")
                    
                    // Popup to show that registration succeeded.
                    let alert = UIAlertController(title: "Registration Successful", message: "Congratulations, you have created a new Account!", preferredStyle: UIAlertControllerStyle.Alert)
                    
                    // Once the user clicks "Ok", he will be directed to Home tab.
                    alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { Void in
                        self.performSegueWithIdentifier("registerSuccess", sender: self)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                
            } else {
                
                // Registration failed
                registeringAlert.dismissViewControllerAnimated(true, completion: {
                    let failAlert = UIAlertController(title: "Registration Failed", message: "Please ensure all fields are entered. \r\n and \r\n Username must be unique. \r\n and \r\n Email must be unique.", preferredStyle: .Alert)
                    failAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                    self.presentViewController(failAlert, animated: true, completion: nil)
                })
                // There was a problem, show user the error message.
                /*let errorMsg = error?.localizedDescription
                 var msgToShow = String()
                 if (errorMsg?.containsString("username") == true) {
                 msgToShow = "Username is taken. Please try again.".localized()
                 self.usernameTextField.text = ""
                 self.usernameTextField.attributedPlaceholder = NSAttributedString(string:"Enter new Username".localized(), attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
                 
                 } else if (errorMsg?.containsString("invalid") == true) {
                 msgToShow = "Invalid email address. Please try again.".localized()
                 self.emailTextField.text = ""
                 self.emailTextField.attributedPlaceholder = NSAttributedString(string:"Enter new Email".localized(), attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
                 
                 } else if (errorMsg?.containsString("email") == true) {
                 msgToShow = "Email is taken. Please try again.".localized()
                 self.emailTextField.text = ""
                 self.emailTextField.attributedPlaceholder = NSAttributedString(string:"Enter new Email".localized(), attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
                 }
                 let alert = UIAlertController(title: "Edit Unsuccessful", message: msgToShow, preferredStyle: UIAlertControllerStyle.Alert)
                 alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                 
                 self.presentViewController(alert, animated: true, completion: nil)*/
            }
        }
        
    }
}