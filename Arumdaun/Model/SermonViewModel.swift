//
//  SermonModel.swift
//  Arumdaun
//
//  Created by chanick park on 9/6/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation



class SermonYoutubeData : NSObject {
    var total: Int = 0
    var nextPage: String = ""
    var datas: [YoutubeData] = []
}

//
// SermonModel
//
class SermonModel : NSObject {
    
    @IBOutlet var sermonAPIClient: SermonAPIClient!
    
    // sermon data (YoutubeData, SermonData)
    var sermonDatas: [SideMenuType.SermonSub : SermonYoutubeData] = [:]
    var morningQTDatas: [MorningQTData] = []
    
    
    
    // MARK: - public
    func loadSermon(_ type: SideMenuType.SermonSub, completion: @escaping ()->Void) {
        
        // update
        switch type {
        case .Weekend, .Friday:
            // request to youtube
            guard let playListId = YTPlayList(rawValue: type.desc)?.ids.playListId else {
                completion()
                return
            }
            // next page
            let nextPage = self.sermonDatas[type]?.nextPage ?? ""
            sermonAPIClient.loadYoutubeData(playListId, nextPageToken: nextPage, imgQuality: "default", complete: { (total, nextPage, datas) in
                // update
                let sermon = self.sermonDatas[type] ?? SermonYoutubeData()
                sermon.total = total
                sermon.nextPage = nextPage
                sermon.datas += datas
                self.sermonDatas[type] = sermon
                
                completion()
            })
            
        case .MorningQT:
            sermonAPIClient.loadMorningSermonData({ (moringQTs) in
                self.morningQTDatas = moringQTs
                
                completion()
            })
            return
        }
    }
    
    func sermonDataCount(by sermonType: SideMenuType.SermonSub)-> Int {
        if sermonType == .MorningQT {
            return morningQTDatas.count
        }
        return sermonDatas[sermonType]?.datas.count ?? 0
    }
    
    func sermonDataTotalCount(by sermonType: SideMenuType.SermonSub)-> Int {
        if sermonType == .MorningQT {
            return morningQTDatas.count
        }
        return sermonDatas[sermonType]?.total ?? 0
    }
    
    func sermonItem(by sermonType: SideMenuType.SermonSub, idx: Int)-> YoutubeData? {
        return sermonDatas[sermonType]?.datas.getElementBy(idx)
    }
    
    func sermonAudioCount()-> Int {
        return morningQTDatas.count
    }
    
    func sermonAudioItem(_ idx: Int)-> MorningQTData? {
        return morningQTDatas.getElementBy(idx)
    }
}
