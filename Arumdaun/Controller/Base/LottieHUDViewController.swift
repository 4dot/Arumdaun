//
//  LottieHUDViewController.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/19/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit
import Lottie


enum LottieAnimationType : String {
    case loadingBlack = "snap_loader_black"
    case loadingWhite = "snap_loader_white"
    case noInternetConnection = "no_internet_connection"
    
    var desc : String {
        return self.rawValue
    }
}

//
// LottieHUDViewController
//
class LottieHUDViewController : UIViewController {
    var lottieAnimation: LottieAnimationView?
    var currentAnimationType: LottieAnimationType = .loadingWhite
    
    
    // MARK: - show lottie animation
    func showHUDAnimation(_ isShow: Bool, _ type: LottieAnimationType = .loadingWhite, isLoop: Bool = true) {
        if isShow {
            if lottieAnimation == nil {
                lottieAnimation = ArUtils.getLottieAnimation(self.view, name: type.rawValue, loop: isLoop)
                self.view.addSubview(lottieAnimation!)
            } else if currentAnimationType != type {
                lottieAnimation = ArUtils.getLottieAnimation(self.view, name: type.rawValue, loop: isLoop)
            }
            lottieAnimation?.play()
        } else {
            lottieAnimation?.pause()
            lottieAnimation?.isHidden = true
        }
    }
}
