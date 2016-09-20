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
    
    // Segment Control
    @IBOutlet weak var categorySegmentControl: UISegmentedControl!
    
    // UIButton
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var todaybtn: UIButton!
    @IBOutlet weak var addbtn: UIButton!
    
    // UILabel
    @IBOutlet weak var descicon: UILabel!
    @IBOutlet weak var imageicon: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var recriptUploadLabel: UILabel!
    @IBOutlet weak var SGDLabel: UILabel!
    
    // Text Fields
    @IBOutlet weak var descriptionTextField: AutoCompleteTextField!
    @IBOutlet weak var amountTextField: UITextField!
    
    // View
    @IBOutlet weak var amountView: UIView!
    
    // View Did Load
    override func viewDidLoad() {
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TransactionFinalViewController.handleTap(_:))))
        
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

        
    }
    
    // View will appear
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        categorySegmentControl.setTitle("Sales".localized(), forSegmentAtIndex: 0)
        categorySegmentControl.setTitle("COGS".localized(), forSegmentAtIndex: 1)
        categorySegmentControl.setTitle("Expenses".localized(), forSegmentAtIndex: 2)
        addbtn.setTitle("Tap to add receipt".localized(), forState: UIControlState.Normal)
        // Change the Text colour of the Labels
        if (type == 0) {
            SGDLabel.textColor = hexStringToUIColor("006cff")
        } else {
            SGDLabel.textColor = hexStringToUIColor("ff0000")
        }
        
        amountTextField.becomeFirstResponder()
        
        connectionDAO().loadStringIntoAutoFill()
        configureTextField()
        handleTextFieldInterfaces()
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
    
    // Change the category of the record.
    @IBAction func chooseCategory(sender: UISegmentedControl) {
        
        if (categorySegmentControl.selectedSegmentIndex == 0) {
            
            // Sales
            type = 0
            SGDLabel.textColor = hexStringToUIColor("006cff")
        } else if (categorySegmentControl.selectedSegmentIndex == 1) {
            
            // COGS
            type = 1
            SGDLabel.textColor = hexStringToUIColor("FD7200")
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
            let alert = UIAlertController(title: "Failed".localized(), message: "You must be conneced to the internet to save image.".localized(), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // Click Save to save edit or new record.
    @IBAction func save(sender: UIButton) {
        
        let recordController = RecordController()
        let description = descriptionTextField.text
        let amount = Double(amountTextField.text!)
        let isSubuser = shared.isSubUser
        let subuser = shared.subuser
        
        // New record, save the new record.
        let saveSuccess = recordController.record(description!, amount: amount, isSubuser: isSubuser, subuser: subuser, type: type, receipt: imageFile)
        
        if (saveSuccess) {
            
            // Updates controller
            recordController.loadDatesToCalendar()
            
            // Recording successful, inform the user that they can enter another record.
            let alert = UIAlertController(title: "Successfully Saved!".localized(), message: "Please continue.".localized(), preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: { (Void) in
                self.amountTextField.text = ""
                self.descriptionTextField.text = ""
                self.addbtn.setImage(nil, forState: .Normal)
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
    
    func configureTextField(){
        descriptionTextField.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        descriptionTextField.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 16.0)!
        descriptionTextField.autoCompleteCellHeight = 35.0
        descriptionTextField.maximumAutoCompleteCount = 1
        descriptionTextField.hidesWhenSelected = true
        descriptionTextField.hidesWhenEmpty = true
        descriptionTextField.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        descriptionTextField.autoCompleteAttributes = attributes
    }
    
    func handleTextFieldInterfaces(){
        descriptionTextField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                self?.fetchAutocompletePlaces(text)
            }
        }
        
    }
    
    //MARK: - Private Methods
    
    
    private func fetchAutocompletePlaces(keyword:String) {
        var array = shared.stringsWithAutoFill
        var locations = [String]()
        for word in array{
            if word.containsString(keyword){
                locations.append(word)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.descriptionTextField.autoCompleteStrings = locations
        })
        
        
    }
}
