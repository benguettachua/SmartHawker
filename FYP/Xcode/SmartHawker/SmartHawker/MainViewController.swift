//
//  ViewController.swift
//  KDCalendar
//
//  Created by Michael Michailidis on 01/04/2015.
//  Copyright (c) 2015 Karmadust. All rights reserved.
//

import UIKit
import SwiftMoment
import CoreLocation;

class MainViewcontroller: UIViewController, WeatherGetterDelegate, CLLocationManagerDelegate{
    
    // Mark: Properties
    var tempCounter = 0
    var records = [RecordTable]()
    var day: String!
    typealias CompletionHandler = (success:Bool) -> Void
    let user = PFUser.currentUser()
    var datesAndRecords = [String:[RecordTable]]()
    let locationManager = CLLocationManager()
    
    //for highest , lowest and average
    @IBOutlet weak var lowestSales: UILabel!
    @IBOutlet weak var highestSales: UILabel!
    @IBOutlet weak var averageSales: UILabel!
    @IBOutlet weak var lowestSalesDay: UILabel!
    @IBOutlet weak var highestSalesDay: UILabel!
    
    @IBOutlet weak var lowestProfit: UILabel!
    @IBOutlet weak var highestProfit: UILabel!
    @IBOutlet weak var averageProfit: UILabel!
    @IBOutlet weak var lowestProfitDay: UILabel!
    @IBOutlet weak var highestProfitDay: UILabel!
    
    @IBOutlet weak var lastRecordLabel: UILabel!
    
    @IBOutlet weak var otherExpensesAmount: UILabel!
    @IBOutlet weak var COGSAmount: UILabel!
    @IBOutlet weak var salesAmount: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    //for weather
    @IBOutlet weak var weather: UILabel!
    @IBOutlet weak var temperature: UILabel!
    var weather1: WeatherGetter!
    
    //for language preference
    let lang = NSUserDefaults.standardUserDefaults().objectForKey("langPref") as? String
    
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.


    
    override func viewDidLoad() {
        super.viewDidLoad()
        let weather1 = WeatherGetter(delegate: self)
        
        getLatestDate()
        var toDisplayDate = "Overview as of "
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
        if lang == "zh-Hans" {
            toDisplayDate += date.monthName.localized() + " \(self.day) " + " \(date.year) 年"
        }else{
            toDisplayDate += dayString + " " + date.monthName + " " + String(date.year)
        }
        overviewLabel.text = toDisplayDate
        
        // Formatting to format as saved in DB.
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        let correctDateString = dateFormatter.stringFromDate(NSDate())
        
        loadRecordsFromLocaDatastore({ (success) -> Void in
            self.getLocation()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            

            var totalSales = 0.0
            var totalDays = 0.0
            var highSales: Double!
            var highSalesDay: String!
            var highProfit: Double!
            var highProfitDay: String!
            var lowSales: Double!
            var lowSalesDay: String!
            var lowProfit: Double!
            var lowProfitDay: String!
            var totalProfit = 0.0
            var COGS = 0.0
            var expenses = 0.0
            
            for (myKey,myValue) in self.datesAndRecords {
                let recordDate = dateFormatter.dateFromString(myKey)
                let earlier = recordDate!.earlierDate(NSDate()).isEqualToDate(recordDate!) && myKey.containsString(correctDateString)
                let same = recordDate!.isEqualToDate(NSDate())
                var profit = 0.0
                var sales = 0.0

            
            for record in myValue {
                
                if earlier || same {
                    let type = record.type
                    let amount = Double(record.amount)
                    //let subuser = object["subuser"] as? String
                    if (type == "Sales") {
                        totalProfit += amount
                        totalSales += amount
                        profit += amount
                        sales += amount
                 
                    } else if (type == "COGS") {
                        COGS += amount
                        profit -= amount
                        totalProfit -= amount
                    } else if (type == "Expenses") {
                        expenses += amount
                        profit -= amount
                        totalProfit -= amount
                    }

                    
                    totalDays += 1.0
                }
                 //to get max and min sales
                 if highSales == nil{
                    highSales = sales
                    highSalesDay = record.date
                 }else if sales > highSales{
                    highSales = sales
                    highSalesDay = myKey
                 }
                 
                 
                 if lowSales == nil{
                    lowSales = sales
                    lowSalesDay = myKey
                 }else if sales < lowSales{
                    lowSales = sales
                    lowSalesDay = myKey
                 }
                 
                 if highProfit == nil{
                    highProfit = profit
                    highProfitDay = record.date
                 }else if profit > highProfit{
                    highProfit = profit
                    highProfitDay = myKey
                 }
                 
                 if lowProfit == nil{
                    lowProfit = profit
                    lowProfitDay = myKey
                 }else if profit < lowProfit{
                    lowProfit = profit
                    lowProfitDay = myKey
                 }
            }
            
            }
            if totalDays == 0.0 {
                highSales = 0.0
                highProfit = 0.0
                lowSales = 0.0
                lowProfit = 0.0
                highProfitDay = "None"
                lowProfitDay = "None"
                highSalesDay = "None"
                lowSalesDay = "None"
            }
            self.salesAmount.text = String(totalSales)
            self.COGSAmount.text = String(COGS)
            self.otherExpensesAmount.text = String(expenses)
            self.highestProfit.text = String(highProfit)
            self.lowestProfit.text = String(lowProfit)
            if totalProfit == 0{
                self.averageProfit.text = "0"
            }else{
                self.averageProfit.text = String((totalProfit/totalDays))
            }
            self.highestSales.text = String(highSales)
            self.lowestSales.text = String(lowSales)
            if totalSales == 0{
                self.averageSales.text = "0"
            }else{
                self.averageSales.text = String((totalSales/totalDays))
            }
            self.highestProfitDay.text = highProfitDay
            self.lowestProfitDay.text = lowProfitDay
            self.highestSalesDay.text = highSalesDay
            self.lowestSalesDay.text = lowSalesDay
            
        })
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadRecordsFromLocaDatastore(completionHandler: CompletionHandler) {
        // Load from local datastore into UI.
        let query = PFQuery(className: "Record")
        query.whereKey("user", equalTo: user!)
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        let dateString = object["date"] as! String
                        let type = object["type"] as! Int
                        let amount = object["amount"] as! Int
                        var localIdentifierString = object["subUser"]
                        var typeString = ""
                        if (type == 0) {
                            typeString = "Sales"
                        } else if (type == 1) {
                            typeString = "COGS"
                        } else if (type == 2) {
                            typeString = "Expenses"
                        } else if (type == 3){
                            typeString = "fixMonthlyExpenses"
                        }
                        
                        var description = object["description"]
                        
                        if (description == nil || description as! String == "") {
                            description = "No description"
                        }
                        
                        if (localIdentifierString == nil) {
                            localIdentifierString = String(self.tempCounter += 1)
                        }
                        
                        let newRecord = RecordTable(date: dateString, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String)
                        self.records.append(newRecord)
                        if self.datesAndRecords[dateString] == nil {
                            var arrayForRecords = [RecordTable]()
                            arrayForRecords.append(newRecord)
                            self.datesAndRecords[dateString] = arrayForRecords
                        }else{
                            self.datesAndRecords[dateString]?.append(newRecord)
                        }
                    }
                    completionHandler(success: true)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
                completionHandler(success: false)
            }
        }
    }
 
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
        let dateStringToDisplay = dateFormatter.stringFromDate(dateArray[0])
        lastRecordLabel.text = "Your last record was on: " + dateStringToDisplay
    }
    

    // MARK: WeatherGetterDelegate methods
    // -----------------------------------
    
    func didGetWeather(weather: Weather) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the code
        // that updates all the labels in a dispatch_async() call.
        dispatch_async(dispatch_get_main_queue()) {
            self.weather.text = weather.weatherDescription
            self.temperature.text = "\(Int(round(weather.tempCelsius)))°"
        }
    }
    
    func didNotGetWeather(error: NSError) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the call
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        dispatch_async(dispatch_get_main_queue()) {
            self.showSimpleAlert(title: "Can't get the weather",
                                 message: "The weather service isn't responding.")
        }
        print("didNotGetWeather error: \(error)")
    }
    
    func showSimpleAlert(title title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .Alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .Default,
            handler: nil
        )
        alert.addAction(okAction)
        presentViewController(
            alert,
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - CLLocationManagerDelegate and related methods
    
    func getLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            showSimpleAlert(
                title: "Please turn on location services",
                message: "This app needs location services in order to report the weather " +
                    "for your current location.\n" +
                "Go to Settings → Privacy → Location Services and turn location services on."
            )
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .AuthorizedWhenInUse else {
            switch authStatus {
            case .Denied, .Restricted:
                let alert = UIAlertController(
                    title: "Location services for this app are disabled",
                    message: "In order to get your current location, please open Settings for this app, choose \"Location\"  and set \"Allow location access\" to \"While Using the App\".",
                    preferredStyle: .Alert
                )
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                let openSettingsAction = UIAlertAction(title: "Open Settings", style: .Default) {
                    action in
                    if let url = NSURL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
                alert.addAction(cancelAction)
                alert.addAction(openSettingsAction)
                presentViewController(alert, animated: true, completion: nil)
                return
                
            case .NotDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("Oops! Shouldn't have come this far.")
            }
            
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        print(newLocation.coordinate.latitude)
        print(newLocation.coordinate.longitude)
        weather1.getWeatherByCoordinates(latitude: newLocation.coordinate.latitude,
                                        longitude: newLocation.coordinate.longitude)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // All UI code needs to execute in the main queue, which is why we're wrapping the call
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        dispatch_async(dispatch_get_main_queue()) {
            self.showSimpleAlert(title: "Can't determine your location",
                                 message: "The GPS and other location services aren't responding.")
        }
        print("locationManager didFailWithError: \(error)")
    }
}
