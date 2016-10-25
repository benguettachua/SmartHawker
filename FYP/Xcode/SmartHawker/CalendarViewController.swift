//
//  ViewController.swift
//  JTAppleCalendar iOS Example
//
//  Created by JayT on 2016-08-10.
//
//

import JTAppleCalendar
import SwiftMoment

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    var numberOfRows = 6
    var correctDateString: String!
    
    let formatterNo = NSNumberFormatter()
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var salesText: UILabel!
    @IBOutlet weak var expensesText: UILabel!
    @IBOutlet weak var cogsText: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var cogsLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var salesLabel: UILabel!
    
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var profitAmountLabel: UILabel!
    
    
    let formatter = NSDateFormatter()
    let testCalendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.
    var selectedDate: NSDate!
    //for language preference
    let lang = NSUserDefaults.standardUserDefaults().objectForKey("langPref") as? String
    @IBOutlet weak var navBar: UINavigationItem!
    var records = [PFObject]()
    let recordDayController = RecordDayController()
    
    @IBOutlet weak var list: UIButton!
    @IBOutlet weak var add: UIButton!
    
    //day labels
    
    @IBOutlet weak var sunLabel: UILabel!
    @IBOutlet weak var monLabel: UILabel!
    @IBOutlet weak var tuesLabel: UILabel!
    @IBOutlet weak var wedLabel: UILabel!
    @IBOutlet weak var thursLabel: UILabel!
    @IBOutlet weak var friLabel: UILabel!
    @IBOutlet weak var satLabel: UILabel!
    
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
        formatter.dateFormat = "dd/MM/yyyy"
        toShare.dateString = formatter.stringFromDate(NSDate())
        toShare.storeDate = moment(NSDate())
        selectedDate = NSDate()
        loadRecords(NSDate())
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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Setting day labels
        sunLabel.text = "SUN".localized()
        monLabel.text = "MON".localized()
        tuesLabel.text = "TUE".localized()
        wedLabel.text = "WED".localized()
        thursLabel.text = "THU".localized()
        friLabel.text = "FRI".localized()
        satLabel.text = "SAT".localized()
        salesLabel.text = "SALES".localized()
        cogsLabel.text = "COGS".localized()
        expensesLabel.text = "EXPENSES".localized()
        profitLabel.text = "PROFIT".localized()
        
        var faicon = [String: UniChar]()
        faicon["falist"] = 0xf0ca
        faicon["faadd"] = 0xf067
        
        list.titleLabel?.lineBreakMode
        list.titleLabel?.numberOfLines = 2
        list.titleLabel!.textAlignment = .Center
        
        var lists = String(format: "%C", faicon["falist"]!)
        
        lists += "\n"
        
        lists += "Records".localized()
        
        list.titleLabel!.font = UIFont(name: "FontAwesome", size: 15)
        
        list.setTitle(String(lists), forState: .Normal);
        
        add.titleLabel?.lineBreakMode
        add.titleLabel?.numberOfLines = 2
        add.titleLabel!.textAlignment = .Center
        
        var adds = String(format: "%C", faicon["faadd"]!)
        
        adds += "\n"
        
        adds += "Add".localized()
        
        add.titleLabel!.font = UIFont(name: "FontAwesome", size: 15)
        
        add.setTitle(String(adds), forState: .Normal)
        
        calendarView.reloadData()
        loadRecords(selectedDate)
        
        let monthLabel2 = monthLabel.text!
        let indexForMonth = monthLabel2.startIndex..<monthLabel2.endIndex.advancedBy(-5)
        let indexForYear = monthLabel2.endIndex.advancedBy(-4)..<monthLabel2.endIndex
        let newMonth = monthLabel2[indexForMonth]
        let newYear = monthLabel2[indexForYear]
        monthLabel.text = newMonth.localized() + " " + newYear
        
        // Remove all records to prevent duplicates.
        records.removeAll()
        
        // Load records from local datastore into an array.
        records = recordDayController.loadRecord()
        
        
        
        // Loop through the records, removing all elements that should not be shown.
        for (i,num) in records.enumerate().reverse() {
            
            // Removing records that have amount $0.00 as it means that the record is deleted.
            if (records[i]["amount"] as! Double == 0) {
                records.removeAtIndex(i)
                
                // Removing records that have type 3 or 4 as it should not be shown, Monthly Fixed Expenses and Monthly Target.
            } else if (records[i]["type"] as! Int == 3 || records[i]["type"] as! Int == 4){
                records.removeAtIndex(i)
            }
        }
        
        
        records.sortInPlace { $0["type"]as!Int == $1["type"]as!Int ? $0.createdAt < $1.createdAt : $1["type"]as!Int > $0["type"]as!Int }
        
        
        
        // Reload the table to show any ammendments made to the data.
        tableView.reloadData()
        tableView!.delegate = self
        tableView!.dataSource = self
        
        
    }
    
    func setupViewsOfCalendar(startDate: NSDate, endDate: NSDate) {
        let month = testCalendar.component(NSCalendarUnit.Month, fromDate: endDate)
        let monthName = NSDateFormatter().monthSymbols[(month-1) % 12] // 0 indexed array
        let year = NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: startDate)
        
        monthLabel.text = monthName.localized() + " " + String(year)
    }
    
    func loadRecords(date: NSDate){
        
        
        formatterNo.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatterNo.locale = NSLocale(localeIdentifier: "en_US")
        var salesAmount = 0.0
        var expensesAmount = 0.0
        var cogsAmount = 0.0
        
        formatter.dateFormat = "dd/MM/yyyy"
        let correctedDateString = formatter.stringFromDate(date)
        let values = CalendarController().values(correctedDateString)
        
        salesAmount = values.0
        expensesAmount = values.1
        cogsAmount = values.2
        
        // Sales Label
        let salesString2dp = formatterNo.stringFromNumber(salesAmount)
        self.salesText.text = salesString2dp
        self.salesText.font = UIFont(name: salesText.font.fontName, size: 15)
        
        // Expenses Label
        let expensesString2dp = formatterNo.stringFromNumber(expensesAmount)
        self.expensesText.text = expensesString2dp
        self.expensesText.font = UIFont(name: expensesText.font.fontName, size: 15)
        
        // Profit Label
        let cogsString2dp = formatterNo.stringFromNumber(cogsAmount)
        self.cogsText.text = cogsString2dp
        self.cogsText.font = UIFont(name: cogsText.font.fontName, size: 15)
        self.cogsText.textColor = UIColor.orangeColor()
        
        
        // Profit Label
        let profitAmount = salesAmount - expensesAmount - cogsAmount
        profitAmountLabel.text = formatterNo.stringFromNumber(profitAmount)
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
    
    // Below this comment are all the methods for table.
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.records.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "RecordCell"
        let cell = self.tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! RecordTableViewCell
        
        // Description Label
        var description = records[indexPath.row]["description"]
        if (description == nil || description as! String == "") {
            description = "No description".localized()
        }
        cell.descriptionLabel.text = description as! String
        cell.descriptionLabel.font = UIFont(name: cell.descriptionLabel.font.fontName, size: 12)
        
        // Amount Label
        let amount = records[indexPath.row]["amount"] as! Double
        let amountString2dp = formatterNo.stringFromNumber(amount)
        cell.amountLabel.text = amountString2dp
        cell.amountLabel.font = UIFont(name: cell.amountLabel.font.fontName, size: 12)
        
        // Type Label
        let type = records[indexPath.row]["type"] as! Int
        var typeString = ""
        if (type == 0) {
            typeString = "Sales"
            cell.recordTypeLabel.textColor = UIColor.blueColor()
        } else if (type == 1) {
            typeString = "COGS"
            cell.recordTypeLabel.textColor = UIColor.orangeColor()
        } else if (type == 2) {
            typeString = "Expenses"
            cell.recordTypeLabel.textColor = UIColor.redColor()
        }
        cell.recordTypeLabel.text = typeString.localized()
        cell.recordTypeLabel.font = UIFont.boldSystemFontOfSize(20)
        
        // Cell background
        cell.backgroundColor = UIColor(white: 1, alpha: 0.0)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        toShare.selectedRecord = records[indexPath.row]
        let storyboard = UIStoryboard(name: "Recording", bundle: nil)
        let updateRecordVC = storyboard.instantiateViewControllerWithIdentifier("updateRecord")
        self.presentViewController(updateRecordVC, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let selectedRecord = records[indexPath.row]
            
            // Delete the record
            let deleteSuccess = recordDayController.deleteRecord(selectedRecord)
            if(deleteSuccess) {
                records.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            } else {
                // Delete failed.
            }
        }
    }
}

// MARK : JTAppleCalendarDelegate
extension CalendarViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        formatter.dateFormat = "yyyy"
        
        let todayDateString = formatter.stringFromDate(NSDate())
        let nextYear = Int(todayDateString)! + 1
        formatter.dateFormat = "yyyy MM dd"
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
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let correctDateString = dateFormatter.stringFromDate(selectedDate)
        let dateMoment = moment(selectedDate)
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
        toShare.storeDate = dateMoment
        toShare.dateString = correctDateString
        loadRecords(selectedDate)
        self.viewWillAppear(true)
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
