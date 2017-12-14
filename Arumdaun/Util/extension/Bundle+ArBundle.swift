//
//  Bundle+ArBundle.swift
//  Arumdaun
//
//  Created by Park, Chanick on 11/29/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation


extension Bundle {
    var displayName: String {
        let name = object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        return name ?? object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    }
    
    var versionString: String {
        let name = object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        return name ?? object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    }
    
    var versionBuild: String {
        let name = object(forInfoDictionaryKey: "CFBundleVersion") as? String
        return name ?? object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String
    }
}
