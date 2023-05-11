//
//  MainAPIClient.swift
//  Arumdaun
//
//  Created by chanick park on 9/6/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import Kanna


class MainAPIClient : BaseAPIClient {
    
    /**
     * @desc load main view's data
     */
    func loadPlaceHolderContent(complete: @escaping (_ data: [MainViewContentType : Any])->Void) {
        
        // youtube default preview list
        let kYoutubePreviewIdList = [YTPlayList.WeekendSermon, YTPlayList.WdnesdayVision, YTPlayList.MissioSaturDei]
        
        // content data
        var contentsData: [MainViewContentType : Any] = [:]
        
        // create empty youtube preview list
        var ytPreview: [YoutubeData] = []
        for preview in kYoutubePreviewIdList {
            ytPreview.append(YoutubeData(item: ["playListId" : preview.ids.playListId]))
        }
        contentsData[.Youtube] = ytPreview
        
        // create empty qt
        contentsData[.MorningQT] = MorningQTData()
        
        contentsData[.DailyQT] = DailyQTData()
        
        // create empty news(header, empty cell)
        contentsData[.News] = [NewsData(json: ["title" : "최근 교회 소식", "dataType" : NewsDataType.Header.rawValue]), NewsData()]
        
        // callback
        complete(contentsData)
    }
    
    /**
     * @desc request youtube preview
     * @param listId
     */
    func loadYoutubePreviewData(_ listId: String,
                                complete: @escaping (_ data: YoutubeData)->Void) {
        
        loadYoutubeData(listId, count: 1, imgQuality: "high", complete: { (total, nextPage, datas) in
            let youtube = datas.first ?? YoutubeData(item: ["playListId" : listId])
            complete(youtube)
        })
    }
}
