//
//  MainViewController+LiveBroadCasting.swift
//  Arumdaun
//
//  Created by Park, Chanick on 1/16/18.
//  Copyright © 2018 Chanick Park. All rights reserved.
//

import Foundation


let CHECK_LIVE_BROADCASTING_IDLE = 30    // sec


// live broad casting view
extension MainViewController {
    // MARK: - Actions
    @IBAction func watchNowButtonTapped(_ sender: Any) {
        openLiveStreamingContent(target: self)
    }
    
    // MARK: - check live broadcasting timer
    func startCheckLiveTimer() {
        // update every minute
        checkLiveBroadcasting = Timer.scheduledTimer(timeInterval: TimeInterval(CHECK_LIVE_BROADCASTING_IDLE), target: self, selector: #selector(updateLiveBroadCasting), userInfo: nil, repeats: true)
    }
    
    func stopCheckLiveTimer() {
        checkLiveBroadcasting?.invalidate()
    }
    
    func updateLiveBroadCasting() {
        // live streaming was on?
        liveStreamingModel.loadLiveStreamingContent { (streamings) in
            guard let streaming = streamings.first else {
                // hide
                self.showLiveBroadCastingView(false)
                self.liveStreamingData = nil
                return
            }
            
            let currLiveId = self.liveStreamingData?.videoId ?? ""
            
            // replace
            if currLiveId != streaming.videoId {
                self.liveStreamingData = streaming.copy() as? YoutubeData
            }
            
            // show popup
            self.showLiveBroadCastingView(true, title: streaming.title)
        }
    }
    
    func showLiveBroadCastingView(_ show: Bool, title: String = "") {
        if liveBroadcastringIsShown == show {
            return
        }
        
        self.liveStreamingTitleLbl.text = title
        
        let startPos = show ? -self.liveBroadCastingView.frame.size.height : 0
        let endPos = show ? 0 : -self.liveBroadCastingView.frame.size.height
        
        self.liveBroadCastingViewBottomConstraint.constant = startPos
        UIView.animate(withDuration: 0.25, animations: {
            // show/hide
            self.liveBroadCastingViewBottomConstraint.constant = endPos
            self.liveBroadcastringIsShown = show
            self.liveBroadCastingView.updateFocusIfNeeded()
        })
    }
    
    // MARK: - public
    func openLiveStreamingContent(target: UIViewController) {
        guard let streamData = liveStreamingData else {
            // open full screen youtube player
            ArNavigationViewController.openYoutubeContentView(target, youtubeData: YoutubeData(item: ["videoId" : YT_LIVEVIDEO_ID]))
            return
        }
        // open full screen youtube player
        ArNavigationViewController.openYoutubeContentView(target, youtubeData: streamData)
    }
}
