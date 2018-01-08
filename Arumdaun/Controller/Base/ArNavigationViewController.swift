//
//  ArNavigationViewController.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/1/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit

//
// ArNavigationViewController class
//
class ArNavigationViewController : ENSideMenuNavigationController {
    
    
    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create sidemenu view controller
        let menuVC = UIStoryboard.loadSideMenuViewController()
        menuVC.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        sideMenu = ENSideMenu(sourceView: self.view, menuViewController: menuVC, menuPosition:.left)
        sideMenu?.menuWidth = self.view.frame.width
        sideMenu?.bouncingEnabled = false
        sideMenu?.usingBlurEffect = false
        sideMenu?.usingSwipeGesture = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ArNavigationViewController : ENSideMenuDelegate {
    // MARK: - ENSideMenu Delegate
    func sideMenuWillOpen() {
        print("sideMenuWillOpen")
    }
    
    func sideMenuWillClose() {
        print("sideMenuWillClose")
    }
    
    func sideMenuDidClose() {
        print("sideMenuDidClose")
    }
    
    func sideMenuDidOpen() {
        print("sideMenuDidOpen")
    }
}

//
// can open popup screen from any view controller
//
extension ArNavigationViewController {
    // MARK: - Class func
    /**
     * @desc Class function, open full screen pupup view for audio play
     * @param parent parentViewController, audioId audio id
     */
    class func openAudioContentView(_ parent: UIViewController, audioId: String, audioName: String) {
        // open full screen web player
        let vc = UIStoryboard.loadAudioViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.audioId = audioId
        vc.audioName = audioName
        vc.targetParent = parent
        
        parent.present(vc, animated: true, completion: nil)
    }
    
    class func openYoutubeContentView(_ parent: UIViewController, youtubeData: YoutubeData) {
        // open full screen web player
        let vc = UIStoryboard.loadYTPlayerViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.videoTitle = youtubeData.title
        vc.videoSubTitle = youtubeData.subTitle
        vc.videoDesc = youtubeData.desc
        vc.videoId = youtubeData.videoId
        
        parent.present(vc, animated: true, completion: nil)
    }
}
