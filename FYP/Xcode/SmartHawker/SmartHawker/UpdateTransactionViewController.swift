//
//  UpdateTransactionViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 29/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class UpdateTransactionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    // Variables
    var shared = ShareData.sharedInstance
    var type = Int()
    let picker = UIImagePickerController()
    var imageFile: PFFile!
    var hasReceipt = false
    
    // TextField
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    // Buttons
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var todaybtn: UIButton!
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet weak var SGDLabel: UILabel!
    
    // Label
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var descicon: UILabel!
    @IBOutlet weak var imageicon: UILabel!
    
    // Segment Control
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    

    
    
    // View
    @IBOutlet weak var amountView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get the selectedRecord to update.
        let selectedRecord = shared.selectedRecord
        
        // Set selected date to label
        let selectedDate = selectedRecord["date"] as! String
        todayLabel.text = selectedDate
        
        // Get the type of the record
        type = selectedRecord["type"] as! Int
        categorySegmentControl.selectedSegmentIndex = type
        
        // Get the description of the record
        var description = selectedRecord["description"]
        if (description == nil) {
            description = "No Description.".localized()
            descriptionTextField.placeholder = description as? String
        }else{
            descriptionTextField.text = description as? String
        }
        // Get the amount of the record
        let amount = selectedRecord["amount"] as! Double
        amountTextField.text = String(amount)
        
        // Show the receipt of the record, if any.
        let userImageFile = selectedRecord["receipt"]
        if userImageFile != nil {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.addbtn.setImage(image, forState: .Normal)
                        self.hasReceipt = true
                    }
                }
            }
        }
        
        var faicon = [String: UniChar]()
        faicon["fatrash"] = 0xf1f8
        faicon["faleftback"] = 0xf053
        faicon["fatick"] = 0xf00c
        faicon["facalendar"] = 0xf274
        faicon["fadesc"] = 0xf044
        faicon["faimage"] = 0xf03e
        
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
    }
    
    override func viewWillAppear(animated: Bool) {
        // Change the Text colour of the Labels
        if (type == 0) {
            SGDLabel.textColor = hexStringToUIColor("006cff")
        } else {
            SGDLabel.textColor = hexStringToUIColor("ff0000")
        }
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
    
    @IBAction func back(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func changeCategory(sender: UISegmentedControl) {
        
        if (categorySegmentControl.selectedSegmentIndex == 0) {
            
            // Sales
            type = 0
            SGDLabel.textColor = hexStringToUIColor("006cff")
        } else if (categorySegmentControl.selectedSegmentIndex == 1) {
            
            // COGS
            type = 1
            SGDLabel.textColor = hexStringToUIColor("ff0000")
        } else if (categorySegmentControl.selectedSegmentIndex == 2) {
            
            // Expenses
            type = 2
            SGDLabel.textColor = hexStringToUIColor("ff0000")
        }
    }
    
    // Attach receipt for Audit Purpose
    @IBAction func attachedReceipt(sender: UIButton) {
        if connectionDAO().isConnectedToNetwork(){
            selectNewImageFromPhotoLibrary()
        } else {
            let alert = UIAlertController(title: "Failed".localized(), message: "You must be conneced to the internet to update image.".localized(), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // Click Save to save edit or new record.
    @IBAction func save(sender: UIButton) {
        
        let recordController = RecordController()
        let description = descriptionTextField.text
        let amount = Double(amountTextField.text!)
        
        let localIdentifier = shared.selectedRecord["subUser"] as! String
        let updateSuccess = recordController.update(localIdentifier, type: type, description: description!, amount: amount, receipt: imageFile, hasReceipt: hasReceipt)
        
        if (updateSuccess) {
            
            // Updates controller
            recordController.loadDatesToCalendar()
            
            // Recording successful, inform the user that they can enter another record.
            let alert = UIAlertController(title: "Successfully Updated".localized(), message: "Please continue.".localized(), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: { (Void) in
                self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
            }))
            self.presentViewController(alert, animated: true, completion: nil)
            
        } else {
            
            // Recording failed, popup to inform the user.
            let errorAlert = UIAlertController(title: "Error".localized(), message: "Updating failed. Please try again.".localized(), preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "Try again".localized(), style: .Default, handler: nil))
            self.presentViewController(errorAlert, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func deleteRecord(sender: UIButton) {
        let selectedRecord = shared.selectedRecord
        let recordController = RecordController()
        
        let warningAlert = UIAlertController(title: "Are you sure?".localized(), message: "Record will be permanently deleted.".localized(), preferredStyle: .Alert)
        warningAlert.addAction(UIAlertAction(title: "No".localized(), style: .Default, handler: nil))
        warningAlert.addAction(UIAlertAction(title: "Yes".localized(), style: .Default, handler: { void in
            let deleteSuccess = recordController.deleteRecord(selectedRecord)
            
            if (deleteSuccess) {
                // Updates controller
                recordController.loadDatesToCalendar()
                
                // Deleting successful, inform the user
                let alert = UIAlertController(title: "Success".localized(), message: "Record deleted, please continue.".localized(), preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: { (Void) in
                    self.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
                }))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                
                // Delete failed, popup to inform the user.
                let errorAlert = UIAlertController(title: "Error".localized(), message: "Deleting failed. Please try again.".localized(), preferredStyle: .Alert)
                errorAlert.addAction(UIAlertAction(title: "Try again".localized(), style: .Default, handler: nil))
                self.presentViewController(errorAlert, animated: true, completion: nil)
            }
        }))
        self.presentViewController(warningAlert, animated: true, completion: nil)
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
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction) in
            self.imageFile = nil
            self.addbtn.setImage(nil, forState: .Normal)
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
            hasReceipt = true
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
    
    // Changing Dates of the record
    @IBAction func changeDate(sender: UIButton) {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // Creating the date picker
        let picker : UIDatePicker = UIDatePicker()
        picker.datePickerMode = .Date
        let pickerSize : CGSize = picker.sizeThatFits(CGSizeZero)
        
        // Adding date picker to a custom view to be added to the alert.
        let margin:CGFloat = 8.0
        let rect = CGRectMake(margin, margin, alertController.view.bounds.size.width - margin * 4.0, pickerSize.height)
        let customView = UIView(frame: rect)
        picker.frame = CGRectMake(customView.frame.size.width/2 - pickerSize.width/2, margin, pickerSize.width, pickerSize.height/2)
        customView.addSubview(picker)
        alertController.view.addSubview(customView)
        
        let cancelAction = UIAlertAction(title: "Done", style: .Default, handler: { void in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.todayLabel.text = dateFormatter.stringFromDate(picker.date)
            self.shared.dateString = dateFormatter.stringFromDate(picker.date)
        })
        
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:{})
    }
}

