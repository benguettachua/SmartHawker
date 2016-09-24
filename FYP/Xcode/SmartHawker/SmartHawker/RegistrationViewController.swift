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
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    // MARK: Action
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.placeholder = "Name".localized()
        usernameTextField.placeholder = "Username".localized()
        passwordTextField.placeholder = "Password".localized()
        confirmPasswordTextField.placeholder = "Confirm Password".localized()
        emailTextField.placeholder = "Email".localized()
        phoneNumberTextField.placeholder = "Phone".localized()
        adminPINTextField.placeholder = "Admin Pin".localized()
        cancelButton.setTitle("Cancel".localized(), forState: UIControlState.Normal)
        registerButton.setTitle("REGISTER".localized(), forState: UIControlState.Normal)
        
    }
    
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
        let registeringAlert = UIAlertController(title: "Registration".localized(), message: "Processing your registration, please wait.".localized(), preferredStyle: .Alert)
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
                    let alert = UIAlertController(title: "Registration Successful".localized(), message: "Congratulations, you have created a new Account!".localized(), preferredStyle: UIAlertControllerStyle.Alert)
                    
                    // Once the user clicks "Ok", he will be directed to Home tab.
                    alert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: { Void in
                        self.performSegueWithIdentifier("registerSuccess", sender: self)
                    }))
                    self.presentViewController(alert, animated: true, completion: nil)
                })
                
            } else {
                
                // Registration failed, show the respective error message in a popup to notify user.
                var errorMsg = ""
                self.checksForEmpty()
                switch registerSuccess {
                case 1:
                    errorMsg = "Name cannot be empty.".localized()
                    break
                    
                case 2:
                    errorMsg = "Username cannot be empty.".localized()
                    break
                    
                case 3:
                    errorMsg = "Email cannot be empty.".localized()
                    break
                    
                case 4:
                    errorMsg = "Phone number cannot be empty.".localized()
                    break
                    
                case 5:
                    errorMsg = "Please enter a valid Singapore phone number.".localized()
                    break
                    
                case 6:
                    errorMsg = "Password Must be more than 8 digits long.".localized()
                    break
                    
                case 7:
                    errorMsg = "Password does not match confirm password.".localized()
                    break
                    
                case 8:
                    errorMsg = "Admin PIN cannot be empty.".localized()
                    break
                    
                case 9:
                    errorMsg = "Admin PIN must be 4 digits long.".localized()
                    break
                    
                case 10:
                    errorMsg = "Username must be more than 5 letters.".localized()
                    break
                    
                case 11:
                    errorMsg = "Username can only consist of number and letters.".localized()
                    
                case 100:
                    errorMsg = "No network detected.".localized()
                    break
                    
                case 202:
                    errorMsg = "Username is taken.".localized()
                    
                    self.usernameTextField.attributedPlaceholder = NSAttributedString(string:"Username taken.",
                                                                                      attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
                    break
                    
                case 203:
                    errorMsg = "Email is taken.".localized()
                    break
                    
                default:
                    errorMsg = "Unknown error, please try again.".localized()
                    break
                }
                
                registeringAlert.dismissViewControllerAnimated(true, completion: {
                    let failAlert = UIAlertController(title: "Registration Failed".localized(), message: errorMsg, preferredStyle: .Alert)
                    failAlert.addAction(UIAlertAction(title: "Try again.".localized(), style: .Default, handler: nil))
                    self.presentViewController(failAlert, animated: true, completion: nil)
                })
            }
        }
    }
    
    @IBAction func cancel(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checksForEmpty(){
        
        let name = nameTextField.text
        let username = usernameTextField.text
        let email = emailTextField.text?.lowercaseString
        let phone = phoneNumberTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        let adminPIN = adminPINTextField.text
        
        if (name == "") {
            nameTextField.attributedPlaceholder = NSAttributedString(string:"Invalid Name.",
                                                                     attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        // Username is not entered
        if (username == "") {
            usernameTextField.attributedPlaceholder = NSAttributedString(string:"Invalid Username.",
                                                                         attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        // Email is not entered
        if (email == "") {
            emailTextField.attributedPlaceholder = NSAttributedString(string:"Invalid Email.",
                                                                      attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        // Phone is not entered
        if (phone == "") {
            phoneNumberTextField.attributedPlaceholder = NSAttributedString(string:"Invalid Phone Number.",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        // Phone does not starts with 8 or 9
        let phoneInt = Int(phone!)
        if (phoneInt < 80000000 || phoneInt > 99999999) {
            phoneNumberTextField.attributedPlaceholder = NSAttributedString(string:"Invalid Phone Numer.",
                                                                            attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        // Password is not entered
        if (password == "" || password!.characters.count < 8) {
            passwordTextField.attributedPlaceholder = NSAttributedString(string:"Invalid Password.",
                                                                         attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        // Password does not match confirm password.
        if (password != confirmPassword || confirmPassword == "" || confirmPassword!.characters.count < 8) {
            confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string:"Invalid Confirm Password.",
                                                                                attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        // Admin PIN is not entered
        if (adminPIN == "") {
            adminPINTextField.attributedPlaceholder = NSAttributedString(string:"Invalid Admin PIN.",
                                                                         attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        // Admin PIN is not 4 digit
        if (adminPIN!.characters.count != 4) {
            adminPINTextField.attributedPlaceholder = NSAttributedString(string:"Invalid Admin PIN.",
                                                                         attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
        if (username!.characters.count < 5) {
            usernameTextField.text = ""
            usernameTextField.attributedPlaceholder = NSAttributedString(string:"Invalid Username.",
                                                                         attributes:[NSForegroundColorAttributeName: UIColor.redColor()])
        }
        
    }
    
    
}