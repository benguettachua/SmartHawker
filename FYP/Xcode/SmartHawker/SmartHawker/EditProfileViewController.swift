//
//  EditProfileViewController.swift
//  SmartHawker
//
//  Created by GX on 29/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import Foundation
import Foundation
import Material
import FontAwesome_iOS
import UIKit
import Parse


class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    let picker = UIImagePickerController()
    
    var name = TextField()
    var bizname = TextField()
    var biznum = TextField()
    var phone = TextField()
    var address = TextField()
    var email = TextField()
    var adminPIN = TextField()
    @IBOutlet weak var profilePicture: UIImageView!
    typealias CompletionHandler = (success: Bool) -> Void
    @IBOutlet var information: UILabel!
    @IBOutlet weak var back: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var changeProfilePicButton: UIButton!
    
    var imageFile: PFFile!
    let user = PFUser.currentUser()
    var shared = ShareData.sharedInstance
    var updated = false
    
    var errorMsg = [String]()
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var donebtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let navigationItem = UINavigationItem.init(title: "Edit Profile".localized())
        navBar.items = [navigationItem]
        changeProfilePicButton.setTitle("Change Profile Picture".localized(), forState: UIControlState.Normal)
        information.text = "Choose image within 10MB".localized()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.handleTap(_:))))
        
        var faicon = [String: UniChar]()
        faicon["faleftback"] = 0xf053
        faicon["fatick"] = 0xf00c
        
        backbtn.titleLabel?.lineBreakMode
        backbtn.titleLabel?.numberOfLines = 2
        backbtn.titleLabel!.textAlignment = .Center
        
        var backs = String(format: "%C", faicon["faleftback"]!)
        
        backs += "\n"
        
        backs += "Back".localized()
        
        backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 15)
        
        backbtn.setTitle(String(backs), forState: .Normal);
        
        donebtn.titleLabel?.lineBreakMode
        donebtn.titleLabel?.numberOfLines = 2
        donebtn.titleLabel!.textAlignment = .Center
        
        var dones = String(format: "%C", faicon["fatick"]!)
        
        dones += "\n"
        
        dones += "Save".localized()
        
        donebtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 15)
        
        donebtn.setTitle(String(dones), forState: .Normal);
        
        name.placeholder = "NAME".localized()
        var name2 = user!["name"]
        if (name2 == nil) {
            name2 = "No name".localized()
        }
        name.text = name2 as? String
        
        view.layout(name).top(180).horizontally(left: 20, right: 20).height(22)
        
        phone.placeholder = "PHONE".localized()
        phone.text = user!["phoneNumber"] as? String
        
        view.layout(phone).top(225).horizontally(left: 20, right: 20).height(22)
        
        email.placeholder = "EMAIL".localized()
        var email2 = user!["email"]
        if (email2 == nil) {
            email2 = "No email".localized()
        }
        email.text = email2 as? String
        
        
        view.layout(email).top(270).horizontally(left: 20, right: 20).height(22)
        
        bizname.placeholder = "BUSINESS NAME".localized()
        var businessName2 = user!["businessName"]
        if (businessName2 == nil) {
            businessName2 = "No business name".localized()
        }
        bizname.text = businessName2 as? String
        
        view.layout(bizname).top(315).horizontally(left: 20, right: 20).height(22)
        
        biznum.placeholder = "BUSINESS NUMBER".localized()
        var businessNum2 = user!["businessNumber"]
        if (businessNum2 == nil) {
            businessNum2 = "No business number".localized()
        }
        biznum.text = businessNum2 as? String
        
        view.layout(biznum).top(360).horizontally(left: 20, right: 20).height(22)
        
        address.placeholder = "ADDRESS".localized()
        var businessAddress2 = user!["businessAddress"]
        if (businessAddress2 == nil) {
            businessAddress2 = "No business address".localized()
        }
        address.text = businessAddress2 as? String
        
        view.layout(address).top(405).horizontally(left: 20, right: 20).height(22)
        
        adminPIN.placeholder = "Admin PIN".localized()
        adminPIN.text = user!["adminPin"] as? String
        
        view.layout(adminPIN).top(450).horizontally(left: 20, right: 20).height(22)
        
        let profilePic = user!["profilePicture"]
        if (profilePic == nil) {
            let image = UIImage(named: "defaultProfilePic")
            self.profilePicture.image = image
            self.imageFile = PFFile(data: UIImageJPEGRepresentation(image!, 0)!)
        } else {
            if let userPicture = user!["profilePicture"] as? PFFile {
                userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                    if (error == nil) {
                        self.profilePicture.image = UIImage(data: imageData!)
                        self.imageFile = self.user!["profilePicture"] as? PFFile
                    }
                }
            }
        }
        
        self.title = "Edit Profile".localized()
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    // Back
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //change email
    @IBAction func change(sender: UIButton) {
        
        if connectionDAO().isConnectedToNetwork(){
            let alert = UIAlertController(title: "Editing".localized(), message: "Edits are being made to your profile details".localized(), preferredStyle: UIAlertControllerStyle.Alert)
            self.presentViewController(alert, animated: true, completion: {
                
                self.errorMsg.removeAll()
                
                var error = 0
                var newName = ""
                var newEmail = ""
                var newPhoneNumber = ""
                var newBusinessName = ""
                var newBusinessAddress = ""
                var newBusinessRegNo = ""
                var newPINNumber = ""
                //checks for name
                if self.name.text!.isEmpty == false{
                    newName = self.name.text!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if newName.isEmpty{
                        let errorString = "Invalid Name field.".localized()
                        self.name.text = ""
                        self.name.placeholder = "Invalid Name field.".localized()
                        self.errorMsg.append(errorString)
                        error += 1
                    }
                }else{
                    let errorString = "Invalid Name field.".localized()
                    self.name.text = ""
                    self.name.placeholder = "Invalid Name field.".localized()
                    self.errorMsg.append(errorString)
                    error += 1
                }
                
                //checks for phone number
                if self.phone.text!.isEmpty == false{
                    
                    if Int(self.phone.text!) != nil {
                        if Int(self.phone.text!) >= 80000000 && Int(self.phone.text!) < 100000000{
                            newPhoneNumber = self.phone.text!
                        }else{
                            let errorString = "Invalid Phone Number field.".localized()
                            self.phone.text = ""
                            self.phone.placeholder = "Invalid Phone Number field.".localized()
                            self.errorMsg.append(errorString)
                            error += 1
                        }
                    } else {
                        let errorString = "Invalid Phone Number field.".localized()
                        self.phone.text = ""
                        self.phone.placeholder = "Invalid Phone Number field.".localized()
                        self.errorMsg.append(errorString)
                        error += 1
                    }
                }else {
                    let errorString = "Invalid Phone Number field.".localized()
                    self.phone.text = ""
                    self.phone.placeholder = "Invalid Phone Number field.".localized()
                    self.errorMsg.append(errorString)
                    error += 1
                }
                
                //checks for AdminPIN Number
                if self.adminPIN.text!.isEmpty == false{
                    var text: String!
                    if Int(self.adminPIN.text!) != nil {
                        text = self.adminPIN.text!
                        if Int(self.adminPIN.text!) >= 0 && Int(self.adminPIN.text!) < 10000 && text.characters.count == 4{
                            newPINNumber = self.adminPIN.text!
                        }else{
                            let errorString = "Invalid Admin PIN field.".localized()
                            self.adminPIN.text = ""
                            self.adminPIN.placeholder = "Invalid Admin PIN field.".localized()
                            self.errorMsg.append(errorString)
                            error += 1
                        }
                    } else {
                        let errorString = "Invalid Admin PIN field.".localized()
                        self.adminPIN.text = ""
                        self.adminPIN.placeholder = "Invalid Admin PIN field.".localized()
                        self.errorMsg.append(errorString)
                        error += 1
                    }
                }else {
                    let errorString = "Invalid Admin PIN field.".localized()
                    self.adminPIN.text = ""
                    self.adminPIN.placeholder = "Invalid Admin PIN field.".localized()
                    self.errorMsg.append(errorString)
                    error += 1
                }
                
                //checks for email
                if self.email.text!.isEmpty == false{
                    if self.isValidEmail(self.email.text!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet())) && ProfileController().checkEmail(self.email.text!.stringByTrimmingCharactersInSet(
                            NSCharacterSet.whitespaceAndNewlineCharacterSet())){
                        newEmail = self.email.text!
                    }else{
                        let errorString = "Invalid Email field.".localized()
                        self.email.text = ""
                        self.email.placeholder = "Invalid Email field.".localized()
                        self.errorMsg.append(errorString)
                        error += 1
                    }
                }else{
                    let errorString = "Empty Email field.".localized()
                    self.email.text = ""
                    self.email.placeholder = "Empty Email field.".localized()
                    self.errorMsg.append(errorString)
                    error += 1
                }
                
                //checks for business name
                if self.bizname.text!.isEmpty == false{
                    newBusinessName = self.bizname.text!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if newBusinessName.isEmpty{
                        let errorString = "Empty Business Name field.".localized()
                        self.bizname.text = ""
                        self.bizname.placeholder = "Empty Business Name field.".localized()
                        self.errorMsg.append(errorString)
                    }
                }else{
                    let errorString = "Empty Business Name field.".localized()
                    self.bizname.text = ""
                    self.bizname.placeholder = "Empty Business Name field.".localized()
                    self.errorMsg.append(errorString)
                }
                
                //Change business Reg No
                if self.biznum.text!.isEmpty == false{
                    newBusinessRegNo = self.biznum.text!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if newBusinessRegNo.isEmpty{
                        let errorString = "Empty Business Reg No field.".localized()
                        self.biznum.text = ""
                        self.biznum.placeholder = "Empty Business Reg No field.".localized()
                        self.errorMsg.append(errorString)
                    }
                }else{
                    let errorString = "Empty Business Reg No field.".localized()
                    self.biznum.text = ""
                    self.biznum.placeholder = "Empty Business Reg No field.".localized()
                    self.errorMsg.append(errorString)
                }
                
                //Change business Address
                if self.address.text!.isEmpty == false{
                    newBusinessAddress = self.address.text!.stringByTrimmingCharactersInSet(
                        NSCharacterSet.whitespaceAndNewlineCharacterSet())
                    if newBusinessAddress.isEmpty{
                        let errorString = "Empty Business Address field.".localized()
                        self.address.text = ""
                        self.address.placeholder = "Empty Business Address field.".localized()
                        self.errorMsg.append(errorString)
                    }
                }else{
                    let errorString = "Empty Business Address field.".localized()
                    self.address.text = ""
                    self.address.placeholder = "Empty Business Address field.".localized()
                    self.errorMsg.append(errorString)
                }
                
                
                
                if error == 0 {
                    
                    print(newName)
                    print(newEmail)
                    print(newPhoneNumber)
                    print(newPINNumber)
                    print(newBusinessAddress)
                    print(newBusinessRegNo)
                    print(self.imageFile)
                    let edited = connectionDAO().edit(newName, email: newEmail, phoneNumber: newPhoneNumber, adminPIN: newPINNumber, businessAddress: newBusinessAddress, businessName: newBusinessName, businessNumber: newBusinessRegNo, profilePicture: self.imageFile)
                    if edited == true{
                        self.dismissViewControllerAnimated(true, completion: {
                            let alert = UIAlertController(title: "Edit Successful".localized(), message: "Edits are made to the profile details".localized(), preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Close".localized(), style: UIAlertActionStyle.Default, handler: {(alert: UIAlertAction!) in self.dismissViewControllerAnimated(true, completion: {})}))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                    }else{
                        self.dismissViewControllerAnimated(true, completion: {
                            let alert = UIAlertController(title: "Edit Unsuccessful".localized(), message: "Edits are not made to the profile details".localized(), preferredStyle: UIAlertControllerStyle.Alert)
                            alert.addAction(UIAlertAction(title: "Close".localized(), style: UIAlertActionStyle.Default, handler: nil))
                            
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                    }
                    
                    
                    
                    
                }else{
                    self.dismissViewControllerAnimated(true, completion: {
                        let alert = UIAlertController(title: "Edit Unsuccessful".localized(), message: "Edits are not made to the profile details".localized(), preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Close".localized(), style: UIAlertActionStyle.Default, handler: nil))
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            })
            
        }else{
            
            let alertController = UIAlertController(title: "Please find a internet connection.".localized(), message: "Please try again later.".localized(), preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok".localized(), style: .Cancel, handler: nil)
            alertController.addAction(ok)
            self.presentViewController(alertController, animated: true,completion: nil)
        }
    }
    //////Changing profile picture
    
    
    // An alert method using the new iOS 8 UIAlertController instead of the deprecated UIAlertview
    // make the alert with the preferredstyle .Alert, make necessary actions, and then add the actions.
    // add to the handler a closure if you want the action to do anything.
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera".localized(),
            message: "This device has no camera".localized(),
            preferredStyle: .Alert)
        let okAction = UIAlertAction(
            title: "Ok".localized(),
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
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker, animated: true, completion: nil)
        }else if UIImagePickerController.availableCaptureModesForCameraDevice(.Front) != nil {
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            picker.modalPresentationStyle = .FullScreen
            presentViewController(picker, animated: true, completion: nil)
        }else {
            noCamera()
        }
    }
    
    
    // MARK: Actions
    
    
    @IBAction func selectNewImageFromPhotoLibrary(sender: UIButton) {
        let refreshAlert = UIAlertController(title: "Update Profile Picture".localized(), message: "Please upload your new profile picture.".localized(), preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Camera".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            
            self.shootPhoto()
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Photo Library".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            
            self.photoLibrary()
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            self.information.textColor = UIColor.blackColor()
            self.information.text = "Choose image within 10MB".localized()
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
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {

        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImageJPEGRepresentation(chosenImage, 0)
        
        if imageData!.length < 9999999{
            
            // Image is within size limit, allow upload.
            imageFile = PFFile(name: "profilePicture", data: imageData!)
            profilePicture.contentMode = .ScaleAspectFit
            profilePicture.image = chosenImage
            updated = true
            self.information.textColor = UIColor.blackColor()
            information.text = "Image Uploaded".localized()
        }else{
            
            // Inform the user that size limit exceeded
            information.textColor = UIColor.redColor()
            information.text = "Image Not Within 10MB".localized()
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.information.textColor = UIColor.blackColor()
        self.information.text = "Choose image within 10MB".localized()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //checks for valid email
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluateWithObject(testStr) && testStr != user!["email"] as! String{
            return true
        }
        return false
    }
    
    
    
}