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
        newUser["adminPIN"] = adminPIN.text
        newUser["isIOS"] = true
        
        if (password.isEqual(confirmPassword)){
            newUser.signUpInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    // The object has been saved.
                } else {
                    // There was a problem, check error.description
                }
            }
        } else {
            print("Incorrect Password")
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