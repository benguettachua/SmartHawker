//
//  ViewController.swift
//  KDCalendar
//
//  Created by Michael Michailidis on 01/04/2015.
//  Copyright (c) 2015 Karmadust. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SwiftMoment

class CalendarViewcontroller: UIViewController{
    
    // Mark: Properties
    // Top Bar

    var numberOfRows = 6
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    let formatter = NSDateFormatter()
    let testCalendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    
    @IBOutlet weak var profitText: UILabel!
    @IBOutlet weak var expensesText: UILabel!
    @IBOutlet weak var salesText: UILabel!
    @IBOutlet weak var navBar: UINavigationItem!
    var day: String!
    var actualMonthDate = moment(NSDate())
    var chosenMonthDate = NSDate()
    var calendarForChangeMonth = NSCalendar.init(calendarIdentifier: NSCalendarIdentifierGregorian)
    var tempCounter = 0
    
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
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        formatter.dateFormat = "yyyy MM dd"
        testCalendar.timeZone = NSTimeZone(abbreviation: "GMT")!
        
        // Setting up your dataSource and delegate is manditory
        //_____________________________________________________________________________________________
        calendarView.delegate = self
        calendarView.dataSource = self
        //_____________________________________________________________________________________________
        
        
        
        // Registering your cells is manditory
        //_____________________________________________________________________________________________
        calendarView.registerCellViewXib(fileName: "CellView")
        // You also can register by class
        // calendarView.registerCellViewClass(fileName: "JTAppleCalendar_Example.CodeCellView")
        //_____________________________________________________________________________________________
        
        
        
        // Enable/disable the following code line to show/hide headers.
        
        
        // The following default code can be removed since they are already the default.
        // They are only included here so that you can know what properties can be configured
        //_____________________________________________________________________________________________
        calendarView.direction = .Vertical                                 // default is horizontal
        calendarView.cellInset = CGPoint(x: 0, y: 0)                         // default is (3,3)
        calendarView.allowsMultipleSelection = false                         // default is false
        calendarView.firstDayOfWeek = .Sunday                                // default is Sunday
        calendarView.scrollEnabled = true                                    // default is true
        calendarView.scrollingMode = .StopAtEachCalendarFrameWidth           // default is .StopAtEachCalendarFrameWidth
        calendarView.itemSize = nil                                          // default is nil. Use a value here to change the size of your cells
        calendarView.rangeSelectionWillBeUsed = false                        // default is false
        //_____________________________________________________________________________________________
        
        // Reloading the data on viewDidLoad() is only necessary if you made LAYOUT changes eg. number of row per month change
        // or changing the start day of week from sunday etc etc.
        calendarView.reloadData()
        
        // After reloading. Scroll to your selected date, and setup your calendar
        calendarView.scrollToDate(NSDate(), triggerScrollToDateDelegate: false, animateScroll: false) {
            let currentDate = self.calendarView.currentCalendarDateSegment()
            self.setupViewsOfCalendar(currentDate.dateRange.start, endDate: currentDate.dateRange.end)
        }
        // Formatting to format as saved in DB.
        var correctDateString = ""
        if toShare.dateString == nil{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            correctDateString = dateFormatter.stringFromDate(NSDate())
        }else{
            correctDateString = toShare.dateString
        }
        

        
        loadRecords(correctDateString)


    }
    
    func loadRecords(correctDateString: String){
        var salesAmount = 0.0
        var expensesAmount = 0.0
        
        let values = CalendarController().values(correctDateString)

        salesAmount = values.0
        expensesAmount = values.1
        
        // Sales Label
        let salesString2dp = "$" + String(format:"%.2f", salesAmount)
        self.salesText.text = salesString2dp
        self.salesText.font = UIFont(name: salesText.font.fontName, size: 24)
        
        // Expenses Label
        let expensesString2dp = "$" + String(format:"%.2f", expensesAmount)
        self.expensesText.text = expensesString2dp
        self.expensesText.font = UIFont(name: expensesText.font.fontName, size: 24)
        
        // Profit Label
        let profitString2dp = "$" + String(format:"%.2f", (salesAmount-expensesAmount))
        self.profitText.text = profitString2dp
        self.profitText.font = UIFont(name: profitText.font.fontName, size: 24)
    }
    
    
    @IBAction func Record(sender: UIBarButtonItem) {
        
        if toShare.dateString == nil{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let correctDateString = dateFormatter.stringFromDate(NSDate())
            
            if date.day == 1 || date.day == 21{
                self.day = String(date.day) + "st".localized()
                
            }else if date.day == 2 || date.day == 22{
                self.day = String(date.day) + "nd".localized()
                
            }else if date.day == 3 || date.day == 23{
                self.day = String(date.day) + "rd".localized()
                
            }else{
                self.day = String(date.day) + "th".localized()
            }
            
            var toDisplayDate = ""
            if lang == "zh-Hans" {
                toDisplayDate = date.monthName.localized() + " \(self.day) " + " \(date.year) 年, "+(date.weekdayName).localized()
            }else{
                toDisplayDate = self.day + " " + date.monthName + " " + String(date.year) + " , " + date.weekdayName
            }
            toShare.storeDate = date
            toShare.dateString = correctDateString
            toShare.toDisplayDate = toDisplayDate
            toShare.dateString = correctDateString
        }
        // Move to Record Page.
        self.performSegueWithIdentifier("dayRecord", sender: self)
        
        
    }
    
    @IBAction func printSelectedDates() {
        print("Selected dates --->")
        for date in calendarView.selectedDates {
            print(formatter.stringFromDate(date))
        }
    }
    
    
    @IBAction func changeToOneRows() {
        numberOfRows = 1
        calendarView.reloadData()
    }
    
    @IBAction func next(sender: UIButton) {
        self.calendarView.scrollToNextSegment() {
            let currentSegmentDates = self.calendarView.currentCalendarDateSegment()
            self.setupViewsOfCalendar(currentSegmentDates.dateRange.start, endDate: currentSegmentDates.dateRange.end)
        }
    }
    
    @IBAction func previous(sender: UIButton) {
        self.calendarView.scrollToPreviousSegment() {
            let currentSegmentDates = self.calendarView.currentCalendarDateSegment()
            self.setupViewsOfCalendar(currentSegmentDates.dateRange.start, endDate: currentSegmentDates.dateRange.end)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupViewsOfCalendar(startDate: NSDate, endDate: NSDate) {
        let month = testCalendar.component(NSCalendarUnit.Month, fromDate: startDate)
        let monthName = NSDateFormatter().monthSymbols[(month) % 12] // 0 indexed array
        print(month)
        let year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: startDate)
        monthLabel.text = monthName + " " + String(year)
    }
    
}

// MARK : JTAppleCalendarDelegate
extension CalendarViewcontroller: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        
        let todayDateString = formatter.stringFromDate(NSDate())
        let thisYearString = todayDateString[todayDateString.startIndex...todayDateString.startIndex.advancedBy(3)]
        let nextYear = Int(thisYearString)! + 1
        let secondDate = formatter.dateFromString(String(nextYear) + " 12 31")
        
        let firstDate = formatter.dateFromString("2016 01 01")
        let aCalendar = NSCalendar.currentCalendar() // Properly configure your calendar to your time zone here
        return (startDate: firstDate!, endDate: secondDate!, numberOfRows: numberOfRows, calendar: aCalendar)
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: NSDate, cellState: CellState) {
        (cell as? CellView)?.setupCellBeforeDisplay(cellState, date: date)
    }
    
    func calendar(calendar: JTAppleCalendarView, didDeselectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        (cell as? CellView)?.cellSelectionChanged(cellState)
    }
    
    func calendar(calendar: JTAppleCalendarView, didSelectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        (cell as? CellView)?.cellSelectionChanged(cellState)
        
        print("lala")
        printSelectedDates()
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToResetCell cell: JTAppleDayCellView) {
        (cell as? CellView)?.selectedView.hidden = true
    }
    
    func calendar(calendar: JTAppleCalendarView, didScrollToDateSegmentStartingWithdate startDate: NSDate, endingWithDate endDate: NSDate) {
        setupViewsOfCalendar(startDate, endDate: endDate)
    }
    
}

func delayRunOnMainThread(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}