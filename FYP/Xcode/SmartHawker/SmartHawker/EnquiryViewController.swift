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
        
        userLabel.text = "User:".localized()
        navBar.title = "Enquiry".localized()
        self.title = "Enquiry".localized()
        logout.title = "Logout".localized()
        back.title = "Back".localized()
        
        faq.setTitle("FAQs".localized(), forState: .Normal)
        contactUs.setTitle("Contact Helpdesk".localized(), forState: .Normal)
        
        // Load the Top Bar
        let user = PFUser.currentUser()
        // Populate the top bar
        businessName.text! = user!["businessName"] as! String
        username.text! = user!["username"] as! String
        
        // Getting the profile picture
        if let userPicture = user!["profilePicture"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.profilePicture.image = UIImage(data: imageData!)
                }
            }
        }
        
    }
}
