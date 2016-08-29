//
//  SyncViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit
import Localize_Swift

class SettingsViewController: UITableViewController {
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
    
    @IBOutlet weak var backbtn: UIButton!
    
    
    @IBOutlet weak var passicon: UILabel!
    
    @IBOutlet weak var adminicon: UILabel!
    
    @IBOutlet weak var languageicon: UILabel!
    
    
    @IBOutlet weak var privacyicon: UILabel!
    
    
    @IBOutlet weak var faqicon: UILabel!
    
    
    @IBOutlet weak var contactusicon: UILabel!
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void
    
    // MARK: Action
    func logout() {
        PFUser.logOut()
        self.view.window!.rootViewController?.dismissViewControllerAnimated(false, completion: nil)

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        // Load the Top Bar
//        let user = PFUser.currentUser()
//        // Populate the top bar
//        
//        if NSUserDefaults.standardUserDefaults().objectForKey("langPref") == nil{
//            let defaults = NSUserDefaults.standardUserDefaults()
//            defaults.setObject("en", forKey: "langPref")
//            displayNotificationStatus.text = "English"
//        }else{
//            let lang = NSUserDefaults.standardUserDefaults().objectForKey("langPref") as? String!
//            if lang == "zh-Hans"{
//                languageLabel.text = "华语"
//            }else{
//                languageLabel.text = "English"
//        
//        }
//        }
//        if NSUserDefaults.standardUserDefaults().objectForKey("notification") == nil{
//            let defaults = NSUserDefaults.standardUserDefaults()
//            defaults.setObject("Off", forKey: "notification")
//            displayNotificationStatus.text = "Off"
//            notificationMode.setOn(false, animated: true)
//        }else{
//                var notificationStore = NSUserDefaults.standardUserDefaults().objectForKey("notification") as? String!
//            if notificationStore == "On"{
//                displayNotificationStatus.text = notificationStore
//                notificationMode.setOn(true, animated: true)
//            }else{
//                displayNotificationStatus.text = notificationStore
//                notificationMode.setOn(false, animated: true)
//            }
//        }
        
        var faicon = [String: UniChar]()
        faicon["faleftback"] = 0xf053
        faicon["faright"] = 0xf105
        
        backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        
        backbtn.setTitle(String(format: "%C", faicon["faleftback"]!), forState: .Normal)
        
        passicon.font = UIFont(name: "FontAwesome", size: 20)
        
        passicon.text = String(format: "%C", faicon["faright"]!)
        
        adminicon.font = UIFont(name: "FontAwesome", size: 20)
        
        adminicon.text = String(format: "%C", faicon["faright"]!)
        
        languageicon.font = UIFont(name: "FontAwesome", size: 20)
        
        languageicon.text = String(format: "%C", faicon["faright"]!)
        
        privacyicon.font = UIFont(name: "FontAwesome", size: 20)
        
        privacyicon.text = String(format: "%C", faicon["faright"]!)
        
        faqicon.font = UIFont(name: "FontAwesome", size: 20)
        
        faqicon.text = String(format: "%C", faicon["faright"]!)
        
        contactusicon.font = UIFont(name: "FontAwesome", size: 20)
        
        contactusicon.text = String(format: "%C", faicon["faright"]!)
        
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
    
    
    func doChangeLanguage() {
        actionSheet = UIAlertController(title: nil, message: "Switch Language", preferredStyle: UIAlertControllerStyle.ActionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(language, forKey: "langPref")
                Localize.setCurrentLanguage(language)
//                if language == "zh-Hans"{
//                    self.languageLabel.text = "华语"
//                }else{
//                    self.languageLabel.text = "English"
//                    
//                }
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    func Logout() {
        let refreshAlert = UIAlertController(title: "Logout".localized(), message: "Are You Sure?".localized(), preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            self.logout()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        
    }
    
    @IBAction func back(sender: UIButton){
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if (section == 0) {
            // Password
            if (row == 0) {
                let comingSoonAlert = UIAlertController(title: "Coming soon", message: "Function currently developing", preferredStyle: .Alert)
                comingSoonAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                self.presentViewController(comingSoonAlert, animated: true, completion: nil)
            }
            
            // Admin PIN
            else if (row == 1) {
                print("Admin PIN")
            }
            
            // Notification
            else if (row == 2) {
                print("Notification")
            }
            
            // Language
            else if (row == 3) {
                doChangeLanguage()
            }
            
            // Privacy
            else if (row == 4) {
                print("Privacy")
            }
        }
        
        else if (section == 1) {
            // FAQ
            if (row == 0) {
                self.performSegueWithIdentifier("toFaq", sender: self)
            }
            
            // Contact Us
            else if (row == 1) {
                self.performSegueWithIdentifier("toContactUs", sender: self)
            }
        }
        
        else if (section == 2) {
            Logout()
        }
    }
}
