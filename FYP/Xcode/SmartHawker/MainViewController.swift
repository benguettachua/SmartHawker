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
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var navBarLogoutButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    var day: String!
    typealias CompletionHandler = (success:Bool) -> Void
    let user = PFUser.currentUser()

    @IBOutlet var MonthAndYear: UILabel!
    //for language preference
    let lang = NSUserDefaults.standardUserDefaults().objectForKey("langPref") as? String
    
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.
    var date: Moment! {
        didSet {
            // title = date.format("MMMM d, yyyy")
        }
    }//for calendar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userLabel.text = "User:".localized()
        navBar.title = "Main".localized()
        navBarLogoutButton.title = "Logout".localized()


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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //calendar
        
        date = moment()
        calendar.delegate = self
    }
    
    @IBAction func Logout(sender: UIBarButtonItem) {
        let refreshAlert = UIAlertController(title: "Logout".localized(), message: "Are You Sure?".localized(), preferredStyle: UIAlertControllerStyle.Alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            self.loggedOut()
        }))
        refreshAlert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { (action: UIAlertAction!) in
            
            refreshAlert .dismissViewControllerAnimated(true, completion: nil)
            
            
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)


    }
    
        func loggedOut() {
            PFUser.logOut()
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
        
        
        //for displaying date
        if date.day == 1 || date.day == 21{
            self.day = String(date.day) + "st".localized()
            
        }else if date.day == 2 || date.day == 22{
            self.day = String(date.day) + "nd".localized()
            
        }else if date.day == 3 || date.day == 23{
            self.day = String(date.day) + "rd".localized()
            
        }else{
            self.day = String(date.day) + "th".localized()
        }

        var toDisplayDate = date.monthName.localized() + " \(self.day) " + " \(date.year) 年, "+(date.weekdayName).localized()
        print(lang=="en")
        if lang == "en" {
            toDisplayDate = self.day + " " + date.monthName + " " + String(date.year) + " , " + date.weekdayName
            print(toDisplayDate)
        }
        toShare.dateString = correctDateString
        toShare.toDisplayDate = toDisplayDate
        // Move to Record Page.
        self.performSegueWithIdentifier("toRecord", sender: self)
    }
    
    func calendarDidPageToDate(date: Moment) {
        self.date = date
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.MonthAndYear.text = date.monthName.localized() + " / " + String(date.year)
        })
        
    }
    
    
    
}
