//
//  YTPlayerViewController.swift
//  Arumdaun
//
//  Created by chanick park on 7/12/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import YoutubeKit

protocol YTPlayerViewControllerDelegate : NSObjectProtocol {
}

//
// YTPlayerViewController class
//
class YTPlayerViewController : UIViewController {
    @IBOutlet weak var YTPlayer: UIView!
    
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
        
        // Create a new player
        let player = YTSwiftyPlayer (
            frame: YTPlayer.bounds,
            playerVars: [
                .playsInline(false),
                .videoID(videoId),
                .loopVideo(false),
                .showRelatedVideo(false)
            ])

        // Enable auto playback when video is loaded
        player.autoplay = true
        
        // Set player view
        YTPlayer.addSubview(player)
        player.autoSameSizingWith(YTPlayer)

        // Load video player
        player.loadPlayer()
        
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
