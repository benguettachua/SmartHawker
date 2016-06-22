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
    
    
    // This function currently saves to the DB without any validation.
    @IBAction func registerButton(sender: UIButton) {
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
        
        if (password.text!.isEqual(confirmPassword.text!)){
            newUser.signUpInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                    self.messageLabel.text = "Congratulations, you have created a new Account!"
                    self.messageLabel.hidden = false
                } else {
                    // There was a problem, check error.description
                    self.messageLabel.text = error?.localizedDescription
                    self.messageLabel.hidden = false
                }
            }
        } else {
            self.messageLabel.text = "Password and Confirm Password does not match, please try again."
            //self.messageLabel.font = messageLabel.font.fontWithSize(10)
            self.messageLabel.textColor = UIColor.redColor()
            self.messageLabel.hidden = false
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