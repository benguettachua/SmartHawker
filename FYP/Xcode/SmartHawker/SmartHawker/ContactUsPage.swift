//
//  LoginViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 20/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class ContactUsPage: UIViewController {
 
    //MARK properties
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var back: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        navBar.topItem!.title = "Contact Helpdesk".localized()
        self.title = "Contact Helpdesk".localized()
        back.title = "Back".localized()
    }
    
    @IBAction func back(sender: UIBarButtonItem){
        self.dismissViewControllerAnimated(true, completion: {})
    }

    
}
