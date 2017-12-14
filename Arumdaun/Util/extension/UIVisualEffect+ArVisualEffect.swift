//
//  UIVisualEffect+ArVisualEffect.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/26/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit



extension UIVisualEffectView {
    
    func fadeInEffect(_ style:UIBlurEffectStyle = .light, withDuration duration: TimeInterval = 1.0, complete: @escaping ()->Void) {
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
                self.effect = UIBlurEffect(style: style)
            }
            animator.addCompletion({ (_) in
                complete()
            })
            
            animator.startAnimation()
        }else {
            // Fallback on earlier versions
            UIView.animate(withDuration: duration, animations: {
                self.effect = UIBlurEffect(style: style)
            }, completion: {(result) in
                complete()
            })
        }
    }
    
    func fadeOutEffect(withDuration duration: TimeInterval = 1.0, complete: @escaping ()->Void) {
        if #available(iOS 10.0, *) {
            let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                self.effect = nil
            }
            animator.addCompletion({ (_) in
                complete()
            })
            animator.startAnimation()
            animator.fractionComplete = 1
        }else {
            // Fallback on earlier versions
            UIView.animate(withDuration: duration, animations: {
                self.effect = nil
            }, completion: { (result) in
                complete()
            })
        }
    }
}
