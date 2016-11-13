//
//  AdminPINViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 16/7/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import Material
import FontAwesome_iOS
import LocalAuthentication

class AdminPINViewController: UIViewController {
    
    // MARK: Properties
    
    // Controllers
    let adminPINController = AdminPINController()
    
    // Variables
    let user = PFUser.currentUser()
    var shared = ShareData.sharedInstance
    
    // Text Fields
    @IBOutlet weak var adminPINTextField: UITextField!
    
    // Buttons
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var cancelAndLogout: UIButton!
    @IBOutlet weak var resetWithEmail: UIButton!
    @IBOutlet weak var resetWithPhone: UIButton!
    // Labels
    @IBOutlet weak var adminPINLabel: UILabel!
    
    @IBOutlet weak var adminpinicon: UILabel!
    //viewDidLoad
    
    //override func viewWillAppear(animated: Bool) {
    //let navigationItem = UINavigationItem(title: "Admin Pin".localized())
    
    //navBar.items = [navigationItem];
    
    //cancelAndLogout.setTitle("Cancel".localized(), forState: .Normal)
    //self.navItem.title = "Second View"
    
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        // Activity Indicator
        shared.dateString = nil
        //titlebar.title = "Admin Pin".localized()
        submitButton.setTitle("ENTER".localized(), forState: .Normal)
        //UINavigationItem.title (title: "Admin Pin".localized())
        //self.navItem.title = "Admin Pin".localized()
        self.navigationController?.topViewController?.title="Admin Pin".localized();
        
        cancelAndLogout.setTitle("Cancel".localized(), forState: .Normal)
        resetWithEmail.setTitle("Reset PIN with Email".localized(), forState: .Normal)
        resetWithPhone.setTitle("Reset PIN with Phone Number".localized(), forState: .Normal)
        
        adminPINTextField.placeholder = "Enter your admin pin".localized()
        
        var faicon = [String: UniChar]()
        faicon["faadminpin"] = 0xf00a
        
        adminpinicon.font = UIFont(name: "FontAwesome", size: 40)
        
        adminpinicon.text = String(format: "%C", faicon["faadminpin"]!)
        
        let records = connectionDAO().loadRecords()
        
        // Ask the user for fingerprint authentication, if the device has touch id set up.
        // 1. Create a authentication context
        let authenticationContext = LAContext()
        
        // 2. Check if the device has a fingerprint sensor
        var error:NSError?
        // If not, show the user an alert view and bail out!
        guard authenticationContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) else {
            
            // The device does not have touch id sensor, thus dont show the touch ID.
            return
        }
        
        // 3. Validate the fingerprint
        [authenticationContext .evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Enter securely using your fingerprint.".localized(), reply: { (success: Bool, evalPolicyError: NSError?) -> Void in
            
            if success {
                
                let alertVC = UIAlertController(title: "Authentication Success. Welcome Back!".localized(), message: "", preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "Ok".localized(), style: .Default, handler: { Void in
                    self.adminPINController.loadDatesToCalendar()
                    self.performSegueWithIdentifier("toMain", sender: self)
                })
                alertVC.addAction(okAction)
                self.presentViewController(alertVC, animated: true, completion: nil)
                
                
            }
            
        })]
        
    }
    
    // MARK: Action
    @IBAction func submitPIN() {
        
        let adminPin = user!["adminPin"] as! String
        let pinEntered = adminPINTextField.text
        
        let pinType = adminPINController.submitPIN(pinEntered!, adminPIN: adminPin)
        if (pinType == 2) {
            
            // Invalid PIN, inform the user that the PIN entered is incorrect.
            adminPINTextField.text = ""
            adminPINTextField.attributedPlaceholder = NSAttributedString(string:"Incorrect PIN".localized().localized(), attributes: [NSForegroundColorAttributeName: UIColor.redColor()])
            
        } else {
            
            adminPINController.loadDatesToCalendar()
            self.performSegueWithIdentifier("toMain", sender: self)
        }
    }
    
    @IBAction func forgotPINWithPhone() {
        
        let phoneNo = user!["phoneNumber"] as! String
        
        let alert = UIAlertController(title: "Reset PIN".localized(), message: "What is Your Phone Number?".localized(), preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Proceed".localized(), style: .Default, handler: { Void in
            
            let targetTextField = alert.textFields![0] as UITextField
            if (targetTextField.text != nil && targetTextField.text != "") {
                //puts a method to reset the adminPIN for the user after checking if the phone number is correct or not
                if (targetTextField.text == phoneNo) {
                    self.resetAdminPIN()
                }else{
                    let alert = UIAlertController(title: "Error".localized(), message: "Phone Number is incorrect.".localized(), preferredStyle: .Alert)
                    alert.addAction((UIAlertAction(title: "Try again".localized(), style: .Default, handler: nil)))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            } else {
                let alert = UIAlertController(title: "Error".localized(), message: "Phone Number cannot be empty.".localized(), preferredStyle: .Alert)
                alert.addAction((UIAlertAction(title: "Try again".localized(), style: .Default, handler: nil)))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        
        alert.addTextFieldWithConfigurationHandler({ (targetTextField) in
            targetTextField.placeholder = "Enter your Phone Number".localized()
            targetTextField.keyboardType = UIKeyboardType.DecimalPad
        })
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { Void in
            self.viewWillAppear(true)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func forgotPINWithEmail() {
        
        let email = user!["email"] as! String
        
        let alert = UIAlertController(title: "Reset PIN".localized(), message: "What is Your Email?".localized(), preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Proceed".localized(), style: .Default, handler: { Void in
            
            let targetTextField = alert.textFields![0] as UITextField
            if (targetTextField.text != nil && targetTextField.text != "") {
                //puts a method to reset the adminPIN for the user after checking if the phone number is correct or not
                if (targetTextField.text == email) {
                    self.resetAdminPIN()
                }else{
                    let alert = UIAlertController(title: "Error".localized(), message: "Email is incorrect.".localized(), preferredStyle: .Alert)
                    alert.addAction((UIAlertAction(title: "Try again".localized(), style: .Default, handler: nil)))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                
            } else {
                let alert = UIAlertController(title: "Error".localized(), message: "Email cannot be empty.".localized(), preferredStyle: .Alert)
                alert.addAction((UIAlertAction(title: "Try again".localized(), style: .Default, handler: nil)))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        
        alert.addTextFieldWithConfigurationHandler({ (targetTextField) in
            targetTextField.placeholder = "Enter your Email".localized()
        })
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { Void in
            self.viewWillAppear(true)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func resetAdminPIN(){
        
        let alert = UIAlertController(title: "Reset PIN".localized(), message: "What is Your New PIN?".localized(), preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Change".localized(), style: .Default, handler: { Void in
            
            let targetTextField = alert.textFields![0] as UITextField
            if (targetTextField.text != nil && targetTextField.text != "") {
                //puts a method to reset the adminPIN for the user after checking if the phone number is correct or not
            
                connectionDAO().edit(targetTextField.text!)
            } else {
                let alert = UIAlertController(title: "Error".localized(), message: "PIN cannot be empty.".localized(), preferredStyle: .Alert)
                alert.addAction((UIAlertAction(title: "Try again".localized(), style: .Default, handler: nil)))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        
        alert.addTextFieldWithConfigurationHandler({ (targetTextField) in
            targetTextField.placeholder = "Enter your New PIN".localized()
            targetTextField.secureTextEntry = true
            targetTextField.keyboardType = UIKeyboardType.DecimalPad
        })
        
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { Void in
            self.viewWillAppear(true)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // Logs the user out if they are click Cancel
    @IBAction func cancel() {
        
        // Red message to capture attention and warn user.
        let attributedString = NSAttributedString(string: "Records that are not synced may be lost.".localized(), attributes: [
            NSForegroundColorAttributeName : UIColor.redColor()
            ])
        // Alert to warn user about logging out.
        let logoutAlert = UIAlertController(title: "Are you sure?".localized(), message: "", preferredStyle: .Alert)
        logoutAlert.setValue(attributedString, forKey: "attributedMessage")
        
        // Option 1: Sync then logout.
        logoutAlert.addAction(UIAlertAction(title: "Sync".localized(), style: .Default, handler: { void in
            // Pop up telling the user that you are currently syncing
            let popup = UIAlertController(title: "Syncing".localized(), message: "Please wait.".localized(), preferredStyle: .Alert)
            self.presentViewController(popup, animated: true, completion: {
                let syncSucceed = self.adminPINController.sync()
                if (syncSucceed) {
                    
                    // Retrieval succeed, inform the user that records are synced.
                    popup.dismissViewControllerAnimated(true, completion: {
                        let alertController = UIAlertController(title: "Sync Complete!".localized(), message: nil, preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "Ok".localized(), style: .Cancel, handler: { void in
                            let alert = UIAlertController(title: "Logging Out".localized(), message: "Please Wait".localized(), preferredStyle: .Alert)
                            self.presentViewController(alert, animated: true,completion: {
                                
                                self.shared.clearData()
                                //connectionDAO().unloadRecords()
                                connectionDAO().logout()
                                self.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
                            })
                        })
                        alertController.addAction(ok)
                        self.presentViewController(alertController, animated: true,completion: nil)
                    })
                    
                } else {
                    
                    // Retrieval failed, inform user that he can sync again after he log in.
                    popup.dismissViewControllerAnimated(true, completion: {
                        let alertController = UIAlertController(title: "Sync Failed!".localized(), message: nil, preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "Ok".localized(), style: .Cancel, handler: nil)
                        alertController.addAction(ok)
                        self.presentViewController(alertController, animated: true,completion: nil)
                    })
                }
            })
        }))
        
        // Option 2: Continue logging out despite the warning.
        logoutAlert.addAction(UIAlertAction(title: "Yes".localized(), style: .Default, handler: { void in
            
            let alertController = UIAlertController(title: "Logging Out".localized(), message: "Please Wait".localized(), preferredStyle: .Alert)
            self.presentViewController(alertController, animated: true,completion: {
                
                self.shared.clearData()
                connectionDAO().unloadRecords()
                connectionDAO().logout()
                self.view.window!.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
            })
            //            self.presentViewController(alertController, animated: true, completion: nil)
        }))
        
        // Option 3: Cancel the logging out.
        logoutAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Cancel, handler: nil))
        self.presentViewController(logoutAlert, animated: true, completion: nil)
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
}
