//
//  MorningQTData.swift
//  Arumdaun
//
//  Created by Park, Chanick on 8/8/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation



//
// MorningQTData
//
class MorningQTData : NSObject {
    
    var id: String = ""
    var fullName: String = ""
    var name: String = ""
    var subName: String = ""
    var mimeType: String = "audio/mp3"
    
    override init() {
        super.init()
    }
    
    required init(json item: [String : Any]) {
        super.init()
        
        id = item["id"] as? String ?? ""
        fullName = item["name"] as? String ?? ""
        mimeType = item["mimeType"] as? String ?? ""
        
        
        // split name by "\""
        // ex. 2017.09.11 - 딤전 6:11-21 \"믿음의 선한 싸움을 싸우라\".mp3
        // ex. 2017.09.11 - 딤전 6:11-21 “믿음의 선한 싸움을 싸우라“.mp3
        
        // remove file extension
        let withoutExt = fullName.fileName()
        var names = withoutExt.components(separatedBy: "\"")
        if names.count < 2 {
            names = withoutExt.components(separatedBy: "“")
        }
        name = names.getElementBy(1) ?? withoutExt
        subName = (names.first != nil) ? (names.first?.components(separatedBy: " - ").getElementBy(1) ?? "") : ""
        subName = subName.trim
    }
}
