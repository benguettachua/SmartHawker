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
        if indexPath == 0{
            Localize.setCurrentLanguage("en")
        }else if indexPath == 1{
            Localize.setCurrentLanguage("zh-Hans")
        }else{
            Localize.setCurrentLanguage("ms")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
}
