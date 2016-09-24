//
//  EnquiryViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class EnquiryViewController: UIViewController {
    
    // MARK: Proerties
    // Top Bar
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet weak var logout: UIBarButtonItem!
    
    @IBOutlet weak var faq: UIButton!
    @IBOutlet weak var contactUs: UIButton!
    
    
    //MARK: Action
    @IBAction func Logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
}
