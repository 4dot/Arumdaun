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
        let now = Date()
        // show up/down, 1 (sunday)
        guard Calendar.current.component(.weekday, from: now) == 1 else {
            self.showLiveBroadCastingView(false)
            return
        }
        
        // broadcasting time : 8:30 ~ 12:30
        var startComponents = now.toComponent()
        startComponents.hour = 8
        startComponents.minute = 30
        
        var endComponents = now.toComponent()
        endComponents.hour = 12
        endComponents.minute = 30
        
        let startDate = Date.toDate(from: startComponents)
        let endDate = Date.toDate(from: endComponents)
        
        if now >= startDate && now < endDate {
            self.showLiveBroadCastingView(true)
        } else {
            self.showLiveBroadCastingView(false)
        }
    }
    
    func showLiveBroadCastingView(_ show: Bool) {
        if liveBroadcastringIsShown == show {
            return
        }
        
        let startPos = show ? 0 : self.liveBroadCastingView.frame.size.height
        let endPos = show ? self.liveBroadCastingView.frame.size.height : 0
        
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
