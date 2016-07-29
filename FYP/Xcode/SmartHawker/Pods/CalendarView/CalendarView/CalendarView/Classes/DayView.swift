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
        label.font = CalendarView.dayFont
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
            dateLabel.font = UIFont.systemFontOfSize(15)
        } else if self.selected {
            
            let size:CGFloat = 35.0 // 35.0 chosen arbitrarily
            
            dateLabel.bounds = CGRectMake(0.0, 0.0, size, size)
            dateLabel.layer.cornerRadius = size / 2
            dateLabel.layer.backgroundColor = UIColor.orangeColor().CGColor
            
            dateLabel.textColor = CalendarView.daySelectedTextColor
            dateLabel.font = UIFont.systemFontOfSize(15)
        }
        else if isOtherMonth {
            dateLabel.layer.backgroundColor = UIColor.clearColor().CGColor
            dateLabel.textColor = CalendarView.otherMonthTextColor
            dateLabel.backgroundColor = CalendarView.otherMonthBackgroundColor
            dateLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 15.0)
        } else if recordingExist {
            if dateLabel.text != nil{
                
                let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
                let underlineAttributedString = NSAttributedString(string: dateLabel.text!, attributes: underlineAttribute)
                
                dateLabel.layer.backgroundColor = UIColor.clearColor().CGColor
                dateLabel.attributedText = underlineAttributedString
                dateLabel.textColor = UIColor.orangeColor()
                self.dateLabel.backgroundColor = CalendarView.dayBackgroundColor
                dateLabel.font = UIFont.boldSystemFontOfSize(16.0)
            }
        } else {
            dateLabel.layer.backgroundColor = UIColor.clearColor().CGColor
            
            self.dateLabel.textColor = CalendarView.dayTextColor
            self.dateLabel.backgroundColor = CalendarView.dayBackgroundColor
            dateLabel.font = UIFont.systemFontOfSize(15)
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
