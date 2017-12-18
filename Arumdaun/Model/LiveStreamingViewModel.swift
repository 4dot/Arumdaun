//
//  LiveStreamingViewModel.swift
//  Arumdaun
//
//  Created by Park, Chanick on 12/18/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import Kanna


class LiveStreamingViewModel : NSObject {
    
    /**
     * @desc load main view's data
     */
    func loadLiveStreamingContent(complete: @escaping (_ data: [YoutubeData])->Void) {
        // request
        // ex. https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UC_SMi4TOmGvZnVb2SLpbGyw&eventType=live&type=video&key=AIzaSyCa7dAbw2Oai90RvbOSpjNrLbwELK78r6M
        let apiURL = "\(YT_SEARCH)?part=snippet&channelId=\(YT_LIVEVIDEO_CHANNEL_ID)&eventType=live&type=video&key=\(YT_API_KEY)"
        
        ArNetwork.manager.request(ArNetwork.urlRequest(apiURL)).responseJSON(completionHandler: { (response) in
            print("\(response)")
            
            var ytDataList: [YoutubeData] = []
            
            if let json = response.result.value as? [String: Any] {
                // get items
                if let items = json["items"] as? [Any] {
                    for item in items {
                        if let validItem = item as? [String: Any] {
                            ytDataList.append(YoutubeData(json: validItem))
                        }
                    }
                }
            }
            
            // response
            complete(ytDataList)
        })
    }
}
