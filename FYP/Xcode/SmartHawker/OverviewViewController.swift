//
//  ViewController.swift
//  KDCalendar
//
//  Created by Michael Michailidis on 01/04/2015.
//  Copyright (c) 2015 Karmadust. All rights reserved.
//

import UIKit
import EventKit

class OverviewViewcontroller: UIViewController, CalendarViewDataSource, CalendarViewDelegate {
    
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var status: UITextView!
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        // change the code to get a vertical calender.
        calendarView.direction = .Horizontal
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(animated)
        
        self.loadEventsInCalendar()
        
        let dateComponents = NSDateComponents()
        dateComponents.day = 0
        
        let today = NSDate()
        
        if let date = self.calendarView.calendar.dateByAddingComponents(dateComponents, toDate: today, options: NSCalendarOptions()) {
            self.calendarView.selectDate(date)
            //self.calendarView.deselectDate(date)
        }
        self.calendarView.setDisplayDate(today, animated: true)
        
    }
    
    // MARK : KDCalendarDataSource
    
    func startDate() -> NSDate? {
        
        let dateComponents = NSDateComponents()
        dateComponents.month = -15
        
        let today = NSDate()
        
        let fifteenMonthsFromNow = self.calendarView.calendar.dateByAddingComponents(dateComponents, toDate: today, options: NSCalendarOptions())
        
        
        return fifteenMonthsFromNow
    }
    
    func endDate() -> NSDate? {
        
        let dateComponents = NSDateComponents()
        
        dateComponents.year = 2;
        let today = NSDate()
        
        let twoYearsFromNow = self.calendarView.calendar.dateByAddingComponents(dateComponents, toDate: today, options: NSCalendarOptions())
        
        return twoYearsFromNow
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let width = self.view.frame.size.width - 16.0 * 2
        let height = width + 20.0
        self.calendarView.frame = CGRect(x: 16.0, y: 120.0, width: width, height: height)
        
        
    }
    
    
    
    // MARK : KDCalendarDelegate
    
    func calendar(calendar: CalendarView, didSelectDate date : NSDate, withEvents events: [EKEvent]) {
        
        if events.count > 0 {
            let event : EKEvent = events[0]
            print("We have an event starting at \(event.startDate) : \(event.title)")
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        let convertedDate = dateFormatter.stringFromDate(date)
        
        // Sends the date selected to RecordViewController
        self.toShare.dateSelected = convertedDate
        self.toShare.date = date
        self.performSegueWithIdentifier("toRecord", sender: self)
        
        
        
        self.status.text = "No information for \(convertedDate)yet."
        
        
        
    }
    
    func calendar(calendar: CalendarView, didScrollToMonth date : NSDate) {
    }
    
    // MARK : Events
    
    func loadEventsInCalendar() {
        
        if let  startDate = self.startDate(),
            endDate = self.endDate() {
            
            let store = EKEventStore()
            
            let fetchEvents = { () -> Void in
                
                let predicate = store.predicateForEventsWithStartDate(startDate, endDate:endDate, calendars: nil)
                
                // if can return nil for no events between these dates
                if let eventsBetweenDates = store.eventsMatchingPredicate(predicate) as [EKEvent]? {
                    
                    self.calendarView.events = eventsBetweenDates
                    
                }
                
            }
            
            // let q = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)
            
            if EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) != EKAuthorizationStatus.Authorized {
                
                store.requestAccessToEntityType(EKEntityType.Event, completion: {(granted, error ) -> Void in
                    if granted {
                        fetchEvents()
                    }
                })
                
            }
            else {
                fetchEvents()
            }
            
        }
        
    }
    
    
    // MARK : Events
    
    @IBAction func onValueChange(picker : UIDatePicker) {
        
        self.calendarView.setDisplayDate(picker.date, animated: true)
        
        
    }
    
    @IBAction func changeTodayDate(sender: UIBarButtonItem) {
        
        let today = NSDate()
        self.calendarView.setDisplayDate(today, animated: true)
        
        
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
