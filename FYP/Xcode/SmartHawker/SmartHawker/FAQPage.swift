//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class FAQPage: UIViewController {
    
    //MARK properties
    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.topItem!.title = "FAQs".localized()
        self.title = "FAQs".localized()
        back.title = "Back".localized()
    }
    
    @IBAction func back(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: {})
    }
    
}
