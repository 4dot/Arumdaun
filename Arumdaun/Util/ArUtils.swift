//
//  ArUtils.swift
//  Arumdaun
//
//  Created by chanick park on 6/25/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit
import Lottie

class ArUtils {
    /**
     * @desc get version string
     */
    static func versionString() -> String {
        let dictionary = Bundle.main.infoDictionary!
        if let version = dictionary["CFBundleShortVersionString"] as? String {
            return version
        }
        return ""
    }
    
    // MARK: - Lottie Animation
    
    /**
     * @desc lottie animation
     */
    static func getLottieAnimation(_ target: UIView, name: String, size: CGSize = CGSize(width: 30, height: 30) , loop: Bool = true) -> LottieAnimationView {
        // show after effect animation
        let animationView = LottieAnimationView(name: name)
        
        // center
        animationView.frame = CGRect(x: target.frame.size.width/2 - size.width/2, y: target.frame.size.height/2 - size.height/2, width: size.width, height: size.height)
        animationView.loopMode = .loop
        animationView.play()
        
        return animationView
    }
}


//
// ArDevice
//
class ArDevice {
    static var deviceUUID: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    static var userName: String {
        return UIDevice.current.name
    }
    
    static var deviceModel: String {
        return UIDevice.current.model
    }
}
