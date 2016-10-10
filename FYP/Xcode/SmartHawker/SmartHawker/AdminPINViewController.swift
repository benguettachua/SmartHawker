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
import Firebase
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
        FIRAnalytics.logEventWithName("appusage", parameters: nil)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        // Activity Indicator
        shared.dateString = nil
        //titlebar.title = "Admin Pin".localized()
        submitButton.setTitle("ENTER".localized(), forState: .Normal)
        //UINavigationItem.title (title: "Admin Pin".localized())
        //self.navItem.title = "Admin Pin".localized()
        self.navigationController?.topViewController?.title="Admin Pin".localized();
        
        cancelAndLogout.setTitle("Cancel".localized(), forState: .Normal)
        
        adminPINTextField.placeholder = "Enter your admin pin".localized()
        
        var faicon = [String: UniChar]()
        faicon["faadminpin"] = 0xf00a
        
        adminpinicon.font = UIFont(name: "FontAwesome", size: 40)
        
        adminpinicon.text = String(format: "%C", faicon["faadminpin"]!)
        
        let records = connectionDAO().loadRecords()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        
        // 3. Check the fingerprint
        authenticationContext.evaluatePolicy(
            .DeviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Enter securely using your fingerprint.".localized(),
            reply: { [unowned self] (success, error) -> Void in
                
                if( success ) {
                    
                    // Fingerprint recognized
                    // Go to view controller
                    self.navigateToAuthenticatedViewController()
                    
                }else {
                    
                    // Check if there is an error
                    if let error = error {
                        
                        let message = self.errorMessageForLAErrorCode(error.code)
                        self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
                        
                    }
                    
                }
                
            })
    }
    
    // *****************************
    // Fingerprint Methods START
    // *****************************
    
    func showAlertViewAfterEvaluatingPolicyWithMessage( message:String ){
        
        showAlertWithTitle("", message: message)
        
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title: "Ok".localized(), style: .Default, handler: nil)
        alertVC.addAction(okAction)
        
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.presentViewController(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    func navigateToAuthenticatedViewController(){
        adminPINController.loadDatesToCalendar()
        self.performSegueWithIdentifier("toMain", sender: self)
    }
    
    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = "Please enter using your PIN.".localized()
        
        return message
        
    }
    
    // *****************************
    // Fingerprint Methods END
    // *****************************
    
    // MARK: Action
    @IBAction func submitPIN(sender: UIButton) {
        
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
    
    // Logs the user out if they are click Cancel
    @IBAction func cancel(sender: UIButton) {
        
        // Red message to capture attention and warn user.
        let attributedString = NSAttributedString(string: "All records that are not synced will be lost.".localized(), attributes: [
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
