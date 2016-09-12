//
//  EnquiryViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//
import Localize_Swift
import UIKit

class StartUpPage: UITableViewController{
    
    // MARK: Proerties
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVC = storyboard.instantiateViewControllerWithIdentifier("Main")
       
        
        if indexPath.row == 0{
            Localize.setCurrentLanguage("en")
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject("en", forKey: "langPref")
            self.presentViewController(mainVC, animated: true, completion: nil)
            
        }else if indexPath.row == 1{
            
            Localize.setCurrentLanguage("zh-Hans")
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject("zh-Hans", forKey: "langPref")
            self.presentViewController(mainVC, animated: true, completion: nil)
        }else{
            Localize.setCurrentLanguage("ms")
            
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject("ms", forKey: "langPref")
            self.presentViewController(mainVC, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
}
