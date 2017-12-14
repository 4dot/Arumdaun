//
//  Date+ArDate.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/19/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation

let NEWYORK_TIMEZONE = "EDT"
let DEFAULT_TIMEFORMAT = "yyyy-MM-dd hh:mm"

extension Date {
    /**
     * @desc foramt string: ex. "04 Sep 2014"
     */
    func toString(format: String = "dd MMM yyyy", timeZone: String = NEWYORK_TIMEZONE) ->String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(abbreviation: timeZone)
        return formatter.string(from: self)
    }
    
    func toLocalStringWithFormat(format: String = DEFAULT_TIMEFORMAT) -> String {
        // change to a readable time format and change to local time zone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: self)
        return timeStamp
    }
    
    func toTimeZone(format: String = DEFAULT_TIMEFORMAT, timeZone: String = NEWYORK_TIMEZONE) ->Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = TimeZone.current// TimeZone(abbreviation: timeZone)
        return formatter.date(from: self.toString(format: format))
    }
    
    func toComponent(timeZone: String = NEWYORK_TIMEZONE)-> DateComponents {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.timeZone = TimeZone(abbreviation: timeZone)!
        return gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    }
    
    // MARK: - statics
    
    static func withString(dateString: String, format: String = DEFAULT_TIMEFORMAT)-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: dateString)
    }
    
    static func toDate(from components: DateComponents, timeZone: String = NEWYORK_TIMEZONE)-> Date {
        var cal = Calendar.current
        cal.timeZone = TimeZone(abbreviation: timeZone)!
        return cal.date(from: components)!
    }
}
