//
//  YoutubeData.swift
//  Arumdaun
//
//  Created by Park, Chanick on 7/12/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation


//
// YoutubeData
//
class YoutubeData : NSObject {
    
    var playListId: String = ""
    var videoId: String = ""
    var title: String = ""
    var subTitle: String = ""
    var desc: String = ""
    var thumbnailURL: String = ""
    
    required init( item: [String : Any]) {
        super.init()
        
        playListId = item["playListId"] as? String ?? ""
        title = item["title"] as? String ?? ""
        subTitle = item["subTitle"] as? String ?? ""
        videoId = item["videoId"] as? String ?? ""
    }
    
    required init(json item: [String : Any], _ imgQuality: String = "default") {
        super.init()
        
        if let movieInfo = item["snippet"] as? [String : Any] {
            playListId = movieInfo["playlistId"] as? String ?? ""
            title = movieInfo["title"] as? String ?? ""
            subTitle = item["subTitle"] as? String ?? ""
            desc = movieInfo["description"] as? String ?? ""
            thumbnailURL = ""
            
            if let thumbnails = movieInfo["thumbnails"] as? [String: Any],
                let defaultImg = thumbnails[imgQuality]  as? [String: Any] {
                thumbnailURL = defaultImg["url"] as? String ?? ""
            }
            
            if let resourceId = movieInfo["resourceId"] as? [String : Any] {
                videoId = resourceId["videoId"] as? String ?? ""
            }
        }
    }
}

