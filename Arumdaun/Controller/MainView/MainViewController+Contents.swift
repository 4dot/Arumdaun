//
//  MainContentViewController+Contents.swift
//  Arumdaun
//
//  Created by Park, Chanick on 8/24/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import UIKit



//
//
//
extension MainViewController : UITableViewDelegate {
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cellType = MainViewContentType(rawValue: indexPath.section) else {
            return 0
        }
        
        switch cellType {
        case .Youtube:
            // same of width, 20 : for top space
            let cellW = tableView.frame.size.width * 3/4 + 20
            return CGFloat(cellW)
            
        case .MorningQT, .DailyQT:
            return tableView.frame.size.width * 0.38
            
        case .News:
            return UITableViewAutomaticDimension
        }
    }
    /**
     * @desc set collectionview data source delegate for nested collectionview cell in the tableview cell
     */
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellType = MainViewContentType(rawValue: indexPath.section) else {
            return
        }
        
        switch cellType {
        case .Youtube:
            // for nested collectionview in the tableview cell
            guard let tableViewCell = cell as? MainYoutubeCell else { return }
            tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.row)
            
        default:
            break
        }
    }
    
    /**
     * @desc set tableview's section space
     */
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let cellType = MainViewContentType(rawValue: section) else {
            return 10
        }
        return cellType == .Youtube ? 0.1 : 10
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.sectionHeaderHeight))
        footerView.backgroundColor = .white
        
        return footerView
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cellType = MainViewContentType(rawValue: section) else {
            return nil
        }
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: cellType == .Youtube ? 0 : 10))
        headerView.backgroundColor = .white
        
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // when pressed news cell
        guard let cellType = MainViewContentType(rawValue: indexPath.section),
                  cellType == .News,
              let selectedCell = tableView.cellForRow(at: indexPath) as? NewsTableViewCell else {
            return
        }
        selectedCell.toggleExpandNews()
    }
}

//
//
//
extension MainViewController : UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return mainModel.contentTypeCount()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cellType = MainViewContentType(rawValue: section) else {
            return 0
        }
        
        switch cellType {
        case .News: return mainModel.newsDatas().count
        default: return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellType = MainViewContentType(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch cellType {
        case .Youtube:
            let cell = tableView.dequeueReusable(cellClass: MainYoutubeCell.self, for: indexPath)
            return cell
            
        case .MorningQT:
            let cell = tableView.dequeueReusable(cellClass: MainQTCell.self, for: indexPath)
            cell.delegate = self
            cell.setQTData(.MorningQT)
            
            // request preview qt (top one)
            mainModel.loadPreviewMorningQTData(completion: { (data) in
                // update ui
                DispatchQueue.main.async {
                    cell.setQTData(.MorningQT, data.name, data.subName, data.id)
                }
            })
            return cell
            
        case .DailyQT:
            let cell = tableView.dequeueReusable(cellClass: MainQTCell.self, for: indexPath)
            cell.delegate = self
            cell.setQTData(.DailyQT)
            
            // request preview qt (top one)
            mainModel.loadPreviewDailyQTData({ (data) in
                // update ui
                DispatchQueue.main.async {
                    cell.setQTData(.DailyQT, data.title, data.desc, "")
                }
            })
            
            return cell
            
        // News Section
        case .News:
            guard let news = mainModel.newsDatas().getElementBy(indexPath.row),
                  let newsType = NewsDataType(rawValue: news.dataType) else {
                    // default empty cell
                    let cell = tableView.dequeueReusable(cellClass: NewsTableViewCell.self, for: indexPath)
                    cell.showLoadingAnimation(true)
                    cell.setOutline(true)
                    
                    // load preview news
                    mainModel.loadNewsContent(completion: { (weeklyPdf) in
                        DispatchQueue.main.async {
                            self.tableView.reloadSections([indexPath.section], with: .automatic)
                            MainViewController.thisWeekPdfUrl = weeklyPdf
                        }
                    })
                    return cell
            }
            
            switch newsType {
            case .Header:
                let cell = tableView.dequeueReusable(cellClass: NewsTableViewHeaderCell.self, for: indexPath)
                if news.date.isEmpty == false {
                    cell.dateLabel.text = "(" + news.date + ")"
                }
                cell.setOutline(true)
                return cell
                
            case .Content:
                let cell = tableView.dequeueReusable(cellClass: NewsTableViewCell.self, for: indexPath)
                cell.delegate = self
                cell.setOutline(true)
                cell.setNews(indexPath, news.title, news.desc, isExpand: news.isExpand)
                return cell
                
            case .Footer:
                let cell = tableView.dequeueReusable(cellClass: NewsTableViewFooterCell.self, for: indexPath)
                cell.delegate = self
                // set pdf url
                cell.setFooterData(indexPath, .ShowPDF, news.extraData)
                return cell
            }
        }
    }
}

extension MainViewController : NewsTableViewCellDelegate {
    
    func expandNewsCell(_ idxPath: IndexPath, _ isExpand: Bool) {
        // update data
        guard let news = mainModel.newsDatas().getElementBy(idxPath.row) else {
                return
        }
        news.isExpand = isExpand
        
        // update table row
        self.tableView.reloadRows(at: [idxPath], with: .automatic)
    }
}

extension MainViewController : NewsTableViewFooterCellDelegate {
    func showPDFView(_ url: String) {
        if url.isEmpty {
            return
        }
        let vc = UIStoryboard.loadPDFViewController()
        vc.modalPresentationStyle = .overFullScreen
        vc.webLink = url

        present(vc, animated: true, completion: nil)
    }
}

//
// for Youtube collection view data
//
extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainModel.youtubeDatas().count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cellClass: MainYoutubeCollectionViewCell.self, for: indexPath)
        cell.delegate = self
        
        // request youtube preview
        guard let ytPreview = mainModel.youtubeDatas().getElementBy(indexPath.row) else {
            return cell
        }
        
        // request preview
        mainModel.loadYoutubePreviewContent(ytPreview.playListId) { (data) in
            
            // modify title, sub title
            // split by '-'
            // ex. 아름다운교회 2017/09/03 - 새 일꾼 디모데
            data.subTitle = "이번주 " + (YTPlayList.getType(with: ytPreview.playListId)?.ids.title ?? "")
            data.title = data.title.components(separatedBy: "-").getElementBy(1) ?? data.title
            
            // upate UI
            DispatchQueue.main.async {
                cell.setPreviewData(data)
            }
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 80% - inset(20)
        let percent = collectionView.frame.size.width * 3/4
        let cellW = percent - 20
        let cellH = percent - 3 // shadow offset
        
        return CGSize(width: cellW, height: cellH)
    }
    
    // MARK: - UICollectionViewDelegate
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // send notification
        //delegate?.selectYoutubeMovie()
    }
}

extension MainViewController : MainQTCellDelegate {
    func openQT(contentType: MainViewContentType, audioId: String, audioName: String) {
        if contentType == .MorningQT {
            ArNavigationViewController.openAudioContentView(self, audioId: audioId, audioName: audioName)
        } else if contentType == .DailyQT {
            // open safari
            UIApplication.shared.openURL(URL(string: SU_DAILY_QT_URL)!)
        }
    }
}
