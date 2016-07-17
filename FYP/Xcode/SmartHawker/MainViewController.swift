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
    var day: String!
    typealias CompletionHandler = (success:Bool) -> Void
    let user = PFUser.currentUser()

    @IBOutlet var MonthAndYear: UILabel!
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.
    var date: Moment! {
        didSet {
            // title = date.format("MMMM d, yyyy")
        }
    }//for calendar
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Once logged in, retrieve all records from the user and pin into local datastore.
        loadRecordsIntoLocalDatastore({ (success) -> Void in
            if (success) {
                // Do nothing, records are stored
            } else {
                print("Some error thrown.")
            }
        })
        
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
            self.performSegueWithIdentifier("logout", sender: self)
    }
    
    func loadRecordsIntoLocalDatastore(completionHandler: CompletionHandler) {
        // Part 1: Load from DB and pin into local datastore.
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Pin records found into local datastore.
                PFObject.pinAllInBackground(objects)
                
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
        
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
            self.day = String(date.day) + "st"
            
        }else if date.day == 2 || date.day == 22{
            self.day = String(date.day) + "nd"
            
        }else if date.day == 3 || date.day == 23{
            self.day = String(date.day) + "rd"
            
        }else{
            self.day = String(date.day) + "th"
        }
        self.MonthAndYear.text = "\(self.day) of " + date.monthName + " \(date.year), \(date.weekdayName)"
        let toDisplayDate = MonthAndYear.text
        print(correctDateString)
        print(toDisplayDate)
        toShare.dateString = correctDateString
        toShare.toDisplayDate = toDisplayDate
        // Move to Record Page.
        self.performSegueWithIdentifier("toRecord", sender: self)
    }
    
    func calendarDidPageToDate(date: Moment) {
        self.date = date
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if date.day == 1 || date.day == 21{
                    self.day = String(date.day) + "st"
                
            }else if date.day == 2 || date.day == 22{
                    self.day = String(date.day) + "nd"
            
            }else if date.day == 3 || date.day == 23{
                    self.day = String(date.day) + "rd"
                
            }else{
                self.day = String(date.day) + "th"
            }
                self.MonthAndYear.text = "\(self.day) of " + date.monthName + " \(date.year), \(date.weekdayName)"
        })
        
    }
    
    
    
}
