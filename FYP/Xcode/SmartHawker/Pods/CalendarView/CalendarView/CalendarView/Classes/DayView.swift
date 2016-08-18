//
//  DayView.swift
//  Calendar
//
//  Created by Nate Armstrong on 3/28/15.
//  Copyright (c) 2015 Nate Armstrong. All rights reserved.
//

import UIKit
import SwiftMoment

let CalendarSelectedDayNotification = "CalendarSelectedDayNotification"

class DayView: UIView {
    var date: Moment! {
        didSet {
            dateLabel.text = date.format("d")
            setNeedsLayout()
        }
    }
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .Center
        //label.font = CalendarView.dayFont
        
        let modelName = UIDevice.currentDevice().modelName
        print(modelName)
        if modelName.containsString("iPhone 4"){
            label.font = UIFont.systemFontOfSize(12)
        }else if modelName.containsString("iPhone 5"){
            label.font = UIFont.systemFontOfSize(13)
        }else if modelName.containsString("iPhone 6"){
            label.font = UIFont.systemFontOfSize(16)
        }
        
        self.addSubview(label)
        return label
    }()
    var isToday: Bool = false
    var isOtherMonth: Bool = false
    var recordingExist: Bool = false
    var selected: Bool = false {
        didSet {
            if selected {
                NSNotificationCenter.defaultCenter()
                    .postNotificationName(CalendarSelectedDayNotification, object: date.toNSDate())
            }
            updateView()
        }
    }
    
    init() {
        super.init(frame: CGRectZero)
        let tap = UITapGestureRecognizer(target: self, action: "select")
        addGestureRecognizer(tap)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: "onSelected:",
                                                         name: CalendarSelectedDayNotification,
                                                         object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.frame = CGRectInset(bounds, 15, 0)
        updateView()
    }
    
    func onSelected(notification: NSNotification) {
        if let date = date, nsDate = notification.object as? NSDate {
            let mo = moment(nsDate)
            if mo.month != date.month || mo.day != date.day {
                selected = false
            }
        }
    }
    
    
    //where the days in the calendar are populated
    func updateView() {
        if isToday {
            
            let size:CGFloat = 35.0 // 35.0 chosen arbitrarily
            
            dateLabel.bounds = CGRectMake(0.0, 0.0, size, size)
            dateLabel.layer.cornerRadius = size / 2
            dateLabel.layer.borderWidth = 3.0
            dateLabel.layer.borderColor = UIColor.orangeColor().CGColor
            dateLabel.textColor = CalendarView.todayTextColor
        } else if self.selected {
            
            let size:CGFloat = 35.0 // 35.0 chosen arbitrarily
            
            dateLabel.bounds = CGRectMake(0.0, 0.0, size, size)
            dateLabel.layer.cornerRadius = size / 2
            dateLabel.layer.backgroundColor = UIColor.orangeColor().CGColor
            dateLabel.layer.borderColor = UIColor.clearColor().CGColor
            dateLabel.textColor = CalendarView.daySelectedTextColor
        }
        else if isOtherMonth {
            
            dateLabel.layer.borderColor = UIColor.clearColor().CGColor
            dateLabel.layer.backgroundColor = UIColor.clearColor().CGColor
            dateLabel.textColor = CalendarView.otherMonthTextColor
            dateLabel.backgroundColor = CalendarView.otherMonthBackgroundColor
        } else if recordingExist {
            if dateLabel.text != nil{
                
                let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
                let underlineAttributedString = NSAttributedString(string: dateLabel.text!, attributes: underlineAttribute)
                
                dateLabel.layer.borderColor = UIColor.clearColor().CGColor
                dateLabel.layer.backgroundColor = UIColor.clearColor().CGColor
                dateLabel.attributedText = underlineAttributedString
                dateLabel.textColor = UIColor.blueColor()
                self.dateLabel.backgroundColor = CalendarView.dayBackgroundColor
            }
        } else {
            dateLabel.layer.backgroundColor = UIColor.clearColor().CGColor
            
            dateLabel.layer.borderColor = UIColor.clearColor().CGColor
            self.dateLabel.textColor = CalendarView.dayTextColor
            self.dateLabel.backgroundColor = CalendarView.dayBackgroundColor
        }
    }
    
    func select() {
        selected = true
    }
    
}

public extension Moment {
    
    func toNSDate() -> NSDate? {
        let epoch = moment(NSDate(timeIntervalSince1970: 0))
        let timeInterval = self.intervalSince(epoch)
        let date = NSDate(timeIntervalSince1970: timeInterval.seconds)
        return date
    }
    
    func isToday() -> Bool {
        let cal = NSCalendar.currentCalendar()
        return cal.isDateInToday(self.toNSDate()!)
    }
    
    // for days with recordings
    
    func recordingExist(array: [String]) -> Bool {

        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.defaultTimeZone()
        formatter.dateFormat = "dd/MM/yyyy"
        let d = formatter.stringFromDate(self.toNSDate()!)
        return array.contains(d)
        
    }
    
    
    func isSameMonth(other: Moment) -> Bool {
        return self.month == other.month && self.year == other.year
    }
    
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 where value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}
