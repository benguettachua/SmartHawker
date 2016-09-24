//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import Material
import FontAwesome_iOS
import Localize_Swift

class LoginViewController: UIViewController {
    
    // MARK: Properties
    // Controller
    let loginController = LoginController()
    var actionSheet: UIAlertController!
    let adminPINController = AdminPINController()
    
    // Text Fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    let availableLanguages = Localize.availableLanguages()
    
    @IBOutlet weak var changeLangButton: UIButton!
    @IBOutlet weak var mobileicon: UILabel!
    @IBOutlet weak var passwordicon: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var smarthawkerLogo: UILabel!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var registerButton: UIButton!
    // Shared Data
    let shared = ShareData.sharedInstance
    // MARK: Action
    // This function is called when the user clicks log in at the login page.
    @IBAction func login(sender: UIButton) {
        if connectionDAO().isConnectedToNetwork(){
            // There is an alert to inform the user that it is currently logging in.
            let loggingInAlert = UIAlertController(title: "Logging In".localized(), message: "Please wait.".localized(), preferredStyle: .Alert)
            self.presentViewController(loggingInAlert, animated: true, completion: {
                let username = self.usernameTextField.text
                let password = self.passwordTextField.text
                
                // Calls controller to log in using the entered parameters.
                let loginSuccess = self.loginController.login(username!, password: password!)
                if (loginSuccess) {
                    
                    
                    self.shared.clearData()
                    
                    // Set just logged in to true to prompt to retrieve record
                    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "justLoggedIn")
                    NSUserDefaults.standardUserDefaults().setObject(password, forKey: "password")
                    
                    // Logging in success, logging in alert is dissmissed, scene is moved to admin page.
                    loggingInAlert.dismissViewControllerAnimated(false, completion: {
                        
                        // Load dates with records into calendar.
                        self.adminPINController.loadDatesToCalendar()
                        
                        
                        // Set first time logged in to False, so this popup appears only once, when you just logged in.
                        let alertController = UIAlertController(title: "Welcome".localized(), message: "Do you want to retrieve past records online?".localized(), preferredStyle: .Alert)
                        let ok = UIAlertAction(title: "Yes".localized(), style: .Default, handler: { (action) -> Void in
                            
                            // Pop up telling the user that you are currently syncing
                            let popup = UIAlertController(title: "Syncing".localized(), message: "Please wait.".localized(), preferredStyle: .Alert)
                            self.presentViewController(popup, animated: true, completion: {
                                let syncSucceed = self.adminPINController.sync()
                                if (syncSucceed) {
                                    
                                    // Retrieval succeed, inform the user that records are synced.
                                    popup.dismissViewControllerAnimated(true, completion: {
                                        let alertController = UIAlertController(title: "Retrieval Complete!".localized(), message: "Please proceed.".localized(), preferredStyle: .Alert)
                                        let ok = UIAlertAction(title: "Ok".localized(), style: .Cancel, handler: { void in
                                            self.adminPINController.loadDatesToCalendar()
                                            self.performSegueWithIdentifier("loginSuccess", sender: self)
                                        })
                                        alertController.addAction(ok)
                                        self.presentViewController(alertController, animated: true,completion: nil)
                                    })
                                    
                                } else {
                                    
                                    // Retrieval failed, inform user that he can sync again after he log in.
                                    popup.dismissViewControllerAnimated(true, completion: {
                                        let alertController = UIAlertController(title: "Retrieval Failed!".localized(), message: "You may sync your data again at settings page.".localized(), preferredStyle: .Alert)
                                        let ok = UIAlertAction(title: "Ok".localized(), style: .Cancel, handler: { void in
                                            self.adminPINController.loadDatesToCalendar()
                                            self.performSegueWithIdentifier("loginSuccess", sender: self)
                                        })
                                        alertController.addAction(ok)
                                        self.presentViewController(alertController, animated: true,completion: nil)
                                    })
                                }
                            })
                            
                        })
                        let no = UIAlertAction(title: "No".localized(), style: .Cancel, handler: { void in
                            self.performSegueWithIdentifier("loginSuccess", sender: self)
                        })
                        alertController.addAction(ok)
                        alertController.addAction(no)
                        self.adminPINController.loadDatesToCalendar()
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        
                    })
                } else {
                    
                    // Logging in failed, logging in alert is dismissed, login failed alert is shown
                    loggingInAlert.dismissViewControllerAnimated(false, completion: {
                        let alert = UIAlertController(title: "Error".localized(), message: "Login not successful, please try again.".localized(), preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Close".localized(), style: UIAlertActionStyle.Default, handler: nil))
                        
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                }
            })
        }else{
            let alert = UIAlertController(title: "Internet Connection is down.".localized(), message: "Login not successful, please try again.".localized(), preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Close".localized(), style: UIAlertActionStyle.Default, handler: nil))
        }
    }
    
    // This function is called when the user clicks on forget password at the login page.
    @IBAction func forgetPassword(sender: UIButton) {
        
        // An alert window will pop up asking the user to enter their email.
        let alert = UIAlertController(title: "Forgot password".localized(), message: "Enter your email".localized(), preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Send".localized(), style: .Default, handler: { (Void) in
            let emailTextField = alert.textFields![0] as UITextField
            let email = emailTextField.text
            
            // Upon clicking "Send" from the pop up, this alert will show to inform the user that the server is now sending mail to their email.
            let sendingMailAlert = UIAlertController(title: "Sending mail".localized(), message: "Please wait.".localized(), preferredStyle: .Alert)
            self.presentViewController(sendingMailAlert, animated: true, completion: {
                
                let emailSent = self.loginController.forgetPassword(email!)
                if (emailSent) {
                    
                    // Sending mail success, the user will receive an email to change their password.
                    sendingMailAlert.dismissViewControllerAnimated(true, completion: {
                        let successAlert = UIAlertController(title: "Success".localized(), message: "Password change have been sent to: ".localized() + emailTextField.text!.lowercaseString, preferredStyle: .Alert)
                        successAlert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: nil))
                        self.presentViewController(successAlert, animated: true, completion: nil)
                    })
                } else {
                    
                    // Sending mail failed, the user will see this pop up notifying them to try again later.
                    sendingMailAlert.dismissViewControllerAnimated(true, completion: {
                        let failAlert = UIAlertController(title: "Failed".localized(), message: "An error has occured, please try again later.".localized(), preferredStyle: .Alert)
                        failAlert.addAction(UIAlertAction(title: "Ok".localized(), style: .Default, handler: nil))
                        self.presentViewController(failAlert, animated: true, completion: nil)
                    })
                    
                }
            })
        }))
        alert.addTextFieldWithConfigurationHandler({ (emailTextField) in
            emailTextField.placeholder = "Enter your email".localized()
            emailTextField.keyboardType = UIKeyboardType.EmailAddress
        })
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(true, forKey: "firstLaunch")
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LoginViewController.handleTap(_:))))
        usernameTextField.placeholder = "Username".localized()
        passwordTextField.placeholder = "Password".localized()
        smarthawkerLogo.text? = "SmartHawker © 2016".localized()
        loginButton.setTitle("LOGIN".localized(), forState: UIControlState.Normal)
        forgotPasswordButton.setTitle("Forgot Password".localized(), forState: UIControlState.Normal)
        registerLabel.text = "Don't have an account?".localized()
        registerButton.setTitle("Sign Up".localized(), forState: UIControlState.Normal)
        changeLangButton.setTitle("Change Language".localized(), forState: UIControlState.Normal)
        
        var faicon = [String: UniChar]()
        faicon["famobilephone"] = 0xf10b
        faicon["fapassword"] = 0xf023
        
        mobileicon.font = UIFont(name: "FontAwesome", size: 40)
        
        mobileicon.text = String(format: "%C", faicon["famobilephone"]!)
        
        passwordicon.font = UIFont(name: "FontAwesome", size: 40)
        
        passwordicon.text = String(format: "%C", faicon["fapassword"]!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.placeholder = "Username".localized()
        passwordTextField.placeholder = "Password".localized()
        usernameTextField.placeholder = "Username".localized()
        passwordTextField.placeholder = "Password".localized()
        smarthawkerLogo.text? = "SmartHawker © 2016".localized()
        loginButton.setTitle("LOGIN".localized(), forState: UIControlState.Normal)
        forgotPasswordButton.setTitle("Forgot Password".localized(), forState: UIControlState.Normal)
        registerLabel.text = "Don't have an account?".localized()
        registerButton.setTitle("Sign Up".localized(), forState: UIControlState.Normal)
        changeLangButton.setTitle("Change Language".localized(), forState: UIControlState.Normal)
        
        var faicon = [String: UniChar]()
        faicon["famobilephone"] = 0xf10b
        faicon["fapassword"] = 0xf023
        
        mobileicon.font = UIFont(name: "FontAwesome", size: 40)
        
        mobileicon.text = String(format: "%C", faicon["famobilephone"]!)
        
        passwordicon.font = UIFont(name: "FontAwesome", size: 40)
        
        passwordicon.text = String(format: "%C", faicon["fapassword"]!)
    }
    
    override func viewDidAppear(animated: Bool) {
        if (PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("loginSuccess", sender: self)
        }
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            view.endEditing(true)
        }
        sender.cancelsTouchesInView = false
    }
    
    @IBAction func doChangeLanguage() {
        actionSheet = UIAlertController(title: nil, message: "Switch Language".localized(), preferredStyle: UIAlertControllerStyle.ActionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(language, forKey: "langPref")
                Localize.setCurrentLanguage(language)
                
                self.usernameTextField.placeholder = "Username".localized()
                self.passwordTextField.placeholder = "Password".localized()
                self.smarthawkerLogo.text? = "SmartHawker © 2016".localized()
                self.loginButton.setTitle("LOGIN".localized(), forState: UIControlState.Normal)
                self.forgotPasswordButton.setTitle("Forgot Password".localized(), forState: UIControlState.Normal)
                self.registerLabel.text = "Don't have an account?".localized()
                self.registerButton.setTitle("Sign Up".localized(), forState: UIControlState.Normal)
                self.changeLangButton.setTitle("Change Language".localized(), forState: UIControlState.Normal)
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
}
