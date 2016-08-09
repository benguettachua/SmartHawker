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
    let user = PFUser.currentUser()
    var subusers = [PFObject]()
    
    // Table View
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveSubuser()
        tableView!.delegate = self
        tableView!.dataSource = self
        self.viewWillAppear(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        print("Reloading")
        tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.viewDidLoad()
    }
    
    //  Back
    @IBAction func back(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Retrieve all subusers.
    func retrieveSubuser() {
        
        let query = PFQuery(className: "SubUser")
        query.fromLocalDatastore()
        query.whereKey("user", equalTo: user!)
        do{
            subusers = try query.findObjects()
        } catch {
            print("Something wrong")
        }
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
        let alert = UIAlertController(title: "Edit subuser", message: "What would you like to do with " + (subusers[indexPath.row]["name"] as! String) + "?", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Edit PIN", style: .Default, handler: { Void in
            let editPINAlert = UIAlertController(title: "Edit PIN", message: "Please enter old PIN and new PIN.", preferredStyle: .Alert)
            
            // Save the edit of PIN.
            let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default, handler: { Void in
                
                let firstTextField = editPINAlert.textFields![0] as UITextField
                let secondTextField = editPINAlert.textFields![1] as UITextField
                let thirdTextField = editPINAlert.textFields![2] as UITextField
                
                let currentPIN = self.subusers[indexPath.row]["pin"] as! String
                print(currentPIN)
                if (firstTextField.text != currentPIN) {
                    let error = UIAlertController(title: "Error", message: "Old PIN is incorrect!", preferredStyle: .Alert)
                    error.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: { Void in
                        self.viewWillAppear(true)
                    }))
                    self.presentViewController(error, animated: true, completion: nil)
                } else if (secondTextField.text != thirdTextField.text) {
                    let error = UIAlertController(title: "Error", message: "Confirmation PIN is incorrect!", preferredStyle: .Alert)
                    error.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: { Void in
                        self.viewWillAppear(true)
                    }))
                    self.presentViewController(error, animated: true, completion: nil)
                } else if (secondTextField.text?.characters.count != 4) {
                    let error = UIAlertController(title: "Error", message: "PIN must be 4 digits!", preferredStyle: .Alert)
                    error.addAction(UIAlertAction(title: "Try Again", style: .Default, handler: { Void in
                        self.viewWillAppear(true)
                    }))
                    self.presentViewController(error, animated: true, completion: nil)
                } else {
                    // All validation passed, proceed to change PIN
                    let query = PFQuery(className: "SubUser")
                    query.whereKey("pin", equalTo: currentPIN)
                    do{
                        let subuser = try query.getFirstObject()
                        // subuser is found, proceed to update.
                        subuser["pin"] = secondTextField.text
                        do {try subuser.pin()} catch {}
                        do {try subuser.save()} catch {}
                        let success = UIAlertController(title: "Success", message: "PIN has been changed!", preferredStyle: .Alert)
                        success.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { Void in
                            self.viewWillAppear(true)
                        }))
                        self.presentViewController(success, animated: true, completion: nil)
                    } catch {}
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
        alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { Void in
            let confirmation = UIAlertController(title: "Are you sure?", message: (self.subusers[indexPath.row]["name"] as! String) + " will be permanently deleted.", preferredStyle: .Alert)
            confirmation.addAction(UIAlertAction(title: "Yes, delete", style: .Default, handler: { Void in
                let query = PFQuery(className: "SubUser")
                let currentPIN = self.subusers[indexPath.row]["pin"] as! String
                query.whereKey("pin", equalTo: currentPIN)
                do{
                    let subuser = try query.getFirstObject()
                    // subuser is found, proceed to delete.
                    do {try subuser.unpin()} catch {}
                    do {try subuser.delete()} catch {}
                    let success = UIAlertController(title: "Success", message: "Subuser is deleted!", preferredStyle: .Alert)
                    success.addAction(UIAlertAction(title: "Continue", style: .Default, handler: { Void in
                        self.subusers.removeAtIndex(indexPath.row)
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                        self.viewWillAppear(true)
                    }))
                    self.presentViewController(success, animated: true, completion: nil)
                } catch {}
            }))
            confirmation.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { Void in
                self.viewWillAppear(true)
            }))
            self.presentViewController(confirmation, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Nothing", style: UIAlertActionStyle.Default, handler: { Void in
            self.viewWillAppear(true)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}
