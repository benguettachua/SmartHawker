//
//  ViewController.swift
//  KDCalendar
//
//  Created by Michael Michailidis on 01/04/2015.
//  Copyright (c) 2015 Karmadust. All rights reserved.
//

import UIKit
import CalendarView
import SwiftMoment

class MainViewcontroller: UIViewController{
    
    // Mark: Properties
    // Top Bar
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var businessName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var calendar: CalendarView!

    @IBOutlet var MonthAndYear: UILabel!
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.
    var date: Moment! {
        didSet {
            title = date.format("MMMM d, yyyy")
        }
    }//for calendar
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //calendar
        date = moment()
        calendar.delegate = self

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
    
    @IBAction func Logout(sender: UIBarButtonItem) {
        let refreshAlert = UIAlertController(title: "Log Out", message: "Are You Sure to Log Out ? ", preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action: UIAlertAction!) in
            self.loggedOut()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)


    }
    
        func loggedOut() {
            PFUser.logOut()
            print("lalala12345")
            self.performSegueWithIdentifier("logout", sender: self)
    }
    
    
}


extension MainViewcontroller: CalendarViewDelegate {
    
    func calendarDidSelectDate(date: Moment) {
        self.date = date
        
        // Adding 8 hours due to timezone
        let duration = 8.hours
        let dateInNSDate = date.add(duration).date
        
        // Formatting to format as saved in DB.
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let correctDateString = dateFormatter.stringFromDate(dateInNSDate)
        toShare.dateString = correctDateString
        
        // Move to Record Page.
        self.performSegueWithIdentifier("toRecord", sender: self)
    }
    
    func calendarDidPageToDate(date: Moment) {
        self.date = date
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.MonthAndYear.text = date.monthName + " \(date.year)"
        })
        
    }
    
    
    
}
