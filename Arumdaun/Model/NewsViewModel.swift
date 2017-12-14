//
//  NewsViewModel.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/7/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation



class NewsViewModel : NSObject {
    @IBOutlet var newsAPIClient: NewsAPIClient!
    
    // news datas(date, data)
    var newsDatas: [[NewsData]] = []
    
    // current page, default 1
    var currentPage: Int = 1
    
    
    
    // MARK: - public
    
    func loadNews(_ page: Int, completion: (()->Void)?) {
        newsAPIClient.loadNewsData(false, false, page: page) { [weak self] (newsList, weeklyPdf) in
            self?.setNews(newsList, completion: { 
                // callback
                completion?()
            })
        }
    }
    
    func loadNextNews(completion: (()->Void)?) {
        newsAPIClient.loadNewsData(false, false, page: currentPage + 1) { [weak self] (newsList, weeklyPdf) in
            self?.setNews(newsList, completion: {
                // callback
                completion?()
            })
        }
    }
    
    func setNews(_ news: [NewsData], _ isReset: Bool = false, completion: (()->Void)?) {
        if isReset {
            self.newsDatas = [news]
            currentPage = 1
            return
        }
        
        // remove prev footer section from last section
        if  let footerSection = self.newsDatas.last,
            let footer = footerSection.first,
            footer.dataType == NewsDataType.Footer.rawValue {
            self.newsDatas.remove(at: self.newsDatas.count - 1)
        }
        
        var allDatas = self.newsDatas.flatMap { $0 }
        allDatas += news
        
        // group by date
        var grouped = allDatas.grouped { $0.date }
        grouped.sort{ ($0.first?.timeInterval ?? 0) > ($1.first?.timeInterval ?? 0) }   // desceding
        
        // add footer section
        grouped.append([NewsData(json: ["extraData" : " ", "dataType" : NewsDataType.Footer.rawValue])])
        self.newsDatas = grouped
        
        currentPage += 1
        
        // callback
        completion?()
    }
    
    func newsGroupCnt()-> Int {
        return newsDatas.count
    }
    
    func newsGroup(by section: Int)-> [NewsData] {
        return newsDatas.getElementBy(section) ?? []
    }
    
    func newsItem(by idxPath: IndexPath)-> NewsData? {
        return newsGroup(by: idxPath.section).getElementBy(idxPath.row)
    }
}
