//
//  ViewController.swift
//  JTAppleCalendar iOS Example
//
//  Created by JayT on 2016-08-10.
//
//

import JTAppleCalendar
import SwiftMoment

class CalendarViewController: UIViewController {
    var numberOfRows = 6
    var correctDateString: String!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var salesText: UILabel!
    @IBOutlet weak var expensesText: UILabel!
    @IBOutlet weak var profitText: UILabel!
    let formatter = NSDateFormatter()
    let testCalendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    

    
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.
    var selectedDate: NSDate!
    //for language preference
    let lang = NSUserDefaults.standardUserDefaults().objectForKey("langPref") as? String
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var list: UIButton!
    
    @IBOutlet weak var add: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        formatter.dateFormat = "MM/yyyy"
        correctDateString = formatter.stringFromDate(NSDate())
        calendarView.selectDates([NSDate()])
        toShare.storeDate = moment(NSDate())
        selectedDate = NSDate()
        loadRecords(NSDate())
        
        var faicon = [String: UniChar]()
        faicon["falist"] = 0xf0ca
        faicon["faadd"] = 0xf067
        
        
        
        list.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        
        list.setTitle(String(format: "%C", faicon["falist"]!), forState: .Normal)
        
        add.titleLabel!.font = UIFont(name: "FontAwesome", size: 20)
        
        add.setTitle(String(format: "%C", faicon["faadd"]!), forState: .Normal)
    }
    
    
    
    @IBAction func goToPage() {
        //self.performSegueWithIdentifier("singleCalendar", sender: self)
    }
    
    // Move to page two of transaction
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
//        // Set the destination view controller
//        let destinationVC : SingleCalendarViewController = segue.destinationViewController as! SingleCalendarViewController
//        
//        destinationVC.date = selectedDate
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupViewsOfCalendar(startDate: NSDate, endDate: NSDate) {
        let month = testCalendar.component(NSCalendarUnit.Month, fromDate: endDate)
        let monthName = NSDateFormatter().monthSymbols[(month-1) % 12] // 0 indexed array
        let year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: startDate)
        navBar.title = monthName + " " + String(year)
    }
    
    func loadRecords(date: NSDate){
        var salesAmount = 0.0
        var expensesAmount = 0.0
        
        formatter.dateFormat = "MM/yyyy"
        let correctedDateString = formatter.stringFromDate(date)
        let values = CalendarController().values(correctedDateString)
        
        salesAmount = values.0
        expensesAmount = values.1
        
        // Sales Label
        let salesString2dp = "$" + String(format:"%.2f", salesAmount)
        self.salesText.text = salesString2dp
        self.salesText.font = UIFont(name: salesText.font.fontName, size: 15)
        
        // Expenses Label
        let expensesString2dp = "$" + String(format:"%.2f", expensesAmount)
        self.expensesText.text = expensesString2dp
        self.expensesText.font = UIFont(name: expensesText.font.fontName, size: 15)
        
        // Profit Label
        let profitString2dp = "$" + String(format:"%.2f", (salesAmount-expensesAmount))
        self.profitText.text = profitString2dp
        self.profitText.font = UIFont(name: profitText.font.fontName, size: 15)
    }
    
    @IBAction func Record(sender: UIBarButtonItem) {
        
        for date in calendarView.selectedDates{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let correctDateString = dateFormatter.stringFromDate(date)
            let dateMoment = moment(date)
            var day: String!
            
            if dateMoment.day == 1 || dateMoment.day == 21{
                day = String(dateMoment.day) + "st".localized()
                
            }else if dateMoment.day == 2 || dateMoment.day == 22{
                day = String(dateMoment.day) + "nd".localized()
                
            }else if dateMoment.day == 3 || dateMoment.day == 23{
                day = String(dateMoment.day) + "rd".localized()
                
            }else{
                day = String(dateMoment.day) + "th".localized()
            }
            
            var toDisplayDate = ""
            if lang == "zh-Hans" {
                toDisplayDate = dateMoment.monthName.localized() + " \(day) " + " \(dateMoment.year) 年, "+(dateMoment.weekdayName).localized()
            }else{
                toDisplayDate = day + " " + dateMoment.monthName + " " + String(dateMoment.year) + " , " + dateMoment.weekdayName
            }
            toShare.storeDate = dateMoment
            toShare.dateString = correctDateString
            toShare.toDisplayDate = toDisplayDate
        }
        // Move to Record Page.
        self.performSegueWithIdentifier("dayRecord", sender: self)
        
        
    }
}

// MARK : JTAppleCalendarDelegate
extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
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
        selectedDate = date
        goToPage()
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToResetCell cell: JTAppleDayCellView) {
        (cell as? CellView)?.selectedView.hidden = true
    }
    
    func calendar(calendar: JTAppleCalendarView, didScrollToDateSegmentStartingWithdate startDate: NSDate, endingWithDate endDate: NSDate) {
        toShare.monthSelected = endDate
        setupViewsOfCalendar(startDate, endDate: endDate)
        loadRecords(endDate)
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
