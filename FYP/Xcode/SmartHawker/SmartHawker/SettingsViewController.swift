//
//  AnalyticsViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 24/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import Parse

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    // MARK: Properties
    let picker = UIImagePickerController()
    @IBOutlet weak var username: UITextView!
    @IBOutlet weak var businessName: UITextView!
    @IBOutlet weak var businessRegNo: UITextView!
    @IBOutlet weak var businessAddress: UITextView!
    @IBOutlet weak var adminPin: UITextView!
    @IBOutlet weak var email: UITextView!
    @IBOutlet weak var phoneNo: UITextView!
    @IBOutlet weak var profilePicture: UIImageView!
    typealias CompletionHandler = (success: Bool) -> Void
    
    @IBOutlet var information: UILabel!
    let user = PFUser.currentUser()
    var shared = ShareData.sharedInstance
    var updated = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        if let userPicture = user!["profilePicture"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.profilePicture.image = UIImage(data: imageData!)
                }
            }
        }
        // Populate the top bar
        username.text! = user!["username"] as! String
        businessName.text! = user!["businessName"] as! String
        businessRegNo.text! = user!["businessNumber"] as! String
        businessAddress.text! = user!["businessAddress"] as! String
        adminPin.text! = user!["adminPin"] as! String
        email.text! = user!["email"] as! String
        phoneNo.text! = user!["phoneNumber"] as! String
        
        
        
    }
    
    
    
    //change email
    @IBAction func changeEmail(sender: UIButton) {
        var newEmail1: UITextField?
        var newEmail2: UITextField?
        var oldPassword: UITextField?
        let password = self.shared.password
        let alertController = UIAlertController(title: "Update Email", message: "Please enter your new email", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            if newEmail1!.text!.isEmpty == false && newEmail2!.text!.isEmpty == false && newEmail1!.text! == newEmail2!.text! && oldPassword!.text == password{
                self.user!["email"] = newEmail1!.text
                self.user?.saveInBackground()
                let alert = UIAlertController(title: "Email", message: "Email is now updated to \(newEmail1!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                self.viewDidLoad()
            }else{
                let alert = UIAlertController(title: "Email not updated", message: "1) Password is wrong. \n2) Email is invalid", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in}
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newEmail1 = textField
            newEmail1?.placeholder = "Enter your new Email"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newEmail2 = textField
            newEmail2?.placeholder = "Enter your new Email again"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            oldPassword = textField
            oldPassword?.placeholder = "Enter your password for confirmation"
        }
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //Change business name
    @IBAction func changeBusinessName(sender: UIButton) {
        var newBusinessName1: UITextField?
        var newBusinessName2: UITextField?
        var oldPassword: UITextField?
        let password = self.shared.password
        let alertController = UIAlertController(title: "Update Business Name", message: "Please enter your new Business Name", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            if newBusinessName1!.text!.isEmpty == false && newBusinessName2!.text!.isEmpty == false && newBusinessName1!.text! == newBusinessName2!.text! && oldPassword!.text == password{
                self.user!["businessName"] = newBusinessName1!.text
                self.user?.saveInBackground()
                let alert = UIAlertController(title: "Business Name", message: "Business Name is now updated to \(newBusinessName1!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                self.viewDidLoad()
            }else{
                let alert = UIAlertController(title: "Business Name", message: "1) Password is wrong. \n2) Field is empty. ", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in}
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newBusinessName1 = textField
            newBusinessName1?.placeholder = "Enter your new Business Name"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newBusinessName2 = textField
            newBusinessName2?.placeholder = "Enter your new Business Name again"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            oldPassword = textField
            oldPassword?.placeholder = "Enter your password for confirmation"
        }
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //Change business address
    @IBAction func changeBusinessAddress(sender: UIButton) {
        var newBusinessAddress1: UITextField?
        var newBusinessAddress2: UITextField?
        var oldPassword: UITextField?
        let password = self.shared.password
        let alertController = UIAlertController(title: "Update Business Address", message: "Please enter your new Business Address", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            if newBusinessAddress1!.text!.isEmpty == false && newBusinessAddress2!.text!.isEmpty == false && newBusinessAddress1!.text! == newBusinessAddress2!.text! && oldPassword!.text == password{
                self.user!["businessAddress"] = newBusinessAddress1!.text
                self.user?.saveInBackground()
                let alert = UIAlertController(title: "Business Address", message: "Business Address is now updated to \(newBusinessAddress1!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                self.viewDidLoad()
            }else{
                let alert = UIAlertController(title: "Business Address", message: "1) Password is wrong. \n2) Field is empty. ", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in}
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newBusinessAddress1 = textField
            newBusinessAddress1?.placeholder = "Enter your new Business Address"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newBusinessAddress2 = textField
            newBusinessAddress2?.placeholder = "Enter your new Business Address again"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            oldPassword = textField
            oldPassword?.placeholder = "Enter your password for confirmation"
        }
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //Change phone number
    @IBAction func changePhoneNumber(sender: UIButton) {
        var newPhoneNumber1: UITextField?
        var newPhoneNumber2: UITextField?
        var oldPassword: UITextField?
        let password = self.shared.password
        let alertController = UIAlertController(title: "Update Phone Number", message: "Please enter your new Phone Number", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            if newPhoneNumber1!.text!.isEmpty == false && newPhoneNumber2!.text!.isEmpty == false && newPhoneNumber1!.text! == newPhoneNumber2!.text! && oldPassword!.text == password{
                self.user!["phoneNumber"] = newPhoneNumber1!.text
                self.user?.saveInBackground()
                let alert = UIAlertController(title: "Phone Number", message: "Phone Number is now updated to \(newPhoneNumber1!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                self.viewDidLoad()
            }else{
                let alert = UIAlertController(title: "Phone Number", message: "1) Field is empty. \n2) Password is incorrect/empty. ", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in}
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newPhoneNumber1 = textField
            newPhoneNumber1?.placeholder = "Enter your new phone number"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newPhoneNumber2 = textField
            newPhoneNumber2?.placeholder = "Enter your new phone number again"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            oldPassword = textField
            oldPassword?.placeholder = "Enter your password for confirmation"
        }
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    //Change Admin Pin
    @IBAction func changeAdminPin(sender: UIButton) {
        var newAdminPin1: UITextField?
        var newAdminPin2: UITextField?
        var oldPassword: UITextField?
        let password = self.shared.password
        let alertController = UIAlertController(title: "Update Admin Pin", message: "Please enter your new Admin Pin", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            if newAdminPin1!.text!.isEmpty == false && newAdminPin2!.text!.isEmpty == false && newAdminPin1!.text! == newAdminPin2!.text! && oldPassword!.text == password{
                self.user!["adminPin"] = newAdminPin1!.text
                self.user?.saveInBackground()
                let alert = UIAlertController(title: "Admin Pin", message: "Admin Pin is now updated to \(newAdminPin1!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                self.viewDidLoad()
            }else{
                let alert = UIAlertController(title: "Admin Pin", message: "1) Field is empty. \n2) Password is incorrect/empty. ", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in}
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newAdminPin1 = textField
            newAdminPin1?.placeholder = "Enter your new Admin Pin"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newAdminPin2 = textField
            newAdminPin2?.placeholder = "Enter your new Admin Pin again"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            oldPassword = textField
            oldPassword?.placeholder = "Enter your password for confirmation"
        }
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    //Change Business Reg No
    @IBAction func changeBusinessRegNo(sender: UIButton) {
        var newBusinessRegNo1: UITextField?
        var newBusinessRegNo2: UITextField?
        var oldPassword: UITextField?
        let password = self.shared.password
        let alertController = UIAlertController(title: "Update Admin Pin", message: "Please enter your new Admin Pin", preferredStyle: .Alert)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            if newBusinessRegNo1!.text!.isEmpty == false && newBusinessRegNo2!.text!.isEmpty == false && newBusinessRegNo1!.text! == newBusinessRegNo2!.text! && oldPassword!.text == password{
                self.user!["businessNumber"] = newBusinessRegNo1!.text
                self.user?.saveInBackground()
                let alert = UIAlertController(title: "Admin Pin", message: "Admin Pin is now updated to \(newBusinessRegNo1!.text!)", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
                self.viewDidLoad()
            }else{
                let alert = UIAlertController(title: "Admin Pin", message: "1) Field is empty. \n2) Password is incorrect/empty. ", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in}
        alertController.addAction(ok)
        alertController.addAction(cancel)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newBusinessRegNo1 = textField
            newBusinessRegNo1?.placeholder = "Enter your new Admin Pin"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            newBusinessRegNo2 = textField
            newBusinessRegNo2?.placeholder = "Enter your new Admin Pin again"
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // Enter the textfiled customization code here.
            oldPassword = textField
            oldPassword?.placeholder = "Enter your password for confirmation"
        }
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    //////Changing profile picture
    
    
    // An alert method using the new iOS 8 UIAlertController instead of the deprecated UIAlertview
    // make the alert with the preferredstyle .Alert, make necessary actions, and then add the actions.
    // add to the handler a closure if you want the action to do anything.
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
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
        
        selectNewImage({ (success) -> Void in
            
            // When loading completes,control flow goes here.
            if success {
                print("lalala")
                
                let alert = UIAlertController(title: "Error", message: "Chosen picture exceed size limit.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.Default, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // loadRecordFail fail
                print("Load fail")
            }
        })
        
    }
    
    func selectNewImage(completionHandler: CompletionHandler){
        let refreshAlert = UIAlertController(title: "Update Profile Picture", message: "Please upload your new profile picture.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.shootPhoto()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.photoLibrary()
            
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            self.information.textColor = UIColor.blackColor()
            self.information.text = "Choose image within 10MB"
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        if updated==true{
            
            completionHandler(success: true)
            updated = false
        }
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
        print("Size of Image: \(imageData!.length) bytes")
        print(imageData!.length < 9999999)
        
        if imageData!.length < 9999999{
            let imageFile = PFFile(name: "profilePicture.png", data: imageData!)
            
            
            
            profilePicture.contentMode = .ScaleAspectFit //3
            profilePicture.image = chosenImage //4
            
            updated = true
            self.user!["profilePicture"] = imageFile
            self.updated = true
            self.user?.saveInBackground()
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
    
    
    
    //
    
}