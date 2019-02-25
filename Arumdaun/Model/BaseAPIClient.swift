//
//  BaseAPIClient.swift
//  Arumdaun
//
//  Created by chanick park on 9/6/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import SwiftyXMLParser
import Kanna




// type alise
typealias VoidCompletion = (()->Void?)


//
//
//
class BaseAPIClient : NSObject {
    
    /**
     * @desc load news data from rss feed
     */
    func loadNewsData(_ includeHeader: Bool = true, _ includeFooter: Bool = true, page: Int = 1, _ complete:@escaping (_ news: [NewsData], _ weeklyPdf: String)->Void) {
        
        // request
        ArNetwork.manager.request(ArNetwork.urlRequest("\(AR_NEWSFEED_URL)?paged=\(page)", .returnCacheDataElseLoad)).responseString { [weak self] response in
            if let result = response.result.value {
                do {
                    // parse xml
                    let xml = try XML.parse(result)
                    var newsData: [NewsData] = []
                    
                    for element in xml["rss", "channel", "item"] {
                        var date = element["pubDate"].text ?? ""
                        let title = element["title"].text ?? ""
                        let descHtml = element["content:encoded"].text ?? ""
                        var desc = descHtml.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                        // remove after 'The Post'
                        if let removeRange = desc.range(of: "The post") {
                            desc.removeSubrange(removeRange.lowerBound..<desc.endIndex)
                        }
                        
                        var timeInterval: TimeInterval = 0
                        if let dateType = date.toDate() {
                            date = dateType.toString()
                            timeInterval = dateType.timeIntervalSince1970
                        }
                        
                        newsData.append(NewsData(json: ["date" : date,
                                                        "timeInterval" : timeInterval,
                                                        "title" : title,
                                                        "desc" : desc,
                                                        "dataType" : NewsDataType.Content.rawValue]))
                    }
                    
                    if includeHeader {
                        // add header data
                        newsData.insert(NewsData(json: ["date" : newsData.first?.date ?? "",
                                                        "dataType" : NewsDataType.Header.rawValue]), at: 0)
                    }
                    
                    if includeFooter {
                        self?.loadNewsPDFFromWeb({ (pdfUrl) in
                            //add footer data
                            newsData.append(NewsData(json: ["extraData" : pdfUrl,
                                                            "dataType" : NewsDataType.Footer.rawValue]))
                            complete(newsData, pdfUrl)
                        })
                    } else {
                        complete(newsData, "")
                    }
                    
                } catch {
                    complete([], "")
                }
            }
        }
    }
    
    /**
     * @desc find pdf url from url
     * @param url web page
     */
    func loadNewsPDFFromWeb(_ complete:@escaping (_ pdf: String)->Void) {
        
        ArNetwork.loadWebPage(NEWS_WEB_PAGE) { (html) in
            // parse to html ducument
            if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                
                // find pdf link from html doc
                let pdfPath = AR_MAIN_PAGE + "wp-content/uploads/"
                if let component = doc.xpath("//a[contains(@href,'\(pdfPath)')]").first {
                    print(component["href"] ?? "")
                    complete(component["href"] ?? "")
                    return
                }
            }
            complete("")
        }
    }
    
    /**
     * @desc load morning sermon data from google folder with folder id
     * @param folderId
     * @return callback after received (datas)
     */
    func loadMorningSermonData(_ complete: @escaping (_ datas: [MorningQTData])->Void) {
        // request
        // ex. https://www.googleapis.com/drive/v3/files?q='0B8tfjhHvC9vdfkR2ZnF1eHRKY0JHV2tyYXY0SlhnQnk0dGZfLXN6X0E5bkNkUXRPbllhem8'+in+parents&key=AIzaSyCsXg_HV2dxmHKE53onhPwVZh_A5r0ZVu0
        let apiURL = "\(GOOGLE_DRIVE_FILE_URL)?q='\(GOOGLE_DRIVE_QT_FOLDER_ID)'+in+parents&key=\(GOOGLE_DRIVE_API_KEY)"
        ArNetwork.manager.request(ArNetwork.urlRequest(apiURL)).responseJSON(completionHandler: { (response) in
            print("\(response)")
            
            var morningQTs: [MorningQTData] = []
            
            if let json = response.result.value as? [String: Any] {
                
                // get items
                if let items = json["files"] as? [Any] {
                    for item in items {
                        if let validItem = item as? [String: Any] {
                            morningQTs.append(MorningQTData(json: validItem))
                        }
                    }
                }
            }
            
            // response
            complete(morningQTs)
        })
    }
    
    /**
     * @desc load daily QT data from website
     * @return callback after received (datas)
     */
    func loadDailyQTWebPage(_ complete: @escaping (_ webPageDoc: HTMLDocument?)->Void) {
        
        ArNetwork.loadWebPage(SU_DAILY_QT_URL) { (html) in
            // parse to html ducument
            if let doc = try? Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                complete(doc)
                return
            }
            complete(nil)
        }
    }
    
    /**
     * @desc load youtube data with play list id, global function
     * @param listId youtube play list id, count request count, nextPageToken page token string
     * @return callback after received (totalCount, nextpage token string, dataList)
     */
    func loadYoutubeData(_ listId: String, nextPageToken: String = "", count: Int = 26, imgQuality: String = "standard",
                         complete: @escaping (_ total: Int, _ nextPage: String, _ datas: [YoutubeData])->Void) {
        
        // request
        // ex. https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=UU_SMi4TOmGvZnVb2SLpbGyw&key=AIzaSyDuMo0lS-U8-w_IjLhrWnXFLdOIdS1qPJY
        var apiURL = "\(YT_PLAYLIST_ITEM)?part=snippet&maxResults=\(count)&playlistId=\(listId)&key=\(YT_API_KEY)"
        if !nextPageToken.isEmpty {
            apiURL += "&pageToken=" + nextPageToken
        }
        ArNetwork.manager.request(ArNetwork.urlRequest(apiURL)).responseJSON(completionHandler: { (response) in
            print("\(response)")
            
            var ytDataList: [YoutubeData] = []
            var totalCnt = 0
            var nextPageToken = ""
            
            if let json = response.result.value as? [String: Any] {
                
                // get next page token
                nextPageToken = json["nextPageToken"] as? String ?? ""
                
                // get items
                if let items = json["items"] as? [Any] {
                    for item in items {
                        if let validItem = item as? [String: Any] {
                            ytDataList.append(YoutubeData(json: validItem, imgQuality))
                        }
                    }
                }
                // page info
                if let pageInfo = json["pageInfo"] as? [String: Any] {
                    totalCnt = pageInfo["totalResults"] as? Int ?? 0
                }
            }
            
            // response
            complete(totalCnt, nextPageToken, ytDataList)
        })
    }
}
