//
//  ArAnalytics.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/19/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit
import Woopra

//
// ArAnalytics
//
class ArAnalytics : NSObject {
    
    // MARK: - Init Woopra Tracker
    static func initWoopra() {
        // external lib woopra, real time tracking
        WTracker.sharedInstance().domain = "arumdaunchurch.org"
        WTracker.sharedInstance().idleTimeout = 60
        WTracker.sharedInstance().pingEnabled = true
    }
    
    
    // MARK: - send tracking event
    
    static func addTrackProperty(_ properties: [String:String]) ->Void {
        // woopra
        for property in properties {
            WTracker.sharedInstance().visitor.addProperty(property.key, value: property.value)
        }
    }
    
    static func sendTrackEvent(_ eventName: String, properties: [String:String]) ->Void {
        // woopra
        let event: WEvent = WEvent.init(name: eventName)
        event.addProperties(properties)
        WTracker.sharedInstance().trackEvent(event)
        
        
    }
    
    static func sendTrackClickEvent(_ properties: [String:String]) ->Void {
        // woopra
        let event: WEvent = WEvent.init(name: "click")
        event.addProperties(properties)
        WTracker.sharedInstance().trackEvent(event)
    }
}
