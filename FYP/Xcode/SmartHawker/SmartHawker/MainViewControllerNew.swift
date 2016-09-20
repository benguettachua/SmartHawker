
import UIKit
import SwiftMoment
import Material
import FontAwesome_iOS

class MainViewControllerNew: UIViewController{
    
    //MARK properties
    //---------------------------------
    let user = PFUser.currentUser()
    var targetAmount = 0.0
    var targetAvailable = false
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.
    var newMonth = false
    var currentMonth: String!
    var datesWithRecords = [String]()
    
    let formatter = NSNumberFormatter()
    
    // MARK: outlets on the storyboard
    
    //for weekly
    @IBOutlet weak var weekSalesLabel: UILabel!
    @IBOutlet weak var weekCOGSLabel: UILabel!
    @IBOutlet weak var weekExpensesLabel: UILabel!
    @IBOutlet weak var weekProfitLabel: UILabel!
    @IBOutlet weak var thisWeekOverviewLabel: UILabel!
    
    @IBOutlet weak var weeklySalesLabel: UILabel!
    @IBOutlet weak var weeklyCOGSLabel: UILabel!
    @IBOutlet weak var weeklyExpensesLabel: UILabel!
    @IBOutlet weak var weeklyProfitLabel: UILabel!
    @IBOutlet weak var weeklyLabel: UILabel!
    
    
    @IBOutlet weak var lastRecordLabel: UILabel!
    @IBOutlet weak var targetButton: UIButton!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var lowestSales: UILabel!
    @IBOutlet weak var highestSales: UILabel!
    @IBOutlet weak var averageSales: UILabel!
    @IBOutlet weak var lowestSalesDay: UILabel!
    @IBOutlet weak var highestSalesDay: UILabel!
    
    @IBOutlet weak var otherExpensesAmount: UILabel!
    @IBOutlet weak var salesAmount: UILabel!
    @IBOutlet weak var totalProfit: UILabel!
    
    @IBOutlet weak var lowestSalesLabel: UILabel!
    @IBOutlet weak var highestSalesLabel: UILabel!
    @IBOutlet weak var averageSalesLabel: UILabel!
    @IBOutlet weak var profitLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var salesLabel: UILabel!
    @IBOutlet weak var COGSLabel: UILabel!
    @IBOutlet weak var todayEntryLabel: UILabel!
    @IBOutlet weak var monthlyTargetLabel: UILabel!
    @IBOutlet weak var syncButton: UIButton!
    
    @IBOutlet weak var monthCOGSAmountLabel: UILabel!
    @IBOutlet weak var monthlyTargetAmountLabel: UILabel!
    @IBOutlet weak var thisMonthSaleLabel: UILabel!
    
    // For Today Overview Part
    @IBOutlet weak var todaySalesLabel: UILabel!
    @IBOutlet weak var todaySalesAmountLabel: UILabel!
    @IBOutlet weak var todayCOGSLabel: UILabel!
    @IBOutlet weak var todayCOGSAmountLabel: UILabel!
    @IBOutlet weak var todayExpensesLabel: UILabel!
    @IBOutlet weak var todayExpensesAmountLabel: UILabel!
    @IBOutlet weak var todayProfitLabel: UILabel!
    @IBOutlet weak var todayProfitAmountLabel: UILabel!
    
    @IBOutlet weak var todayLabel: UILabel!
    
    
    @IBOutlet weak var overview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var faicon = [String: UniChar]()
        faicon["fasync"] = 0xf021
        faicon["fainfo"] = 0xf129
        
        syncButton.titleLabel?.lineBreakMode
        syncButton.titleLabel?.numberOfLines = 2
        syncButton.titleLabel!.textAlignment = .Center
        
        var sync = String(format: "%C", faicon["fasync"]!)
        
        sync += "\n"
        
        sync += "Sync".localized()
        
        syncButton.titleLabel!.font = UIFont(name: "FontAwesome", size: 15)
        
        syncButton.setTitle(String(sync), forState: .Normal);
        
        //set labels for translation
        //lowestSalesLabel.text = "Lowest".localized()
        
        //highestSalesLabel.text = "Highest".localized()
        
        //averageSalesLabel.text = "Average".localized()
        
        profitLabel.text = "Profit".localized()
        expensesLabel.text = "Expenses".localized()
        salesLabel.text = "Sales".localized()
        COGSLabel.text = "COGS".localized()
        todayEntryLabel.text = "ADD NEW RECORD".localized()
        monthlyTargetLabel.text = "SET MONTHLY TARGET".localized()
        //thisMonthSaleLabel.text = "Sales - This Month".localized()
        thisWeekOverviewLabel.text = "This Weeks' Overview".localized()
        weekSalesLabel.text = "Sales".localized()
        weekCOGSLabel.text = "COGS".localized()
        weekExpensesLabel.text = "Expenses".localized()
        weekProfitLabel.text = "Profit".localized()
        
        // Translation for today's section
        todaySalesLabel.text = "Sales".localized()
        todayCOGSLabel.text = "COGS".localized()
        todayExpensesLabel.text = "Expenses".localized()
        todayProfitLabel.text = "Profit".localized()
        todayLabel.text = "Today's Overview".localized()
        
        //syncButton.setTitle("Sync".localized(), forState: UIControlState.Normal)
        //infoButton.setTitle("Info".localized(), forState: UIControlState.Normal)
        // Initialize UI
        // -------------
        getTodayDate()
        getLatestDate()
        getMonthlyTarget()
        if(targetAvailable) {
            targetButton.setImage(UIImage(named: "edit-button"), forState: .Normal)
            monthlyTargetAmountLabel.text = formatter.stringFromNumber(targetAmount)
        } else {
            monthlyTargetAmountLabel.text = "No target set".localized()
        }
        setValues()
        
        connectionDAO().loadStringIntoAutoFill()
    }
    
    func setValues(){
        
        
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        
        let values = MainController().getMainValues()
        self.salesAmount.text = formatter.stringFromNumber(values.0)
        self.otherExpensesAmount.text = formatter.stringFromNumber(values.1)
        self.totalProfit.text = formatter.stringFromNumber(values.2)
        //self.highestSales.text = formatter.stringFromNumber(values.3)
        //self.lowestSales.text = formatter.stringFromNumber(values.4)
        //if values.5 == 0{
        //    self.averageSales.text = "$0"
        //}else{
        ////    self.averageSales.text = formatter.stringFromNumber(values.5)
        //}
        //self.highestSalesDay.text = values.6
        //self.lowestSalesDay.text = values.7
        self.monthCOGSAmountLabel.text = formatter.stringFromNumber(values.8)
        
        self.weeklySalesLabel.text = formatter.stringFromNumber(values.9)
        self.weeklyCOGSLabel.text = formatter.stringFromNumber(values.10)
        self.weeklyExpensesLabel.text = formatter.stringFromNumber(values.11)

        self.weeklyProfitLabel.text = formatter.stringFromNumber(values.12)
        print("Weekly Overview from \n" + values.13 + " - " + values.14)
        //self.weeklyLabel.text = "Weekly Overview from \n" + values.13 + " - " + values.14
        overview.text = "Overview for ".localized() + moment(NSDate()).monthName.localized()
        
        // Today's value to be populated to UI when done
        todaySalesAmountLabel.text = formatter.stringFromNumber(values.15)
        todayCOGSAmountLabel.text = formatter.stringFromNumber(values.16)
        todayExpensesAmountLabel.text = formatter.stringFromNumber(values.17)
        todayProfitAmountLabel.text = formatter.stringFromNumber(values.18)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Actions taken by buttons
    // --------------------------
    
    //allows user to add record for today
    @IBAction func addTodayRecord(sender: UIButton) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let correctDateString = dateFormatter.stringFromDate(NSDate())
        toShare.dateString = correctDateString
        self.performSegueWithIdentifier("addRecord", sender: self)
    }
    
    //allows the user to add a target for the app
    @IBAction func addTarget(sender: UIButton) {
        let alert = UIAlertController(title: "Monthly Target".localized(), message: "What is this month's target?".localized(), preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save".localized(), style: .Default, handler: { Void in
            
            let targetTextField = alert.textFields![0] as UITextField
            if (targetTextField.text != nil && targetTextField.text != "") {
                //puts a method to delete targets for this month
                if (self.targetAvailable) {
                    MainController().deleteMonthlyTarget(self.currentMonth)
                }
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                let correctDateString = dateFormatter.stringFromDate(NSDate())
                connectionDAO().addRecord(correctDateString, amount: Double(targetTextField.text!)!, type: 4, subuser: (self.user?.username)!, description: "Monthly Target", receipt: nil)
                self.viewWillAppear(true)
                
            } else {
                let alert = UIAlertController(title: "Error".localized(), message: "Target cannot be empty.".localized(), preferredStyle: .Alert)
                alert.addAction((UIAlertAction(title: "Try again".localized(), style: .Default, handler: nil)))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
        alert.addTextFieldWithConfigurationHandler({ (targetTextField) in
            targetTextField.placeholder = "This month's target".localized()
            targetTextField.keyboardType = UIKeyboardType.DecimalPad
        })
        alert.addAction(saveAction)
        alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .Default, handler: { Void in
            self.viewWillAppear(true)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    //Methods for the class
    // -----------------------------------
    
    // allows the user to get the target they set for that month
    func getMonthlyTarget() {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        currentMonth = dateFormatter.stringFromDate(NSDate())
        let result = MainController().loadTargetRecords(currentMonth)
        
        if result.0 == true {
            targetAvailable = true
            targetAmount = result.1
        }
        
        
        
    }
    
    // allows the app to get the latest date of records to display on the main page
    
    func getLatestDate(){
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let array = toShare.datesWithRecords
        
        var dateArray = [NSDate]()
        for stringDate in array{
            
            let correctDate = dateFormatter.dateFromString(stringDate)
            dateArray.append(correctDate!)
        }
        
        
        dateArray.sortInPlace({$0.timeIntervalSinceNow > $1.timeIntervalSinceNow})
        
        if dateArray.count != 0{
            let dateStringToDisplay = dateFormatter.stringFromDate(dateArray[0])
            lastRecordLabel.text = "Your last record was on: ".localized() + dateStringToDisplay
            //lastRecordLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        }else{
            lastRecordLabel.text = "No records yet.".localized()
        }
        
    }
    
    
    // allows app to get todays date and populate the labels on the storyboard
    
    func getTodayDate(){
        var toDisplayDate = ""
        let date = moment(NSDate())
        var dayString = ""
        if date.day == 1 || date.day == 21{
            dayString = String(date.day) + "st".localized()
            
        }else if date.day == 2 || date.day == 22{
            dayString = String(date.day) + "nd".localized()
            
        }else if date.day == 3 || date.day == 23{
            dayString = String(date.day) + "rd".localized()
            
        }else{
            dayString = String(date.day) + "th".localized()
        }
        let lang = NSUserDefaults.standardUserDefaults().objectForKey("langPref") as? String
        if lang == "zh-Hans" {
            toDisplayDate += date.monthName.localized() + " \(dayString) " + " \(date.year) 年"
        }else{
            toDisplayDate += dayString + " " + date.monthName.localized() + " " + String(date.year)
        }
        overviewLabel.text = date.weekdayName.localized() + "\n" + toDisplayDate
        
    }
    @IBAction func syncRecords(sender: UIButton) {
        if connectionDAO().isConnectedToNetwork(){
            let alertController = UIAlertController(title: "Sync Records".localized(), message: "Are you sure?".localized(), preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Yes".localized(), style: .Default, handler: { (action) -> Void in
                
                // Pop up telling the user that you are currently syncing
                let popup = UIAlertController(title: "Syncing".localized(), message: "Please wait.".localized(), preferredStyle: .Alert)
                self.presentViewController(popup, animated: true, completion: {
                    let syncSucceed = ProfileController().sync()
                    if (syncSucceed) {
                        
                        // Retrieval succeed, inform the user that records are synced.
                        popup.dismissViewControllerAnimated(true, completion: {
                            let alertController = UIAlertController(title: "Sync Complete!".localized(), message: "Please proceed.".localized(), preferredStyle: .Alert)
                            let ok = UIAlertAction(title: "Ok".localized(), style: .Cancel, handler: { void in
                                
                                self.viewWillAppear(true)
                            })
                            alertController.addAction(ok)
                            self.presentViewController(alertController, animated: true,completion: nil)
                        })
                        
                    } else {
                        
                        // Retrieval failed, inform user that he can sync again after he log in.
                        popup.dismissViewControllerAnimated(true, completion: {
                            let alertController = UIAlertController(title: "Sync Failed!".localized(), message: "Please try again later.".localized(), preferredStyle: .Alert)
                            let ok = UIAlertAction(title: "Ok".localized(), style: .Cancel, handler: nil)
                            alertController.addAction(ok)
                            self.presentViewController(alertController, animated: true,completion: nil)
                        })
                    }
                })
            })
            let no = UIAlertAction(title: "No".localized(), style: .Cancel, handler: nil)
            alertController.addAction(ok)
            alertController.addAction(no)
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            
            let alertController = UIAlertController(title: "Please find a internet connection.".localized(), message: "Please try again later.".localized(), preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok".localized(), style: .Cancel, handler: nil)
            alertController.addAction(ok)
            self.presentViewController(alertController, animated: true,completion: nil)
        }
    }
    
}




