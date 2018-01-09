//
//  String+ArString.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/12/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit



extension String {
    
    var stringByRemovingWhitespaceAndNewlineCharacterSet: String {
        return components(separatedBy: NSCharacterSet.whitespacesAndNewlines).joined(separator: "")
    }
    /// trim first and last empty spaces
    var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    // get filename only(exclue file extension)
    func fileName() -> String {
        var extCnt = fileExtension().count
        extCnt = extCnt > 0 ? extCnt + 1 : 0
        return String(characters.dropLast(extCnt))
    }
    
    // get file extension
    func fileExtension() -> String {
        
        if let fileExtension = NSURL(fileURLWithPath: self).pathExtension {
            return fileExtension
        } else {
            return ""
        }
    }
    
    var count: Int {
        return self.utf8.count
    }
    
    // MARK: - date
    /**
     * @desc format string: ex. "Thu, 04 Sep 2014 10:50:12 +0000"
     */
    func toDate(format: String = "E, dd MMM yyyy HH:mm:ss Z") ->Date? {
        if self.isEmpty {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? nil
    }
}

extension String {
    // MARK: - URL
    func removeParametersFromURL()-> String {
        if var componenets = URLComponents(string: self) {
            componenets.query = nil
            return componenets.description
        }
        return self
    }
    
    func encodingQueryAllowed() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
    }
}
