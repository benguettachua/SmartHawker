
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
    
    
    // MARK: outlets on the storyboard
    
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
    @IBOutlet weak var todayEntryLabel: UILabel!
    @IBOutlet weak var monthlyTargetLabel: UILabel!
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    
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
        
        infoButton.titleLabel?.lineBreakMode
        infoButton.titleLabel?.numberOfLines = 2
        infoButton.titleLabel!.textAlignment = .Center
        
        var info = String(format: "%C", faicon["fainfo"]!)
        
        info += "\n"
        
        info += "Info".localized()
        
        infoButton.titleLabel!.font = UIFont(name: "FontAwesome", size: 15)
        
        infoButton.setTitle(String(info), forState: .Normal)
        
        //set labels for translation
        lowestSalesLabel.text = "Lowest Sales".localized()
        
        highestSalesLabel.text = "Highest Sales".localized()
        
        averageSalesLabel.text = "Average Sales".localized()

        profitLabel.text = "Profit".localized()
        expensesLabel.text = "Expenses".localized()
        salesLabel.text = "Sales".localized()
        todayEntryLabel.text = "ADD NEW RECORD".localized()
        monthlyTargetLabel.text = "SET MONTHLY TARGET".localized()
        //syncButton.setTitle("Sync".localized(), forState: UIControlState.Normal)
        //infoButton.setTitle("Info".localized(), forState: UIControlState.Normal)
        // Initialize UI
        // -------------
        getTodayDate()
        getLatestDate()
        getMonthlyTarget()
        if(targetAvailable) {
            targetButton.setImage(UIImage(named: "profile-edit-button"), forState: .Normal)
            targetButton.setTitle("$" + String(format: "%.0f", targetAmount), forState: .Normal)
            targetButton.transform = CGAffineTransformMakeScale(-1.0, 1.0)
            targetButton.titleLabel!.transform = CGAffineTransformMakeScale(-1.0, 1.0)
            targetButton.imageView!.transform = CGAffineTransformMakeScale(-1.0, 1.0)
        }
        
        let values = MainController().getMainValues()
        self.salesAmount.text = "$" + String(format: "%.0f", values.0)
        self.otherExpensesAmount.text = "$" + String(format: "%.0f", values.1)
        self.totalProfit.text = "$" + String(format: "%.0f", values.2)
        if values.2 < 0 {
            self.totalProfit.textColor = UIColor(red: 234/255, green: 0/255, blue: 0/255, alpha: 1)
        }else{
            self.totalProfit.textColor = UIColor(red: 83/255, green: 142/255, blue: 0/255, alpha: 1)
        }
        self.highestSales.text = "$" + String(format: "%.0f", values.3)
        self.lowestSales.text = "$" + String(format: "%.0f", values.4)
        if values.5 == 0{
            self.averageSales.text = "$0"
        }else{
            self.averageSales.text = "$" + String(format: "%.0f", values.5)
        }
        self.highestSalesDay.text = values.6
        self.lowestSalesDay.text = values.7
        
        overview.text = "Overview for ".localized() + moment(NSDate()).monthName.localized()
        
        connectionDAO().loadStringIntoAutoFill()
        print(toShare.stringsWithAutoFill)
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
        let array = NSUserDefaults.standardUserDefaults().objectForKey("SavedDateArray") as? [String] ?? [String]()
        var dateArray = [NSDate]()
        for stringDate in array{
            
            let correctDate = dateFormatter.dateFromString(stringDate)
            dateArray.append(correctDate!)
        }
        dateArray.sortInPlace({$0.timeIntervalSinceNow > $1.timeIntervalSinceNow})
        if dateArray.count != 0{
            let dateStringToDisplay = dateFormatter.stringFromDate(dateArray[0])
            lastRecordLabel.text = "Your last record was on:\n".localized() + dateStringToDisplay
            lastRecordLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
            lastRecordLabel.numberOfLines = 2
        }else{
            lastRecordLabel.text = "Your have yet to make any records.".localized()
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
            toDisplayDate += dayString + " " + date.monthName + " " + String(date.year)
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
                            let ok = UIAlertAction(title: "Ok".localized(), style: .Cancel, handler: nil)
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




