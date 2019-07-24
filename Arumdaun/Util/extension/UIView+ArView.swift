//
//  UIView+ArView.swift
//  Arumdaun
//
//  Created by Park, Chanick on 7/10/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC

extension UIView
{
    /// add property, name
    struct Static {
        static var key = "key"
    }
    var arName:String? {
        get {
            return objc_getAssociatedObject( self, &Static.key ) as! String?
        }
        set {
            objc_setAssociatedObject( self, &Static.key,  newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    // MARK: - outline, shadow
    func outline(_ border: CGFloat, bgColor: UIColor, radius: CGFloat, borderColor: UIColor) {
        
        self.layer.cornerRadius = radius
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = border
        self.backgroundColor = bgColor
    }
    
    func dropShadow(_ offset: CGSize = CGSize(width: 1, height: 1), _ color: UIColor = UIColor.black, _ radius: CGFloat = 1) {
        
        //self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = radius
    }
}


extension UIView {
    // MARK: - blur
    func makeBlurEffectView(style: UIBlurEffect.Style? = nil) -> UIVisualEffectView {
        let blurEffectView = UIVisualEffectView()
        
        if let style = style {
            blurEffectView.effect = UIBlurEffect(style: style)
        }
        
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        return blurEffectView
    }
    
    func addBlurEffectView(sendBack:Bool = false) {
        let blurEffectView = makeBlurEffectView()
        self.addSubview(blurEffectView)
        
        if sendBack {
            self.sendSubviewToBack(blurEffectView)
        }
    }
}

