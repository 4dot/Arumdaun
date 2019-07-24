//
//  NewsViewController.swift
//  Arumdaun
//
//  Created by Park, Chanick on 8/31/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import UIKit
import Lottie

//
//
//
class NewsViewController : LottieHUDViewController {
    // model
    @IBOutlet var newsModel : NewsViewModel!
    
    // content table view
    @IBOutlet weak var contentTableView: UITableView!
    
    
    
    // MARK: - override
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentTableView.estimatedRowHeight = 100
        contentTableView.rowHeight = UITableView.automaticDimension
        contentTableView.tableFooterView = UIView()
        
        // create sidemenu
        createMenuListButton()
        
        // load first page
        showHUDAnimation(true, .loadingBlack)
        
        newsModel.loadNews(1) { 
            // update 
            DispatchQueue.main.async {
                self.contentTableView.reloadData()
                self.showHUDAnimation(false)
            }
        }
    }
}

extension NewsViewController : UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // header
        if section >= newsModel.newsGroupCnt() - 1 {
            return nil
        }
        
        let cell = tableView.dequeueReusable(cellClass: NewsTableViewHeaderCell.self)
        // get latest news date
        guard let firstNews = newsModel.newsGroup(by: section).first else {
                return cell.contentView
        }
        if firstNews.date.isEmpty == false {
            cell.dateLabel.text = "(" + firstNews.date + ")"
        }
        cell.setOutline(false)
        return cell.contentView
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // header
        if section >= newsModel.newsGroupCnt() - 1 {
            return 0
        }
        return 40
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // toggle expand
        // when pressed news cell
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell else {
                return
        }
        selectedCell.toggleExpandNews()
    }
}

extension NewsViewController : UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return newsModel.newsGroupCnt()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsModel.newsGroup(by: section).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let news = newsModel.newsItem(by: indexPath),
              let newsType = NewsDataType(rawValue: news.dataType) else {
            // default empty cell
                let cell = tableView.dequeueReusable(cellClass: NewsTableViewCell.self, for: indexPath)
            cell.showLoadingAnimation(true)
            cell.setOutline(false)
            return cell
        }
        
        switch newsType {
        case .Header:
            let cell = tableView.dequeueReusable(cellClass: NewsTableViewHeaderCell.self, for: indexPath)
            cell.dateLabel.text = news.date
            cell.setOutline(false)
            return cell
            
        case .Content:
            let cell = tableView.dequeueReusable(cellClass: NewsTableViewCell.self, for: indexPath)
            cell.delegate = self
            cell.showLoadingAnimation(false)
            cell.setOutline(false)
            cell.setNews(indexPath, news.title, news.desc, isExpand: news.isExpand)
            return cell
            
        case .Footer:
            let cell = tableView.dequeueReusable(cellClass: NewsTableViewFooterCell.self, for: indexPath)
            cell.delegate = self
            cell.setFooterData(indexPath, .ReadMore)
            return cell
        }
    }
}

extension NewsViewController : NewsTableViewCellDelegate {
    
    // MARK: - NewsTableViewCellDelegate
    func expandNewsCell(_ idxPath: IndexPath, _ isExpand: Bool) {
        // update data
        guard let news = newsModel.newsItem(by: idxPath) else {
                return
        }
        news.isExpand = isExpand
        
        // update table row
        contentTableView.reloadRows(at: [idxPath], with: .automatic)
    }
}

extension NewsViewController : NewsTableViewFooterCellDelegate {
    // MARK: - NewsTableViewFooterCellDelegate
    func requestMoreNews(_ idxPath: IndexPath) {
        // disable 'read more' button
        let readMore = contentTableView.cellForRow(at: idxPath) as? NewsTableViewFooterCell
        readMore?.setFooterButtonState(true)
        
        newsModel.loadNextNews { 
            // update
            DispatchQueue.main.async {
                self.contentTableView.reloadData()
                // enable 'read more' button
                readMore?.setFooterButtonState(false)
            }
        }
    }
}
