//
//  RegistrationViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 19/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit


class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var businessRegNo: UITextField!
    @IBOutlet weak var businessAddress: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var adminPIN: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    // Registers the user upon clicking this button.
    @IBAction func registerButton(sender: UIButton) {
        
        if (businessName.text!.isEqual("")) {
            
            // Validition: Ensures that Business Name field is not empty
            self.messageLabel.text = "Please enter your Business Name."
            self.messageLabel.textColor = UIColor.redColor()
            self.messageLabel.hidden = false
            
        } else if (businessRegNo.text!.isEqual("")) {
            
            // Validition: Ensures that Business Registered Number field is not empty
            self.messageLabel.text = "Please enter your Business Registered Number."
            self.messageLabel.textColor = UIColor.redColor()
            self.messageLabel.hidden = false
            
        } else if (businessAddress.text!.isEqual("")) {
            
            // Validition: Ensures that Business Address field is not empty
            self.messageLabel.text = "Please enter your Business Address."
            self.messageLabel.textColor = UIColor.redColor()
            self.messageLabel.hidden = false
            
        } else if (username.text!.isEqual("")) {
            
            // Validition: Ensures that username field is not empty
            self.messageLabel.text = "Please enter your username."
            self.messageLabel.textColor = UIColor.redColor()
            self.messageLabel.hidden = false
            
        } else if (email.text!.isEqual("")) {
            
            // Validition: Ensures that email field is not empty
            self.messageLabel.text = "Please enter your email."
            self.messageLabel.textColor = UIColor.redColor()
            self.messageLabel.hidden = false
            
        } else if (phoneNumber.text!.isEqual("")) {
            
            // Validition: Ensures that phoneNumber is not empty
            self.messageLabel.text = "Please enter your Phone Number."
            self.messageLabel.textColor = UIColor.redColor()
            self.messageLabel.hidden = false
            
        } else if (password.text!.isEqual("")) {
            
            // Validition: Ensures that password field is not empty
            self.messageLabel.text = "Please enter your password."
            self.messageLabel.textColor = UIColor.redColor()
            self.messageLabel.hidden = false
            
        } else if (confirmPassword.text!.isEqual("")) {
            
            // Validition: Ensures that confirm password field is not empty
            self.messageLabel.text = "Please enter confirm password."
            self.messageLabel.textColor = UIColor.redColor()
            self.messageLabel.hidden = false
            
        } else if (adminPIN.text!.isEqual("")) {
            
            // Validition: Ensures that adminPIN field is not empty
            self.messageLabel.text = "Please enter your admin PIN."
            self.messageLabel.textColor = UIColor.redColor()
            self.messageLabel.hidden = false
            
        } else if (password.text!.isEqual(confirmPassword.text!) == false){
            
            // Validition: Ensures that password and confirm password is the same.
            self.messageLabel.text = "Password and Confirm Password does not match, please try again."
            self.messageLabel.textColor = UIColor.redColor()
            self.messageLabel.hidden = false
            
        } else {
            
            // All validations passed, proceed to register user.
            let newUser = PFUser()
            newUser["businessName"] = businessName.text
            newUser["businessNumber"] = businessRegNo.text
            newUser["businessAddress"] = businessAddress.text
            newUser.username = username.text
            newUser.email = email.text
            newUser["phoneNumber"] = phoneNumber.text
            newUser.password = password.text
            newUser["adminPin"] = adminPIN.text
            newUser["isIOS"] = true
            
            let imageData = UIImagePNGRepresentation(profilePicture.image!)
            let imageFile = PFFile(name: "profilePicture.png", data: imageData!)
            newUser["profilePicture"] = imageFile
            newUser.signUpInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    
                    // Register success, show success message.
                    self.messageLabel.text = "Congratulations, you have created a new Account! Logging in, please wait..."
                    self.messageLabel.hidden = false
                    
                    // Login the user to main UI after 3 seconds delay.
                    let time = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 3 * Int64(NSEC_PER_SEC))
                    dispatch_after(time, dispatch_get_main_queue()) {
                        PFUser.logInWithUsernameInBackground(self.username.text!, password: self.password.text!) {
                            (user: PFUser?, error: NSError?) -> Void in
                            if user != nil {
                                // Re-direct user to main UI if login success.
                                self.performSegueWithIdentifier("registerSuccess", sender: self)
                            } else {
                                // There was a problem, show user the error message.
                                self.messageLabel.text = error?.localizedDescription
                                self.messageLabel.hidden = false

                                
                            }
                        }
                    }
                    
                } else {
                    // There was a problem, show user the error message.
                    self.messageLabel.text = error?.localizedDescription
                    self.messageLabel.textColor = UIColor.redColor()
                    self.messageLabel.hidden = false
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    @IBAction func selectNewImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .Camera
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        
        presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
}