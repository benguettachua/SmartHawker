//
//  SyncViewController.swift
//  SmartHawker
//
//  Created by GX on 25/6/16.
//  Copyright © 2016 Kay Zong Wei. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    // MARK: Properties
    // Top Bar
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    let user = PFUser.currentUser()
    typealias CompletionHandler = (success:Bool) -> Void
    
    // MARK: Action
    func logout() {
        PFUser.logOut()
        self.performSegueWithIdentifier("logout", sender: self)
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the Top Bar
        let user = PFUser.currentUser()
        // Populate the top bar
        profileName.text! = user!["name"] as! String
        phoneNumber.text! = user!["phoneNumber"] as! String
        
        // Getting the profile picture
        if let userPicture = user!["profilePicture"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.profilePicture.image = UIImage(data: imageData!)
                }
            }
        }
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Load the Top Bar
        let user = PFUser.currentUser()
        // Populate the top bar
        profileName.text! = user!["name"] as! String
        phoneNumber.text! = user!["phoneNumber"] as! String
        
        // Getting the profile picture
        if let userPicture = user!["profilePicture"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.profilePicture.image = UIImage(data: imageData!)
                }
            }
        }
        
        
    }
    
    @IBAction func Logout(sender: UIBarButtonItem) {
        let refreshAlert = UIAlertController(title: "Logout".localized(), message: "Are You Sure?".localized(), preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            self.logout()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
        
        
    }


}
