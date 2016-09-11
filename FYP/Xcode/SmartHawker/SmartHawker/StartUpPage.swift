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
            self.presentViewController(mainVC, animated: true, completion: nil)
            
        }else if indexPath.row == 1{
            Localize.setCurrentLanguage("zh-Hans")
            print("1")
        }else{
            Localize.setCurrentLanguage("ms")
            print("2")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
}
