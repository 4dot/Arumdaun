//
//  SermonViewController.swift
//  Arumdaun
//
//  Created by Park, Chanick on 8/31/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import UIKit
import CCBottomRefreshControl


//
//
//
class SermonViewController : LottieHUDViewController {
    
    // model
    @IBOutlet var sermonModel : SermonModel!
    
    // tab bar view
    @IBOutlet weak var tabbarView: UIView!
    
    // tabbar controller
    @IBOutlet weak var tabbarController: SMTabbar!
    
    // content view
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var sermonCollectionView: UICollectionView!
    
    @IBOutlet weak var sermonAudioTableView: UITableView!
    
    var tabBarList: [(idx: Int, name: String)] = []
    
    // selected sermon type
    var selectedType: SideMenuType.SermonSub = .Weekend
    
    
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove empty cell line
        sermonAudioTableView.tableFooterView = UIView()
        
        // show/hide 
        showViews(selectedType)
        
        // add bottom refresh control into collection view
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMovieList), for: .valueChanged)
        refreshControl.triggerVerticalOffset = 100.0
        sermonCollectionView.bottomRefreshControl = refreshControl

        
        // create sidemenu
        createMenuListButton()
        
        // set top tabbar
        for idx in 0..<SideMenuType.SermonSub.count {
            tabBarList.append((idx, SideMenuType.SermonSub(rawValue: idx)?.desc ?? ""))
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        tabbarController.moveDuration = 0.25
        tabbarController.fontSize = 13.0
        tabbarController.isDynamicWidth = true
        tabbarController.padding = 30
        tabbarController.scrollBGColor = .groupTableViewBackground
        
        tabbarController.configureSMTabbar(titleList: tabBarList.map { $0.name }, selectedIdx: selectedType.rawValue) { (index) -> (Void) in
            guard let sermonType = SideMenuType.SermonSub(rawValue: index) else {
                return
            }
            
            print("selected tab: \(sermonType.desc)")
            
            // cancel prev request
            ArNetwork.cancelAllRequest()
            
            // change to selected sermon
            self.showViews(sermonType)
            
            // request
            if self.sermonModel.sermonDataCount(by: sermonType) == 0 {
                // load sermon data
                self.loadSermon(sermonType)
            } else {
                // just change to next tab
                self.updateView(sermonType)
            }
        }
    }
    
    /**
     * @desc refresh control for collection view
     */
    func refreshMovieList() {
        if sermonModel.sermonDataTotalCount(by: selectedType) <= sermonModel.sermonDataCount(by: selectedType) {
            sermonCollectionView.bottomRefreshControl?.endRefreshing()
            return
        }
        
        // start refresh animation
        sermonCollectionView.bottomRefreshControl?.beginRefreshing()
        loadSermon(self.selectedType)
    }
    
    // MARK: - private functions
    fileprivate func sermonType(with idx: Int)-> SideMenuType.SermonSub? {
        return SideMenuType.SermonSub(rawValue: idx)
    }
    
    fileprivate func loadSermon(_ selectedType: SideMenuType.SermonSub) {
        showHUDAnimation(true, .loadingWhite)
        
        sermonModel.loadSermon(selectedType, completion: {
            // update ui
            self.updateView(selectedType)
            self.showHUDAnimation(false)
        })
    }
    
    fileprivate func showViews(_ type: SideMenuType.SermonSub) {
        self.selectedType = type
        sermonCollectionView.isHidden = type == .MorningQT
        sermonAudioTableView.isHidden = type != .MorningQT
    }
    
    fileprivate func updateView(_ selectedType: SideMenuType.SermonSub) {
        DispatchQueue.main.async {
            if selectedType == .MorningQT {
                self.sermonAudioTableView.reloadData()
            } else {
                self.sermonCollectionView.reloadData()
            }
            
            // hide refresh
            self.sermonCollectionView.bottomRefreshControl?.endRefreshing()
        }
    }
}

extension SermonViewController : UICollectionViewDelegate {
    
}

extension SermonViewController : UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sermonModel.sermonDataCount(by: selectedType)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cellClass: MainYoutubeCollectionViewCell.self, for: indexPath)
        cell.delegate = self
        
        // request youtube preview
        
        guard let ytPreview = sermonModel.sermonItem(by: selectedType, idx: indexPath.row) else {
            return cell
        }
        
        // modify title, sub title
        // split by '-'
        // ex. 아름다운교회 2017/09/03 - 새 일꾼 디모데
        let names = ytPreview.title.components(separatedBy: "-")
        ytPreview.subTitle = names.first ?? ""
        ytPreview.title = (names.getElementBy(1) ?? ytPreview.title).trim
        
        cell.setPreviewData(ytPreview)
        
        cell.alpha = 0.5
        //cell.transform = CGAffineTransform(scaleX: 1.01, y: 1.01)
        
        // animations
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            cell.alpha = 1
            //cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }) { (finished) in
            cell.alpha = 1
            //cell.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        
        return cell
    }
}

extension SermonViewController : UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 40% - inset(20)
        let cellW = (collectionView.frame.size.width - 60) / 2
        let cellH = cellW * 1.3
        
        return CGSize(width: cellW, height: cellH)
    }
}

extension SermonViewController : YTPreviewCollectionViewCellDelegate {

    // MARK: - YTPreviewCollectionViewCellDelegate
    func showYoutubeDetail(_ youtubeData: YoutubeData) {
        // open full screen youtube player
        ArNavigationViewController.openYoutubeContentView(self, youtubeData: youtubeData)
    }
}


extension SermonViewController : UITableViewDelegate {
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        guard let audio = sermonModel.sermonAudioItem(indexPath.row) else {
            return
        }

        // open full screen web player
        ArNavigationViewController.openAudioContentView(self, audioId: audio.id, audioName: audio.subName + " " + audio.name)
    }
}

extension SermonViewController : UITableViewDataSource {
    // MARK: - UITableViewDataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        return sermonModel.sermonAudioCount()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sermonModel.sermonDataCount(by: .MorningQT)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(cellClass: SermonAudioTableViewCell.self, for: indexPath)
        let audio = sermonModel.sermonAudioItem(indexPath.row)
        cell.setData(audio?.id ?? "", audio?.fullName ?? "", "")
        cell.alpha = 0.5
        
        // animations
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            cell.alpha = 1
        }) { (finished) in
            cell.alpha = 1
        }
        return cell
    }
}
