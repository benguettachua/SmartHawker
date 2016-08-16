//
//  SubuserViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 5/8/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class SubuserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    // Controllers
    let subuserController = SubuserController()
    
    let user = PFUser.currentUser()
    var subusers = [PFObject]()
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Remove all subusers to prevent duplication
        subusers.removeAll()
        
        // Load subusers into array, which will be used to populate table.
        subusers = subuserController.retrieveSubusers()
        
        // Reload the data to show any ammendments made
        tableView.reloadData()
        tableView!.delegate = self
        tableView!.dataSource = self
    }
    
    override func viewDidAppear(animated: Bool) {
        self.viewDidLoad()
    }
    
    //  Back
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Below this comment are all the methods for table.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subusers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "SubuserCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SubuserTableViewCell
        
        // Address
        let address = subusers[indexPath.row]["address"]
        cell.businessAddressLabel.text = address as? String
        // Name
        let name = subusers[indexPath.row]["name"]
        cell.subuserNameLabel.text = name as? String
        // Profile Pic
        cell.userProfilePicImageView.image = UIImage(named: "defaultProfilePic")
        
        // Cell background transparent
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // When user clicks on a subuser, a popup will ask user what he would like to do with the subuser.
        let alert = UIAlertController(title: "Edit subuser", message: "What would you like to do with " + (subusers[indexPath.row]["name"] as! String) + "?", preferredStyle: .Alert)
        
        // Declare the subuser selected to be used later on.
        let subuser = self.subusers[indexPath.row]
        
        // Action 1: Edit PIN
        alert.addAction(UIAlertAction(title: "Edit PIN", style: .Default, handler: { Void in
            let editPINAlert = UIAlertController(title: "Edit PIN", message: "Please enter old PIN and new PIN.", preferredStyle: .Alert)
            
            // Save the edit of PIN.
            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { Void in
                
                let firstTextField = editPINAlert.textFields![0] as UITextField
                let secondTextField = editPINAlert.textFields![1] as UITextField
                let thirdTextField = editPINAlert.textFields![2] as UITextField
                
                let enteredOldPIN = firstTextField.text
                let enteredNewPIN = secondTextField.text
                let enteredConfirmPIN = thirdTextField.text
                
                // Hand over to controller to validate the inputs and see if edit is successful.
                let successEdit = self.subuserController.editPIN(subuser, oldPIN: enteredOldPIN!, newPIN: enteredNewPIN!, confirmPIN: enteredConfirmPIN!)
                
                if (successEdit) {
                    
                    // Edit successful, popup to show user that the PIN has been changed.
                    editPINAlert.dismissViewControllerAnimated(true, completion: nil)
                    let successAlert = UIAlertController(title: "Success", message: "PIN has been changed!", preferredStyle: .Alert)
                    successAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { Void in
                        self.viewWillAppear(true)
                    }))
                    self.presentViewController(successAlert, animated: true, completion: nil)
                    
                } else {
                    
                    // Edit failed, popup to tell user to try again.
                    editPINAlert.dismissViewControllerAnimated(true, completion: nil)
                    let failedAlert = UIAlertController(title: "Failed", message: "PIN is not changed. Please try again.", preferredStyle: .Alert)
                    failedAlert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: { Void in
                        self.viewWillAppear(true)
                    }))
                    self.presentViewController(failedAlert, animated: true, completion: nil)
                }
            })
            
            editPINAlert.addTextFieldWithConfigurationHandler({ (firstTextField) in
                firstTextField.placeholder = "Enter Old PIN"
                firstTextField.secureTextEntry = true
                firstTextField.keyboardType = UIKeyboardType.NumberPad
            })
            editPINAlert.addTextFieldWithConfigurationHandler({ (secondTextField) in
                secondTextField.placeholder = "Enter New PIN"
                secondTextField.secureTextEntry = true
                secondTextField.keyboardType = UIKeyboardType.NumberPad
            })
            editPINAlert.addTextFieldWithConfigurationHandler({ (thirdTextField) in
                thirdTextField.placeholder = "Confirm New PIN"
                thirdTextField.secureTextEntry = true
                thirdTextField.keyboardType = UIKeyboardType.NumberPad
            })
            editPINAlert.addAction(saveAction)
            editPINAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { Void in
                self.viewWillAppear(true)
            }))
            self.presentViewController(editPINAlert, animated: true, completion: nil)
        }))
        
        // Action 2: Delete the subuser.
        alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { Void in
            
            // Popup to warn user that once deleted, the action cannot be undone.
            let confirmation = UIAlertController(title: "Are you sure?", message: (self.subusers[indexPath.row]["name"] as! String) + " will be permanently deleted.", preferredStyle: .Alert)
            confirmation.addAction(UIAlertAction(title: "Yes, delete", style: .Default, handler: { Void in
                
                // Deletes the subuser selected.
                let deleteSuccess = self.subuserController.deleteSubuser(subuser)
                
                if (deleteSuccess) {
                    
                    // Delete success, inform the user that the subuser is deleted.
                    confirmation.dismissViewControllerAnimated(true, completion: nil)
                    let successAlert = UIAlertController(title: "Success", message: "Subuser has been deleted!", preferredStyle: .Alert)
                    successAlert.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { Void in
                        self.viewWillAppear(true)
                    }))
                    self.presentViewController(successAlert, animated: true, completion: nil)
                } else {
                    
                    // Delete failed, inform the user to try again.
                    confirmation.dismissViewControllerAnimated(true, completion: nil)
                    let failedAlert = UIAlertController(title: "Failed", message: "An error has occured, please try again later.", preferredStyle: .Alert)
                    failedAlert.addAction(UIAlertAction(title: "Try again", style: .Default, handler: { Void in
                        self.viewWillAppear(true)
                    }))
                    self.presentViewController(failedAlert, animated: true, completion: nil)
                }
            }))
            
            
            // User choose not to delete the subuser.
            confirmation.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { Void in
                self.viewWillAppear(true)
            }))
            self.presentViewController(confirmation, animated: true, completion: nil)
        }))
        
        // Action 3: Do nothing to the subuser.
        alert.addAction(UIAlertAction(title: "Nothing", style: UIAlertActionStyle.Default, handler: { Void in
            self.viewWillAppear(true)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
