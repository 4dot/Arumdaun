//
//  NewsData.swift
//  Arumdaun
//
//  Created by Park, Chanick on 8/25/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation



enum NewsDataType : String {
    case Header, Content, Footer
}

//
// NewsData
//
class NewsData : NSObject {
    
    var date: String = ""
    var timeInterval: TimeInterval = 0
    var title: String = ""
    var desc: String = ""
    var isExpand: Bool = false
    var dataType: String = ""
    var extraData: String = ""  // extra(url...)
    
    
    
    override init() {
        super.init()
    }
    
    required init(json item: [String : Any]) {
        super.init()
        
        date = item["date"] as? String ?? ""
        timeInterval = item["timeInterval"] as? TimeInterval ?? 0
        title = item["title"] as? String ?? ""
        desc = item["desc"] as? String ?? ""
        extraData = item["extraData"] as? String ?? ""
        dataType = item["dataType"] as? String ?? NewsDataType.Content.rawValue
    }
    
    func copyWithZone(_ zone: NSZone?) -> Any {
        
        let copy = NewsData()
        
        copy.date = date
        copy.timeInterval = timeInterval
        copy.title = title
        copy.desc = desc
        copy.extraData = extraData
        copy.dataType = dataType
        copy.isExpand = isExpand
        
        return copy
    }
}
