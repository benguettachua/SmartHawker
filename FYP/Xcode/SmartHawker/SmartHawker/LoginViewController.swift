//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    // Variables
    var toShare = ShareData.sharedInstance
    var errorMsg = String()
    typealias CompletionHandler = (success:Bool) -> Void
    
    // Text Fields
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Action
    @IBAction func login(sender: UIButton) {
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                
                // Do stuff after successful login.
                self.toShare.password = self.passwordTextField.text!
                
                // Set first log in to true, so that prompt to retrieve from DB will appear.
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setBool(true, forKey: "justLoggedIn")
                
                // Get all subusers' PIN and save into an array
                self.getSubUserPINs(user!, completionHandler: { (success) -> Void in
                    if(success){
                        self.performSegueWithIdentifier("loginSuccess", sender: self)
                    } else {
                        print("Error")
                    }
                })
                
            } else {
                
                // There was a problem, show user the error message.
                let alertController = UIAlertController(title: "Login Failed", message: "Username or password is incorrect!", preferredStyle: .Alert)
                let no = UIAlertAction(title: "Try again", style: .Cancel, handler: nil)
                alertController.addAction(no)
                self.presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
    }
    @IBAction func forgetPassword(sender: UIButton) {
        let alert = UIAlertController(title: "Forget password", message: "Enter your email", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Send", style: .Default, handler: { (Void) in
            let emailTextField = alert.textFields![0] as UITextField
            do{
                try PFUser.requestPasswordResetForEmail(emailTextField.text!)
                let successAlert = UIAlertController(title: "Success", message: "Password change have been sent to: " + emailTextField.text!.lowercaseString, preferredStyle: .Alert)
                successAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(successAlert, animated: true, completion: nil)
            } catch {
                let failAlert = UIAlertController(title: "Failed", message: "Invalid email, please try again later.", preferredStyle: .Alert)
                failAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(failAlert, animated: true, completion: nil)
            }
        }))
        alert.addTextFieldWithConfigurationHandler({ (emailTextField) in
            emailTextField.placeholder = "Enter your email"
            emailTextField.keyboardType = UIKeyboardType.EmailAddress
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        usernameTextField.placeholder = "Username".localized()
        passwordTextField.placeholder = "Password".localized()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
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
    
    func getSubUserPINs(user: PFUser, completionHandler: CompletionHandler) {
        let query = PFQuery(className: "SubUser")
        query.whereKey("user", equalTo: user)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            var PINS = [String]()
            if error == nil {
                PFObject.pinAllInBackground(objects)
                for object in objects! {
                    let PIN = object["pin"] as! String
                    PINS.append(PIN)
                    
                }
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(PINS, forKey: "allPINS")
                completionHandler(success: true)
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
    }
    
}
