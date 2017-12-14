//
//  WorshipViewModel.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/11/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation


class WorshipYoutubeData : NSObject {
    var total: Int = 0
    var nextPage: String = ""
    var datas: [YoutubeData] = []
}

//
// SermonModel
//
class WorshipModel : NSObject {
    
    @IBOutlet var worshipAPIClient: WorshipAPIClient!
    
    // worship data (YoutubeData, worshipData)
    var worshipDatas: [SideMenuType.WorshipSub : WorshipYoutubeData] = [:]
    
    
    
    // MARK: - public
    func loadWorshipFromYoutube(_ type: SideMenuType.WorshipSub, completion: @escaping ()->Void) {
        
        // request to youtube
        guard let playListId = YTPlayList(rawValue: type.desc)?.ids.playListId else {
            completion()
            return
        }
        // next page
        let nextPage = self.worshipDatas[type]?.nextPage ?? ""
        worshipAPIClient.loadYoutubeData(playListId, nextPageToken: nextPage, imgQuality: "default", complete: { (total, nextPage, datas) in
            // update
            let worship = self.worshipDatas[type] ?? WorshipYoutubeData()
            worship.total = total
            worship.nextPage = nextPage
            worship.datas += datas
            self.worshipDatas[type] = worship
            
            completion()
        })
    }
    
    func worshipDataCount(by worshipType: SideMenuType.WorshipSub)-> Int {
        return worshipDatas[worshipType]?.datas.count ?? 0
    }
    
    func worshipDataTotalCount(by worshipType: SideMenuType.WorshipSub)-> Int {
        return worshipDatas[worshipType]?.total ?? 0
    }
    
    func worshipItem(by worshipType: SideMenuType.WorshipSub, idx: Int)-> YoutubeData? {
        return worshipDatas[worshipType]?.datas.getElementBy(idx)
    }
}
