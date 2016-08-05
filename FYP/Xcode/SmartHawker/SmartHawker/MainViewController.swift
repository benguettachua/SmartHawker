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

class MainViewcontroller: UIViewController, CLLocationManagerDelegate{
    
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
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "54a57adb6525a2526f2a33daeec9a28f"
    
    //for language preference
    let lang = NSUserDefaults.standardUserDefaults().objectForKey("langPref") as? String
    
    var toShare = ShareData.sharedInstance // This is to share the date selected to RecordViewController.


    @IBAction func addTodayRecord(sender: UIButton) {
        if toShare.dateString == nil{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let correctDateString = dateFormatter.stringFromDate(NSDate())
            toShare.dateString = correctDateString            
        }
        self.performSegueWithIdentifier("addRecord", sender: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
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
        //overviewLabel.text = toDisplayDate
        
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
            //self.highestProfit.text = String(highProfit)
            //self.lowestProfit.text = String(lowProfit)
            //if totalProfit == 0{
                //self.averageProfit.text = "0"
            //}else{
                //self.averageProfit.text = String((totalProfit/totalDays))
            //}
            self.highestSales.text = String(highSales)
            self.lowestSales.text = String(lowSales)
            if totalSales == 0{
                self.averageSales.text = "0"
            }else{
                self.averageSales.text = String((totalSales/totalDays))
            }
            //self.highestProfitDay.text = highProfitDay
            //self.lowestProfitDay.text = lowProfitDay
            self.highestSalesDay.text = highSalesDay
            self.lowestSalesDay.text = lowSalesDay
            
        })
        
    }

    @IBAction func refreshWeather(sender: UIButton) {
        self.getLocation()
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
        self.records.removeAll()
        self.datesAndRecords.removeAll()
        var array = [String]()
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
                        let amount = object["amount"] as! Double
                        var localIdentifierString = object["subUser"]
                        var recordedBy = object["subuser"]
                        if (recordedBy == nil) {
                            recordedBy = ""
                        }
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
                        
                        let newRecord = RecordTable(date: dateString, type: typeString, amount: amount, localIdentifier: localIdentifierString! as! String, description: description as! String, recordedUser: recordedBy as! String)
                        self.records.append(newRecord)
                        array.append(dateString)
                        if self.datesAndRecords[dateString] == nil {
                            var arrayForRecords = [RecordTable]()
                            arrayForRecords.append(newRecord)
                            self.datesAndRecords[dateString] = arrayForRecords
                        }else{
                            self.datesAndRecords[dateString]?.append(newRecord)
                        }
                    }
                    let defaults = NSUserDefaults.standardUserDefaults()
                    defaults.setObject(array, forKey: "SavedDateArray")
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
        if dateArray.count != 0{
        let dateStringToDisplay = dateFormatter.stringFromDate(dateArray[0])
        lastRecordLabel.text = "Your last record was on: " + dateStringToDisplay
        }else{
            lastRecordLabel.text = "Your have yet to make any records."
        }
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
        let weatherRequestURL = NSURL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&lat=\(newLocation.coordinate.latitude)&lon=\(newLocation.coordinate.longitude)")!
        getWeather(weatherRequestURL)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // All UI code needs to execute in the main queue, which is why we're wrapping the call
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        dispatch_async(dispatch_get_main_queue()) {
            self.showSimpleAlert(title: "Can't determine your location",
                                 message: "The GPS and other location services aren't responding.")
            self.weatherLabel.text = "Please connect to the internet"
            self.temperatureLabel.text = ""
        }
        print("locationManager didFailWithError: \(error)")
    }

    
    private func getWeather(weatherRequestURL: NSURL) {
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = NSURLSession.sharedSession()
        session.configuration.timeoutIntervalForRequest = 3
        
        // The data task retrieves the data.
        let dataTask = session.dataTaskWithURL(weatherRequestURL) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            if let networkError = error {
                // Case 1: Error
                // An error occurred while trying to get data from the server.
                dispatch_async(dispatch_get_main_queue()) {
                    self.showSimpleAlert(title: "Can't get the weather",
                                         message: "The weather service isn't responding.")
                }
            }
            else {
                // Case 2: Success
                // We got data from the server!
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherData = try NSJSONSerialization.JSONObjectWithData(
                        data!,
                        options: .MutableContainers) as! [String: AnyObject]
                    
                    // If we made it to this point, we've successfully converted the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Let's now used that dictionary to initialize a Weather struct.
                    let weather = weatherData["weather"]![0]!["description"]!! as? String
                    
                    let temperature = String(weatherData["main"]!["temp"]!! as! Double - 273.15)
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        self.temperatureLabel.text = temperature
                        self.weatherLabel.text = weather
                    }
                  // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    //self.delegate.didNotGetWeather(jsonError)
                }
            }
        }
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
}
