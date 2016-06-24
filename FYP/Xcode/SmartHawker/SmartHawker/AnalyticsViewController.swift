//
//  AnalyticsViewController.swift
//  SmartHawker
//
//  Created by Kay Zong Wei on 24/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class AnalyticsViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    @IBAction func logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Populate the top bar
        
        // Getting the profile picture
        let user = PFUser.currentUser()
        let profilePic = user!["profilePicture"] as! PFFile
        profilePic.getDataInBackgroundWithBlock {
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    self.profilePicture = UIImageView(image: image)
                }
            }
        }
       
    }
}