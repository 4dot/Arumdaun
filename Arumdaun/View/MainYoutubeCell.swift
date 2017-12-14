//
//  MainYoutubeCell.swift
//  Arumdaun
//
//  Created by Park, Chanick on 8/23/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit




protocol MainYoutubeCellDelegate : class {
    func selectYoutubeMovie()
}

//
//
//
class MainYoutubeCell : UITableViewCell, Reusable {
    class var reuseIdentifier: String {
        return "MainYoutubeCellID"
    }
    
    // bg view
    @IBOutlet weak var bgImgView: UIImageView!
    
    // youtube collecton view
    @IBOutlet weak var youtubeCollectionView: UICollectionView!
    
    
    weak var delegate: MainYoutubeCellDelegate?
    
    // MARK: - override
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // set bg
        guard let url = URL(string: LaunchScreenViewController.imgURL) else {
            return
        }
        if let bg = ArNetwork.imageCache.image(for: URLRequest(url: url), withIdentifier: LaunchScreenViewController.imgURL) {
            let ratio = self.bgImgView.frame.size.height / self.bgImgView.frame.size.width
            bgImgView.image = (bg.cropedToRatio(ratio: ratio) ?? bg)
        }
    }
}


extension MainYoutubeCell {
    
    func setCollectionViewDataSourceDelegate<delegate: UICollectionViewDelegate & UICollectionViewDelegateFlowLayout & UICollectionViewDataSource>(_ datasource: delegate, forRow row: Int) {
        
        youtubeCollectionView.delegate = datasource
        youtubeCollectionView.dataSource = datasource
        youtubeCollectionView.tag = row
        youtubeCollectionView.setContentOffset(youtubeCollectionView.contentOffset, animated: false) // Stops collection view if it is scrolling.
        youtubeCollectionView.reloadData()
    }
    
    var collectionViewOffset: CGFloat {
        set { youtubeCollectionView.contentOffset.x = newValue }
        get { return youtubeCollectionView.contentOffset.x }
    }
}
