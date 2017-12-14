//
//  LiveBroadCastingViewController.swift
//  Arumdaun
//
//  Created by chanick park on 9/24/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit


class LiveBroadCastingViewController : UIViewController {
    
    @IBAction func watchNowButtonTapped(_ sender: Any) {
        // open full screen youtube player
        ArNavigationViewController.openYoutubeContentView(self, youtubeData: YoutubeData(item: ["videoId" : YT_LIVEVIDEO_ID]))
    }
}
