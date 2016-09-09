//
//  TransactionFinalViewController.swift
//  SmartHawker
//
//  Created by Gao Min on 24/08/2016.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//


import UIKit
import FontAwesome_iOS

class TransactionFinalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    // Variables
    var type = 0
    var shared = ShareData.sharedInstance
    let picker = UIImagePickerController()
    var imageFile: PFFile!
    
    // UIButton
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var todaybtn: UIButton!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var COGSButton: UIButton!
    @IBOutlet weak var otherExpensesButton: UIButton!
    @IBOutlet weak var typeExpensesButton: UIButton!
    @IBOutlet weak var typeSalesButton: UIButton!
    
    // UILabel
    @IBOutlet weak var descicon: UILabel!
    @IBOutlet weak var imageicon: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var recriptUploadLabel: UILabel!
    @IBOutlet weak var SGDLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    // View
    @IBOutlet weak var amountView: UIView!
    
    // View Did Load
    override func viewDidLoad() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        
        var faicon = [String: UniChar]()
        faicon["faleftback"] = 0xf053
        faicon["fatick"] = 0xf00c
        faicon["facalendar"] = 0xf274
        faicon["fadesc"] = 0xf044
        faicon["faimage"] = 0xf03e
        
        // UIUX Stuff here
        
        
        
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
        
        todaybtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        todaybtn.setTitle(String(format: "%C", faicon["facalendar"]!), forState: .Normal)
        descicon.font = UIFont(name: "FontAwesome", size: 20)
        descicon.text = String(format: "%C", faicon["fadesc"]!)
        imageicon.font = UIFont(name: "FontAwesome", size: 20)
        imageicon.text = String(format: "%C", faicon["faimage"]!)
        
        COGSButton.setTitle("COGS".localized(), forState: UIControlState.Normal)
        otherExpensesButton.setTitle("Other Expenses".localized(), forState: UIControlState.Normal)
        descriptionTextField.placeholder = "Add description".localized()
        recriptUploadLabel.text = "Attach your receipt (etc)".localized()
        
        // Set selected date to label
        var selectedDate = shared.dateString
        if (selectedDate == nil) {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            selectedDate = dateFormatter.stringFromDate(NSDate())
        }
        todayLabel.text = selectedDate
        typeSalesButton.setTitle("Sales".localized(), forState: UIControlState.Normal)
        
        typeExpensesButton.setTitle("Expenses".localized(), forState: UIControlState.Normal)
        //addbtn.setImage(UIImage(named: "defaultReceipt"), forState: .Normal)
        
        typeExpensesButton.setTitle("Expenses".localized(), forState: UIControlState.Normal)
        
    }
    
    // View will appear
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Change the Text colour of the Labels
        if (type == 0) {
            SGDLabel.textColor = hexStringToUIColor("006cff")
            
            // Hide COGS and Expenses button
            COGSButton.hidden = true
            otherExpensesButton.hidden = true
            typeSalesButton.setTitleColor(hexStringToUIColor("006cff"), forState: .Normal)
            typeExpensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        } else {
            SGDLabel.textColor = hexStringToUIColor("ff0000")
            // Hide COGS and Expenses button
            COGSButton.hidden = false
            otherExpensesButton.hidden = false
            typeSalesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
            typeExpensesButton.setTitleColor(hexStringToUIColor("ff0000"), forState: .Normal)
        }
        
        amountTextField.becomeFirstResponder()
        
        // Setting of image
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectSalesType(sender: UIButton) {
        type = 0
        self.viewWillAppear(true)
    }
    
    @IBAction func selectExpensesType(sender: UIButton) {
        type = 1
        self.viewWillAppear(true)
    }
    
    // Changing colour based on colour code
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = cString.substringFromIndex(cString.startIndex.advancedBy(1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.grayColor()
        }
        
        var rgbValue:UInt32 = 0
        NSScanner(string: cString).scanHexInt(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // Select COGS as the type of expenses.
    @IBAction func selectCOGS(sender: UIButton) {
        // Change the type
        type = 1
        
        // Change the colour of buttons
        COGSButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        otherExpensesButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
    }
    
    // Select other expenses as the type.
    @IBAction func selectExpenses(sender: UIButton) {
        // Change the type
        type = 2
        
        // Change the colour of buttons
        COGSButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        otherExpensesButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
    }
    
    // Attach receipt for Audit Purpose
    @IBAction func attachedReceipt(sender: UIButton) {
        //        let comingSoonAlert = UIAlertController(title: "Coming soon".localized(), message: "Function currently developing!".localized(), preferredStyle: .Alert)
        //        comingSoonAlert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: nil))
        //        self.presentViewController(comingSoonAlert, animated: true, completion: nil)
        selectNewImageFromPhotoLibrary()
    }
    
    // Click Save to save edit or new record.
    @IBAction func save(sender: UIButton) {
        
        let recordController = RecordController()
        let description = descriptionTextField.text
        let amount = Double(amountTextField.text!)
        let isSubuser = shared.isSubUser
        let subuser = shared.subuser
        
        // Check if this is a new record.
        
        // New record, save the new record.
        let saveSuccess = recordController.record(description!, amount: amount, isSubuser: isSubuser, subuser: subuser, type: type, receipt: imageFile)
        
        if (saveSuccess) {
            
            // Updates controller
            recordController.loadDatesToCalendar()
            
            // Recording successful, inform the user that they can enter another record.
            let alert = UIAlertController(title: "Success".localized(), message: "Record success, please continue.".localized(), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: { (Void) in
                self.amountTextField.text = ""
                self.descriptionTextField.text = ""
                self.viewWillAppear(true)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            // Recording failed, popup to inform the user.
            let errorAlert = UIAlertController(title: "Error".localized(), message: "Recording failed. Please try again.".localized(), preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "Try again".localized(), style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
    }
    
    //***********************************************************
    // METHODS FOR TAKING PICTURE STARTS
    //***********************************************************
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "This device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "Ok", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
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
    
    
    func selectNewImageFromPhotoLibrary() {
        let refreshAlert = UIAlertController(title: "Upload Receipt", message: "Uploading receipt will save this record online.", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.shootPhoto()
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Photo Library", style: .Default, handler: { (action: UIAlertAction!) in
            
            self.photoLibrary()
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            //            self.information.textColor = UIColor.blackColor()
            //            self.information.text = "Choose image within 10MB"
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
            imageFile = PFFile(name: "receipt", data: imageData!)
            addbtn.setImage(chosenImage, forState: .Normal)
        }else{
            
            // Inform the user that size limit exceeded
            //            information.textColor = UIColor.redColor()
            //            information.text = "Image Not Within 10MB"
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        //        self.information.textColor = UIColor.blackColor()
        //        self.information.text = "Choose image within 10MB"
        dismissViewControllerAnimated(true, completion: nil)
    }
    //***********************************************************
    // METHODS FOR TAKING PICTURE ENDS
    //***********************************************************
}
