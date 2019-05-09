//
//  WorshipViewController.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/11/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import UIKit


//
//
//
class WorshipViewController : LottieHUDViewController {
    
    // model
    @IBOutlet var worshipModel : WorshipModel!
    
    // tab bar view
    @IBOutlet weak var tabbarView: UIView!
    
    // tabbar controller
    @IBOutlet weak var tabbarController: SMTabbar!
    
    // content view
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet var worshipCollectionView: UICollectionView!
    
    
    var tabBarList: [(idx: Int, name: String)] = []
    
    // selected sermon type
    var selectedType: SideMenuType.WorshipSub = .Sion
    
    
    
    // MARK: - override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create sidemenu
        createMenuListButton()
        
        // load worship data
        loadWorship(selectedType)
        
        // add bottom refresh control into collection view
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshMovieList), for: .valueChanged)
        refreshControl.triggerVerticalOffset = 100.0
        worshipCollectionView.bottomRefreshControl = refreshControl
        
        // set top tabbar
        for idx in 0..<SideMenuType.WorshipSub.count {
            tabBarList.append((idx, SideMenuType.WorshipSub(rawValue: idx)?.desc ?? ""))
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        tabbarController.moveDuration = 0.25
        tabbarController.fontSize = 13.0
        tabbarController.isDynamicWidth = true
        tabbarController.padding = 30
        tabbarController.scrollBGColor = .groupTableViewBackground
        
        tabbarController.configureSMTabbar(titleList: tabBarList.map { $0.name }, selectedIdx: selectedType.rawValue) { (index) -> (Void) in
            guard let worshipType = SideMenuType.WorshipSub(rawValue: index) else {
                return
            }
            
            print("selected tab: \(worshipType.desc)")
            
            // cancel prev request
            ArNetwork.cancelAllRequest()
            
            // change to selected sermon
            self.selectedType = worshipType
            
            // request
            if self.worshipModel.worshipDataCount(by: worshipType) == 0 {
                self.loadWorship(worshipType)
            } else {
                // change to next tab, just update ui
                self.updateView(worshipType)
            }
        }
    }
    
    /**
     * @desc refresh control for collection view
     */
    @objc func refreshMovieList() {
        if worshipModel.worshipDataTotalCount(by: selectedType) <= worshipModel.worshipDataCount(by: selectedType) {
            worshipCollectionView.bottomRefreshControl?.endRefreshing()
            return
        }
        
        // start refresh animation
        worshipCollectionView.bottomRefreshControl?.beginRefreshing()
        loadWorship(self.selectedType)
    }
    
    // MARK: - private functions
    fileprivate func worshipType(with idx: Int)-> SideMenuType.WorshipSub? {
        return SideMenuType.WorshipSub(rawValue: idx)
    }
    
    fileprivate func loadWorship(_ selectedType: SideMenuType.WorshipSub) {
        showHUDAnimation(true, .loadingWhite)
        // load worship data
        worshipModel.loadWorshipFromYoutube(selectedType, completion: {
            // update ui
            self.updateView(selectedType)
            self.showHUDAnimation(false)
        })
    }
    
    fileprivate func updateView(_ selectedType: SideMenuType.WorshipSub) {
        DispatchQueue.main.async {
            self.worshipCollectionView.reloadData()
            
            // hide refresh
            self.worshipCollectionView.bottomRefreshControl?.endRefreshing()
        }
    }
}

extension WorshipViewController : UICollectionViewDelegate {
    
}

extension WorshipViewController : UICollectionViewDataSource {
    // MARK: - UICollectionViewDataSource
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return worshipModel.worshipDataCount(by: selectedType)
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusable(cellClass: MainYoutubeCollectionViewCell.self, for: indexPath)
        cell.delegate = self
        
        // request youtube preview
        
        guard let ytPreview = worshipModel.worshipItem(by: selectedType, idx: indexPath.row) else {
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
        
        // animations
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {
            cell.alpha = 1
        }) { (finished) in
            cell.alpha = 1
        }
        
        return cell
    }
}

extension WorshipViewController : UICollectionViewDelegateFlowLayout {
    // MARK: - UICollectionViewDelegateFlowLayout
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 40% - inset(20)
        let cellW = (collectionView.frame.size.width - 60) / 2
        let cellH = cellW * 1.3
        
        return CGSize(width: cellW, height: cellH)
    }
}

extension WorshipViewController : YTPreviewCollectionViewCellDelegate {
    
    // MARK: - YTPreviewCollectionViewCellDelegate
    func showYoutubeDetail(_ youtubeData: YoutubeData) {
        // open full screen youtube player
        ArNavigationViewController.openYoutubeContentView(self, youtubeData: youtubeData)
    }
}
