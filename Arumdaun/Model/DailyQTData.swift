//
//  DailyQTData.swift
//  Arumdaun
//
//  Created by Park, Chanick on 8/28/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation


//
// DailyQTData
//
class DailyQTData : NSObject {
    
    var date: String = ""
    var title: String = ""
    var desc: String = ""
    
    override init() {
        super.init()
    }
    
    required init(json item: [String : Any]) {
        super.init()
        
        date = item["date"] as? String ?? ""
        title = item["title"] as? String ?? ""
        desc = item["desc"] as? String ?? ""
    }
}
