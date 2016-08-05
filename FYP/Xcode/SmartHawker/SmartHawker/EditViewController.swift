//
//  AnalyticsViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 24/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import Parse

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: Properties
    let picker = UIImagePickerController()
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var adminPin: UITextField!
    @IBOutlet weak var businessRegNo: UITextField!
    @IBOutlet weak var businessAddress: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var phoneNo: UITextField!
    @IBOutlet weak var profilePicture: UIImageView!
    typealias CompletionHandler = (success: Bool) -> Void
    @IBOutlet var information: UILabel!
    @IBOutlet weak var back: UIButton!
    
    var imageFile: PFFile!
    let user = PFUser.currentUser()
    var shared = ShareData.sharedInstance
    var updated = false
    
    var errorMsg = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
         picker.delegate = self
         if let userPicture = user!["profilePicture"] as? PFFile {
         userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
         if (error == nil) {
         self.profilePicture.image = UIImage(data: imageData!)
         }
         }
         }
         */
        // Populate the top bar
        name.text! = user!["name"] as! String
        businessName.text! = user!["businessName"] as! String
        businessRegNo.text! = user!["businessNumber"] as! String
        businessAddress.text! = user!["businessAddress"] as! String
        adminPin.text! = user!["adminPin"] as! String
        email.text! = user!["email"] as! String
        phoneNo.text! = user!["phoneNumber"] as! String
        
        if let userPicture = user!["profilePicture"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.profilePicture.image = UIImage(data: imageData!)
                    self.imageFile = self.user!["profilePicture"] as? PFFile
                }
            }
        }
    }
    
    @IBAction func back(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    //change email
    @IBAction func change(sender: UIButton) {
        
        errorMsg.removeAll()
        
        var error = 0
        var newName = ""
        var newEmail = ""
        var newPhoneNumber = ""
        var newBusinessName = ""
        var newBusinessAddress = ""
        var newBusinessRegNo = ""
        var newPINNumber = ""
        let password = self.shared.password
        
        //checks for name
        if name.text!.isEmpty == false{
            newName = name.text!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if newName.isEmpty{
                let errorString = "Invalid Name field."
                name.text = ""
                name.placeholder = "Invalid Name field."
                errorMsg.append(errorString)
                error += 1
            }
        }else{
            let errorString = "Invalid Name field."
            name.text = ""
            name.placeholder = "Invalid Name field."
            errorMsg.append(errorString)
            error += 1
        }
        
        //checks for phone number
        if phoneNo.text!.isEmpty == false{
            
            if Int(phoneNo.text!) != nil {
                if Int(phoneNo.text!) >= 80000000 && Int(phoneNo.text!) < 100000000{
                    newPhoneNumber = phoneNo.text!
                }else{
                    let errorString = "Invalid Phone Number field."
                    phoneNo.text = ""
                    phoneNo.placeholder = "Invalid Phone Number field."
                    errorMsg.append(errorString)
                    error += 1
                }
            } else {
                let errorString = "Invalid Phone Number field."
                phoneNo.text = ""
                phoneNo.placeholder = "Invalid Phone Number field."
                errorMsg.append(errorString)
                error += 1
            }
        }else {
            let errorString = "Invalid Phone Number field."
            phoneNo.text = ""
            phoneNo.placeholder = "Invalid Phone Number field."
            errorMsg.append(errorString)
            error += 1
        }
        
        //checks for AdminPIN Number
        if adminPin.text!.isEmpty == false{
            
            if Int(adminPin.text!) != nil {
                if Int(adminPin.text!) >= 1000 && Int(adminPin.text!) < 10000{
                    newPINNumber = adminPin.text!
                }else{
                    let errorString = "Invalid Admin PIN field."
                    adminPin.text = ""
                    adminPin.placeholder = "Invalid Admin PIN field."
                    errorMsg.append(errorString)
                    error += 1
                }
            } else {
                let errorString = "Invalid Admin PIN field."
                adminPin.text = ""
                adminPin.placeholder = "Invalid Admin PIN field."
                errorMsg.append(errorString)
                error += 1
            }
        }else {
            let errorString = "Invalid Admin PIN field."
            adminPin.text = ""
            adminPin.placeholder = "Invalid Admin PIN field."
            errorMsg.append(errorString)
            error += 1
        }
        
        //checks for email
        if email.text!.isEmpty == false{
            if isValidEmail(email.text!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet())) {
                newEmail = email.text!
            }else{
                let error = "Invalid Email field."
                email.text = ""
                email.placeholder = "Invalid Email field."
                errorMsg.append(error)
            }
        }else{
            let error = "Empty Email field."
            email.text = ""
            email.placeholder = "Empty Email field."
            errorMsg.append(error)
        }
        
        //checks for business name
        if businessName.text!.isEmpty == false{
            newBusinessName = businessName.text!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if newBusinessName.isEmpty{
                let errorString = "Empty Business Name field."
                businessName.text = ""
                businessName.placeholder = "Empty Business Name field."
                errorMsg.append(errorString)
            }
        }else{
            let errorString = "Empty Business Name field."
            businessName.text = ""
            businessName.placeholder = "Empty Business Name field."
            errorMsg.append(errorString)
        }
        
        //Change business Reg No
        if businessRegNo.text!.isEmpty == false{
            newBusinessRegNo = businessRegNo.text!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if newBusinessRegNo.isEmpty{
                let errorString = "Empty Business Reg No field."
                businessRegNo.text = ""
                businessRegNo.placeholder = "Empty Business Reg No field."
                errorMsg.append(errorString)
            }
        }else{
            let errorString = "Empty Business Reg No field."
            businessRegNo.text = ""
            businessRegNo.placeholder = "Empty Business Reg No field."
            errorMsg.append(errorString)
        }
        
        //Change business Address
        if businessAddress.text!.isEmpty == false{
            newBusinessAddress = businessAddress.text!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if newBusinessAddress.isEmpty{
                let errorString = "Empty Business Address field."
                businessAddress.text = ""
                businessAddress.placeholder = "Empty Business Address field."
                errorMsg.append(errorString)
            }
        }else{
            let errorString = "Empty Business Address field."
            businessAddress.text = ""
            businessAddress.placeholder = "Empty Business Address field."
            errorMsg.append(errorString)
        }

        
        
        if error == 0 {
            self.user!["name"] = newName
            self.user!["phoneNumber"] = newPhoneNumber
            self.user!["email"] = newEmail
            self.user!["adminPin"] = newPINNumber
            self.user!["businessAddress"] = newBusinessAddress
            self.user!["businessName"] = newBusinessName
            self.user!["businessNumber"] = newBusinessRegNo
            self.user!["profilePicture"] = imageFile
            self.user?.saveInBackground()
            
            let alert = UIAlertController(title: "Edit Successful", message: "Edits are made to the profile details", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.dismissViewControllerAnimated(true, completion: {})}))
            
            self.presentViewController(alert, animated: true, completion: nil)
            


            
            
        }else{
            let alert = UIAlertController(title: "Edit Unsuccessful", message: "Edits are not made to the profile details", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    //////Changing profile picture
    
    
    // An alert method using the new iOS 8 UIAlertController instead of the deprecated UIAlertview
    // make the alert with the preferredstyle .Alert, make necessary actions, and then add the actions.
    // add to the handler a closure if you want the action to do anything.
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "This device has no camera",
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "OK",
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
    
    
    @IBAction func selectNewImageFromPhotoLibrary(sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Update Profile Picture", message: "Please upload your new profile picture.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.shootPhoto()
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.photoLibrary()
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            self.information.textColor = UIColor.blackColor()
            self.information.text = "Choose image within 10MB"
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
            
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
        let imageData = UIImageJPEGRepresentation(chosenImage, 100)
        
        if imageData!.length < 9999999{
            imageFile = PFFile(name: "profilePicture.png", data: imageData!)
            
            
            
            profilePicture.contentMode = .ScaleAspectFit //3
            profilePicture.image = chosenImage //4
            
            updated = true
            self.information.textColor = UIColor.blackColor()
            information.text = "Image Uploaded"
            
        }else{
            information.textColor = UIColor.redColor()
            information.text = "Image Not Within 10MB"
            
        }
        
        
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.information.textColor = UIColor.blackColor()
        self.information.text = "Choose image within 10MB"
        dismissViewControllerAnimated(true,
                                      completion: nil)
    }
    
    
    //checks for valid email
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
}