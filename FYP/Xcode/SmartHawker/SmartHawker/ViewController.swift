//
//  ViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 6/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//s

import UIKit
import Localize_Swift

class ViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var signIn: UIButton!
    @IBOutlet weak var register: UIButton!
    
    var actionSheet: UIAlertController!
    
    let availableLanguages = Localize.availableLanguages()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeButton.setTitle("Language / 语言", forState: .Normal)
        self.setText()
       
    }
    
    // Add an observer for LCLLanguageChangeNotification on viewWillAppear. This is posted whenever a language changes and allows the viewcontroller to make the necessary UI updated. Very useful for places in your app when a language change might happen.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.setText), name: LCLLanguageChangeNotification, object: nil)
        
        
    }
    
    // This method will prevent logged in users to log in again, directing them to the Admin PIN Page to key in the PIN before logging in.
    override func viewDidAppear(animated: Bool) {
        // Change scene to Admin PIN Scene if there is user logged in.
        if (PFUser.currentUser() != nil) {
            self.performSegueWithIdentifier("toAdminPIN", sender: self)
        }
    }
    
    // Remove the LCLLanguageChangeNotification on viewWillDisappear
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: Localized Text
    
    func setText(){
        signIn.setTitle("Sign In".localized(), forState: .Normal)
        register.setTitle("Register".localized(), forState: .Normal)
    }
    
    // MARK: IBActions
    
    @IBAction func doChangeLanguage(sender: AnyObject) {
        actionSheet = UIAlertController(title: nil, message: "Switch Language", preferredStyle: UIAlertControllerStyle.ActionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .Default, handler: {
                (alert: UIAlertAction!) -> Void in
                Localize.setCurrentLanguage(language)
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.Cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

