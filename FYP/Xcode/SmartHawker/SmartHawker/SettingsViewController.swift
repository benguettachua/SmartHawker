//
//  SyncViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import Localize_Swift

class SettingsViewController: UIViewController {
    // MARK: Properties
    // Top Bar
    @IBOutlet weak var profilePicture: UIImageView!
    
    //for changing language
    var actionSheet: UIAlertController!
    let availableLanguages = Localize.availableLanguages()
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var languageLabel: UILabel!
    
    //for notification
    @IBOutlet weak var notificationMode: UISwitch!
    
    @IBOutlet weak var displayNotificationStatus: UILabel!
    //for faq
    @IBOutlet weak var faqButton: UIButton!
    //for contact us
    @IBOutlet weak var contactUsButton: UIButton!
    //for privacy
    @IBOutlet weak var privacyButton: UIButton!
    
    //for password
    
    //for logout
    @IBOutlet weak var logoutButton: UIButton!
    //for edit
    @IBOutlet weak var editButton: UIButton!
    
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void
    
    // MARK: Action
    func logout() {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the Top Bar
        let user = PFUser.currentUser()
        // Populate the top bar
        
        if NSUserDefaults.standardUserDefaults().objectForKey("langPref") == nil{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject("en", forKey: "langPref")
            displayNotificationStatus.text = "English"
        }else{
            let lang = NSUserDefaults.standardUserDefaults().objectForKey("langPref") as? String!
            if lang == "zh-Hans"{
                languageLabel.text = "华语"
            }else{
                languageLabel.text = "English"
        
        }
        }
        if NSUserDefaults.standardUserDefaults().objectForKey("notification") == nil{
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject("Off", forKey: "notification")
            displayNotificationStatus.text = "Off"
            notificationMode.setOn(false, animated: true)
        }else{
                var notificationStore = NSUserDefaults.standardUserDefaults().objectForKey("notification") as? String!
            if notificationStore == "On"{
                displayNotificationStatus.text = notificationStore
                notificationMode.setOn(true, animated: true)
            }else{
                displayNotificationStatus.text = notificationStore
                notificationMode.setOn(false, animated: true)
            }
        }
        
    }
    
    
    @IBAction func switchOnOrOff(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if notificationMode.on {
            displayNotificationStatus.text = "On"
            defaults.setObject("On", forKey: "notification")
        } else {
            displayNotificationStatus.text = "Off"
            defaults.setObject("Off", forKey: "notification")
        }
    }
    
    
    @IBAction func doChangeLanguage(sender: AnyObject) {
        actionSheet = UIAlertController(title: nil, message: "Switch Language", preferredStyle: UIAlertControllerStyle.ActionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(language, forKey: "langPref")
                Localize.setCurrentLanguage(language)
                if language == "zh-Hans"{
                    self.languageLabel.text = "华语"
                }else{
                    self.languageLabel.text = "English"
                    
                }
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    @IBAction func Logout(sender: UIBarButtonItem) {
        let refreshAlert = UIAlertController(title: "Logout".localized(), message: "Are You Sure?".localized(), preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            self.logout()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    
}
