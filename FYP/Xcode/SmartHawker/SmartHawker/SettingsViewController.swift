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
    @IBOutlet weak var languageLabel: UILabel!
    
    //for notification
    @IBOutlet weak var notificationMode: UISwitch!
    //for privacy
    @IBOutlet weak var privacyButton: UIButton!
    
    
    @IBOutlet weak var backbtn: UIButton!
    
    @IBOutlet weak var passicon: UILabel!
    
    @IBOutlet weak var languageicon: UILabel!
    
    
    @IBOutlet weak var privacyicon: UILabel!
    
    
    @IBOutlet weak var faqicon: UILabel!
    
    
    @IBOutlet weak var contactusicon: UILabel!
    
    //for translation
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var privacyLabel: UILabel!
    @IBOutlet weak var faqLabel: UILabel!
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var logoutLabel: UILabel!
    @IBOutlet weak var language: UILabel!
    // Shared Data
    let shared = ShareData.sharedInstance
    let adminPINController = AdminPINController()
    
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void
    
    // MARK: Action
    func logout() {
        
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
                                connectionDAO().unloadRecords()
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        passwordLabel.text = "Password".localized()
        notificationLabel.text = "Notification".localized()
        privacyLabel.text = "Privacy".localized()
        faqLabel.text = "FAQ".localized()
        contactUsLabel.text = "Contact Us".localized()
        logoutLabel.text = "Log Out".localized()
        language.text = "Language".localized()
        let defaults = NSUserDefaults.standardUserDefaults()
        let name = defaults.stringForKey("langPref")
        if name == "zh-Hans"{
            self.languageLabel.text = "华语"
        }else if name == "en"{
            self.languageLabel.text = "English"
            
        }else{
            self.languageLabel.text = "Malay"
        }
        
        self.title = "Settings".localized()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = NSUserDefaults.standardUserDefaults()
        let name = defaults.stringForKey("langPref")
        if name == "zh-Hans"{
            self.languageLabel.text = "华语"
        }else if name == "en"{
            self.languageLabel.text = "English"
            
        }else{
            self.languageLabel.text = "Malay"
        }
        
        
        var faicon = [String: UniChar]()
        faicon["faleftback"] = 0xf053
        faicon["faright"] = 0xf105
        
        backbtn.titleLabel?.lineBreakMode
        backbtn.titleLabel?.numberOfLines = 2
        backbtn.titleLabel!.textAlignment = .Center
        
        var backs = String(format: "%C", faicon["faleftback"]!)
        
        backs += "\n"
        
        backs += "Back".localized()
        
        backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 15)
        
        backbtn.setTitle(String(backs), forState: .Normal);
        
        passicon.font = UIFont(name: "FontAwesome", size: 20)
        
        passicon.text = String(format: "%C", faicon["faright"]!)
        
        languageicon.font = UIFont(name: "FontAwesome", size: 20)
        
        languageicon.text = String(format: "%C", faicon["faright"]!)
        
        privacyicon.font = UIFont(name: "FontAwesome", size: 20)
        
        privacyicon.text = String(format: "%C", faicon["faright"]!)
        
        faqicon.font = UIFont(name: "FontAwesome", size: 20)
        
        faqicon.text = String(format: "%C", faicon["faright"]!)
        
        contactusicon.font = UIFont(name: "FontAwesome", size: 20)
        
        contactusicon.text = String(format: "%C", faicon["faright"]!)
        
        // Set the Notification switch on/off based on the setting.
        notificationMode.on = defaults.boolForKey("notification")
        
    }
    
    
    @IBAction func switchOnOrOff(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if notificationMode.on {
            
            // Clear all notifications in place to prevent duplication of notifications.
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            
            // Set a new notification.
            let notification = UILocalNotification()
            
            /* Time and timezone settings */
            let dateComp:NSDateComponents = NSDateComponents()
            dateComp.hour = 21
            dateComp.minute = 0
            dateComp.timeZone = NSTimeZone.systemTimeZone()
            let calender:NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let date:NSDate = calender.dateFromComponents(dateComp)!
            
            notification.fireDate = date
            notification.repeatInterval = NSCalendarUnit.Day
            notification.timeZone = NSCalendar.currentCalendar().timeZone
            notification.alertBody = "Have you made your record today?"
            
            /* Action settings */
            notification.hasAction = true
            notification.alertAction = "View"
            
            /* Badge settings */
            notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            
            /* Schedule the notification */
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
            defaults.setBool(true, forKey: "notification")
        } else {
            UIApplication.sharedApplication().cancelAllLocalNotifications()
            defaults.setBool(false, forKey: "notification")
        }
    }
    
    
    @IBAction func autoSyncOnOrOff(sender: UISwitch) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if notificationMode.on {
            
            defaults.setBool(true, forKey: "autoSync")
        } else {
            defaults.setBool(false, forKey: "autoSync")
        }
    }
    
    func doChangeLanguage() {
        actionSheet = UIAlertController(title: nil, message: "Switch Language".localized(), preferredStyle: UIAlertControllerStyle.ActionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(language, forKey: "langPref")
                Localize.setCurrentLanguage(language)
                if language.containsString("zh-Hans"){
                    self.languageLabel.text = "华语"
                }else if language.containsString("en"){
                    self.languageLabel.text = "English"
                }else if language.containsString("ms"){
                    self.languageLabel.text = "Malay"
                }
                self.passwordLabel.text = "Password".localized()
                self.notificationLabel.text = "Notification".localized()
                self.privacyLabel.text = "Privacy".localized()
                self.faqLabel.text = "FAQ".localized()
                self.contactUsLabel.text = "Contact Us".localized()
                self.logoutLabel.text = "Log Out".localized()
                self.language.text = "Language".localized()
                self.title = "Settings".localized()
                
                var faicon = [String: UniChar]()
                faicon["faleftback"] = 0xf053
                faicon["faright"] = 0xf105
                
                self.backbtn.titleLabel?.lineBreakMode
                self.backbtn.titleLabel?.numberOfLines = 2
                self.backbtn.titleLabel!.textAlignment = .Center
                
                var backs = String(format: "%C", faicon["faleftback"]!)
                
                backs += "\n"
                
                backs += "Back".localized()
                
                self.backbtn.titleLabel!.font = UIFont(name: "FontAwesome", size: 15)
                
                self.backbtn.setTitle(String(backs), forState: .Normal);
                
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
        let refreshAlert = UIAlertController(title: "Log Out".localized(), message: "Are You Sure?".localized(), preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            self.shared.clearData()
            //connectionDAO().unloadRecords()
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
        
        // Deselect the selected row after selecting to prevent the row from permanently highlighted.
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let section = indexPath.section
        let row = indexPath.row
        
        if (section == 0) {
            // Password
            if (row == 0) {
                // An alert window will pop up to confirm with user.
                let userEmail = user?.email
                let alert = UIAlertController(title: "Reset password".localized(), message: "Password reset will be sent to".localized() + " :" + userEmail!, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Send".localized(), style: .Default, handler: { (Void) in
                    
                    // Upon clicking "Send" from the pop up, this alert will show to inform the user that the server is now sending mail to their email.
                    let sendingMailAlert = UIAlertController(title: "Sending mail".localized(), message: "Please wait.".localized(), preferredStyle: .Alert)
                    self.presentViewController(sendingMailAlert, animated: true, completion: {
                        let loginController = LoginController()
                        let emailSent = loginController.forgetPassword(userEmail!)
                        if (emailSent) {
                            
                            // Sending mail success, the user will receive an email to change their password.
                            sendingMailAlert.dismissViewControllerAnimated(true, completion: {
                                let successAlert = UIAlertController(title: "Success".localized(), message: "Password change have been sent to: ".localized() + userEmail!, preferredStyle: .Alert)
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
                
                
                alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
                
                // Notification
            else if (row == 1) {
                // Nothing to do in this
            }
            
                // Auto-sync
            else if (row == 2) {
                // Do anything inside here to configure autosync or not.
            }
                
                // Language
            else if (row == 3) {
                doChangeLanguage()
            }
                
                // Privacy
            else if (row == 4) {
                self.performSegueWithIdentifier("toPrivacy", sender: self)
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
            logout()
        }
    }
}
