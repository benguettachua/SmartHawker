//
//  SyncViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class SyncViewController: UIViewController {
    // MARK: Properties
    // Top Bar
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var username: UILabel!
    
    // MARK: Action
    @IBAction func Logout(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
