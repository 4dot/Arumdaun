//
//  LiveBroadCastingViewController.swift
//  Arumdaun
//
//  Created by chanick park on 9/24/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit


class LiveBroadCastingViewController : UIViewController {
    static var liveStreamingModel = LiveStreamingViewModel()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // sizing
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
    }
    
    // MARK: - Actions
    @IBAction func watchNowButtonTapped(_ sender: Any) {
        LiveBroadCastingViewController.openLiveStreamingContent(target: self)
    }
    
    // MARK: - global
    static func openLiveStreamingContent(target: UIViewController) {
        // request live streaming video id
        liveStreamingModel.loadLiveStreamingContent { (streamings) in
            guard let streaming = streamings.first else {
                // open full screen youtube player
                ArNavigationViewController.openYoutubeContentView(target, youtubeData: YoutubeData(item: ["videoId" : YT_LIVEVIDEO_ID]))
                return
            }
            // open full screen youtube player
            ArNavigationViewController.openYoutubeContentView(target, youtubeData: YoutubeData(item: ["videoId" : streaming.videoId]))
        }
    }
}
