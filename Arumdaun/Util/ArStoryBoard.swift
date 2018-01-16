//
//  ArStoryBoard.swift
//  Arumdaun
//
//  Created by Dino Bartosak on 18/09/16.
//  Copyright © 2016 Toptal. All rights reserved.
//

import Foundation



import UIKit

fileprivate enum Storyboard : String {
    case main = "Main"
    // add enum case for each storyboard in your project
}

fileprivate extension UIStoryboard {
    
    static func loadFromMain(_ identifier: String) -> UIViewController {
        return load(from: .main, identifier: identifier)
    }
    
    // optionally add convenience methods for other storyboards here ...
    
    // ... or use the main loading method directly when
    // instantiating view controller from a specific storyboard
    static func load(from storyboard: Storyboard, identifier: String) -> UIViewController {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: identifier)
    }
}

// MARK: App View Controllers

extension UIStoryboard {
    
    class func loadSideMenuViewController() -> SideMenuViewController {
        return loadFromMain("SideMenuViewController") as! SideMenuViewController
    }
    
    class func loadMainViewController() -> MainViewController {
        return loadFromMain("MainViewController") as! MainViewController
    }
    
    class func loadSermonController() -> SermonViewController {
        return loadFromMain("SermonViewController") as! SermonViewController
    }
    
    class func loadWorshipViewController() -> WorshipViewController {
        return loadFromMain("WorshipViewController") as! WorshipViewController
    }
    
    class func loadNewsViewController() -> NewsViewController {
        return loadFromMain("NewsViewController") as! NewsViewController
    }
    
    class func loadPDFViewController() -> PDFViewController {
        return loadFromMain("PDFViewController") as! PDFViewController
    }
    
    class func loadYTPlayerViewController() -> YTPlayerViewController {
        return loadFromMain("YTPlayerViewController") as! YTPlayerViewController
    }
    
    class func loadLaunchScreenViewController() -> LaunchScreenViewController {
        return loadFromMain("LaunchScreenViewController") as! LaunchScreenViewController
    }
    
    class func loadAudioViewController() -> AudioViewController {
        return loadFromMain("AudioViewController") as! AudioViewController
    }
}
