//
//  RegistrationViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 19/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit


class RegistrationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    let picker = UIImagePickerController()   //our controller.
    //Memory will be conserved a bit if you place this in the actions.
    // I did this to make code a bit more streamlined
    
    //labels
    @IBOutlet weak var profilePictureLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var confirmPasswordLabel: UILabel!
    @IBOutlet weak var adminPinLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessAddressLabel: UILabel!
    @IBOutlet weak var businessRegNoLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    //navigation bar
    @IBOutlet weak var registerNavBar: UINavigationBar!
    
    @IBOutlet weak var back: UIBarButtonItem!
    
    
    // MARK: Properties
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var businessName: UITextField!
    @IBOutlet var businessRegNo: UITextField!
    @IBOutlet var businessAddress: UITextField!
    @IBOutlet var username: UITextField!
    @IBOutlet var email: UITextField!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var adminPIN: UITextField!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var information: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet var ScrollView: UIScrollView!
    // Registers the user upon clicking this button.
    @IBAction func registerButton(sender: UIButton) {
        
        if (businessName.text!.isEqual("")) {
            
            // Validition: Ensures that Business Name field is not empty
            businessName.text = ""
            businessName.attributedPlaceholder = NSAttributedString(string:"Please enter your Business Name.", attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
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
            print("lalalalalalalalaa")
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
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        picker.delegate = self
        self.view.addSubview(ScrollView)
        ScrollView.scrollEnabled = false
        
        registerNavBar.topItem!.title = "Register a New Account".localized()
        registerButton.setTitle("Register".localized(), forState: .Normal)
        back.title = "Back".localized()
    
        profilePictureLabel.text = "Profile Picture".localized()
        usernameLabel.text = "Username".localized()
        emailLabel.text = "Email".localized()
        passwordLabel.text = "Password".localized()
        confirmPasswordLabel.text = "Confirm Password".localized()
        adminPinLabel.text = "Admin PIN (4 Digits)".localized()
        businessNameLabel.text = "Business Name".localized()
        businessAddressLabel.text = "Business Address".localized()
        businessRegNoLabel.text = "Business Reg No".localized()
        phoneNumberLabel.text = "Phone Number".localized()
    

        businessName.placeholder = "Business Name".localized()
        businessRegNo.placeholder = "Business Reg No".localized()
        businessAddress.placeholder = "Business Address".localized()
        username.placeholder = "Username".localized()
        email.placeholder = "Email".localized()
        phoneNumber.placeholder = "Phone Number".localized()
        password.placeholder = "Password".localized()
        confirmPassword.placeholder = "Confirm Password".localized()
        adminPIN.placeholder = "Admin PIN (4 Digits)".localized()
    
    
    
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.ScrollView.contentSize = CGSize(width:self.view.frame.width, height: 900)
        
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        ScrollView.setContentOffset(CGPointMake(0, 175), animated: true)
        ScrollView.scrollEnabled = true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        ScrollView.scrollEnabled = false
    }
    
    func textFieldDidEndEditing() {
        ScrollView.setContentOffset(CGPointMake(0, 0), animated: true)
        ScrollView.scrollEnabled = false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        profilePicture.resignFirstResponder()
        businessName.resignFirstResponder()
        businessRegNo.resignFirstResponder()
        businessAddress.resignFirstResponder()
        username.resignFirstResponder()
        email.resignFirstResponder()
        phoneNumber.resignFirstResponder()
        password.resignFirstResponder()
        confirmPassword.resignFirstResponder()
        adminPIN.resignFirstResponder()
        messageLabel.resignFirstResponder()
        return true
    }
    
    
    // An alert method using the new iOS 8 UIAlertController instead of the deprecated UIAlertview
    // make the alert with the preferredstyle .Alert, make necessary actions, and then add the actions.
    // add to the handler a closure if you want the action to do anything.
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera".localized(),
            message: "This device has no camera".localized(),
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK".localized(),
            style:.Default,
            handler: nil)
        alertVC.addAction(okAction)
        presentViewController(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    //take a picture, check if we have a camera first.
    func shootPhoto() {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker,
                                  animated: true,
                                  completion: nil)
        } else {
            noCamera()
        }
    }
    
    
    
    // MARK: Actions
    @IBAction func selectNewImageFromPhotoLibrary(sender: UITapGestureRecognizer) {
        let refreshAlert = UIAlertController(title: "Profile Picture".localized(), message: "Please Choose a Profile Picture".localized(), preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Camera".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            self.textFieldDidEndEditing()
            self.shootPhoto()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Photo Library".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            self.textFieldDidEndEditing()
            self.photoLibrary()
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            self.information.textColor = UIColor.blackColor()
            self.information.text = "Choose image within 10MB".localized()
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            self.textFieldDidEndEditing()
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    func photoLibrary(){
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.

        picker.sourceType = .PhotoLibrary

        // Make sure ViewController is notified when the user picks an image.
        picker.delegate = self
        
        presentViewController(picker, animated: true, completion: nil)
        
    }
    
    //MARK: - Delegates
    //What to do when the picker returns with a photo
    func imagePickerController(
        picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        let imageData = UIImagePNGRepresentation(chosenImage)
        print(imageData!.length < 9999999)
        if imageData!.length < 9999999{

            profilePicture.contentMode = .ScaleAspectFit //3
            print("qqqweqweqweqweqweqweqweqweqweqwe")
            profilePicture.image = chosenImage //4
            print("qqqweqweqweqweqweqweqweqweqweqwe")
            self.information.textColor = UIColor.blackColor()
            information.text = "Image Uploaded".localized()
        }else{
            information.textColor = UIColor.redColor()
            information.text = "Image Not Within 10MB".localized()
            
        }
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.information.textColor = UIColor.blackColor()
        self.information.text = "Choose image within 10MB".localized()
        dismissViewControllerAnimated(true,
                                      completion: nil)
    }
    
    
    
}