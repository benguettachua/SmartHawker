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
        let confirmPassword = confirmPasswordTextField.text
        let adminPIN = adminPINTextField.text
        
        // Shows a popup to inform the user that the registration is currently being processed.
        let registeringAlert = UIAlertController(title: "Registration", message: "Processing your registration, please wait.", preferredStyle: .Alert)
        self.presentViewController(registeringAlert, animated: true) {
            let registerSuccess = self.registrationController.register(name!, username: username!, email: email!, phone: phone!, password: password!, confirmPassword: confirmPassword!, adminPIN: adminPIN!)
            if (registerSuccess == 0) {
                
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
                
                // Registration failed, show the respective error message in a popup to notify user.
                var errorMsg = ""
                switch registerSuccess {
                case 1:
                    errorMsg = "Name cannot be empty."
                    break
                    
                case 2:
                    errorMsg = "Username cannot be empty."
                    break
                    
                case 3:
                    errorMsg = "Email cannot be empty."
                    break
                    
                case 4:
                    errorMsg = "Phone number cannot be empty."
                    break
                    
                case 5:
                    errorMsg = "Please enter a valid Singapore phone number."
                    break
                    
                case 6:
                    errorMsg = "Password cannot be empty."
                    break
                    
                case 7:
                    errorMsg = "Password does not match confirm password."
                    break
                    
                case 8:
                    errorMsg = "Admin PIN cannot be empty."
                    break
                    
                case 9:
                    errorMsg = "Admin PIN must be 4 digits long."
                    break
                    
                case 100:
                    errorMsg = "No network detected."
                    break
                    
                case 202:
                    errorMsg = "Username is taken."
                    break
                    
                case 203:
                    errorMsg = "Email is taken."
                    break
                    
                default:
                    errorMsg = "Unknown error, please try again."
                    break
                }
                
                registeringAlert.dismissViewControllerAnimated(true, completion: {
                    let failAlert = UIAlertController(title: "Registration Failed", message: errorMsg, preferredStyle: .Alert)
                    failAlert.addAction(UIAlertAction(title: "Try again.", style: .Default, handler: nil))
                    self.presentViewController(failAlert, animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}