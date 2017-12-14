//
//  MainViewModel.swift
//  Arumdaun
//
//  Created by chanick park on 9/6/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import UIKit

// Main ContentView cell Type
enum MainViewContentType : Int {
    case Youtube
    case MorningQT
    case DailyQT
    case News
}


//
// MainViewModel
//
class MainViewModel : BaseViewModel {
    @IBOutlet var mainApiClient : MainAPIClient!
    
    // youtube data, qt data, news data
    var contentsData: [MainViewContentType : Any] = [:]
    
    
    
    
    // MARK: - public
    
    func loadPlaceHolderContent(completion: (()->Void)?) {
        mainApiClient.loadPlaceHolderContent { (datas) in
            self.contentsData = datas
            completion?()
        }
    }
    
    func loadYoutubePreviewContent(_ listId: String, completion: @escaping (_ data: YoutubeData)->Void) {
        mainApiClient.loadYoutubePreviewData(listId) { (youtube) in
            // update
            var youtubes = self.youtubeDatas()
            for idx in 0..<youtubes.count {
                if youtubes[idx].playListId == youtube.playListId {
                    youtubes[idx] = youtube
                    break
                }
            }
            self.contentsData[.Youtube] = youtubes
            completion(youtube)
        }
    }
    
    func loadNewsContent(completion: @escaping (_ weekyPdf: String)->Void) {
        mainApiClient.loadNewsData { (news, weeklyPdf) in
            self.contentsData[.News] = news
            completion(weeklyPdf)
        }
    }
    
    /**
     * @desc return first one of list
     * @param folder id
     */
    func loadPreviewMorningQTData(completion: @escaping (_ data: MorningQTData)->Void) {
        // exist
        if let prevData = morningQTData(), prevData.name.isEmpty == false {
            completion(prevData)
            return
        }
        
        mainApiClient.loadMorningSermonData { (morningQTs) in
            // update
            let newQT = morningQTs.first ?? MorningQTData()
            self.contentsData[.MorningQT] = newQT
            completion(newQT)
        }
    }
    
    func loadPreviewDailyQTData(_ completion: @escaping (_ data: DailyQTData)->Void) {
        if let prevData = dailyQTData(), prevData.title.isEmpty == false {
            completion(prevData)
            return
        }
        
        mainApiClient.loadDailyQTWebPage { (htmlDoc) in
            
            guard let html = htmlDoc else {
                completion(DailyQTData())
                return
            }
            
            // find title, sub title
            guard let title = html.xpath("//*[@id=\"searchVO\"]/ul[1]/li[1]/p[1]").first?.content else {
                    completion(DailyQTData())
                    return
            }
            
            
            // ex. 2017-09-17 [예레미야(Jeremiah) 2:29 - 2:37]
            let subTitle = html.xpath("//*[@id=\"searchVO\"]/ul[1]/li[2]/p[1]").first?.content ?? ""
            
            // remove newlines
            let cleanSubTitle = subTitle.stringByRemovingWhitespaceAndNewlineCharacterSet
            
            // remove date area
            var newSubTitle = cleanSubTitle.components(separatedBy: "[").getElementBy(1)
            if newSubTitle != nil {
                newSubTitle = "[" + newSubTitle!
            }

            // update
            let newQT = DailyQTData(json: ["title" : title, "desc" : (newSubTitle ?? cleanSubTitle)])
            self.contentsData[.DailyQT] = newQT
            completion(newQT)
        }
    }
    
    func contentTypeCount() -> Int {
        return contentsData.count
    }
    
    func youtubeDatas() -> [YoutubeData] {
        return contentsData[.Youtube] as? [YoutubeData] ?? []
    }
    
    func newsDatas() -> [NewsData] {
        return contentsData[.News] as? [NewsData] ?? []
    }
    
    func morningQTData()-> MorningQTData? {
        return contentsData[.MorningQT] as? MorningQTData ?? nil
    }
    
    func dailyQTData()-> DailyQTData? {
        return contentsData[.DailyQT] as? DailyQTData ?? nil
    }
}
