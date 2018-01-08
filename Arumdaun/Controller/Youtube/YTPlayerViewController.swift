//
//  YTPlayerViewController.swift
//  Arumdaun
//
//  Created by chanick park on 7/12/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation


protocol YTPlayerViewControllerDelegate : NSObjectProtocol {
}

//
// YTPlayerViewController class
//
class YTPlayerViewController : UIViewController {
    @IBOutlet weak var YTPlayer: YTPlayerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var descTextView: UITextView!
    
    var videoTitle: String?
    var videoSubTitle: String?
    var videoDesc: String?
    var videoId: String!
    
    weak var delegate: YTPlayerViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isLandscape = true
        
        titleLabel.text = videoTitle
        subTitleLabel.text = videoSubTitle
        descTextView.text = videoDesc
        descTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        
        // youtube moview load using iframe
        YTPlayer.load(withVideoId: videoId)
        
        // send track event
        ArAnalytics.sendTrackEvent("pv", properties: ["title" : "Youtube Play", "subTitle" : videoTitle ?? ""])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        isLandscape = false
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        //forced rotate to portrait
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        // close
        dismiss(animated: true, completion: nil)
    }
}
