//
//  YTMenuCollectionViewCell.swift
//  Arumdaun
//
//  Created by Park, Chanick on 7/26/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage




protocol YTPreviewCollectionViewCellDelegate : NSObjectProtocol {
    func showYoutubeDetail(_ youtubeData: YoutubeData)
}

//
// MainYoutubeCollectionViewCell
//
class MainYoutubeCollectionViewCell : UICollectionViewCell, Reusable {
    class var reuseIdentifier: String {
        return "YTPreviewCollectionViewCellID"
    }
    
    @IBOutlet weak var imageBaseView: UIView!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var infoBaseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    
    // thumbnail image url
    var requestImage: DataRequest?
    
    // youtube data
    var youtubeData: YoutubeData?
    
    // delegate
    weak var delegate: YTPreviewCollectionViewCellDelegate?
    
    
    
    // MARK: override funcs.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // draw shadow
        self.dropShadow()
    }
    
    // MARK: - public functions
    
    /**
     * @desc request preview youtube movie
     * @param YoutubeData
     */
    func setPreviewData(_ youtubeData: YoutubeData) {
        titleLabel.text = youtubeData.title
        subTitleLabel.text = youtubeData.subTitle
        detailLabel.text = youtubeData.desc
        
        // save 
        self.youtubeData = youtubeData
        
        // drop shadow
        let shadow = UIView(frame: infoBaseView.frame)
        shadow.layer.shadowOffset = CGSize(width: 0, height: 5)
        shadow.layer.opacity = 0.5
        shadow.layer.shadowPath = UIBezierPath(rect: shadow.bounds).cgPath
        self.insertSubview(shadow, belowSubview: infoBaseView)

        
        // request image
        loadImage(youtubeData.thumbnailURL)
    }
    
    // MARK: - IBActions
    @IBAction func playMovieButtonTapped(_ sender: Any) {
        // open fullscreen player view
        guard let youtube = youtubeData else {
            print("no youtube data!")
            return
        }
        self.delegate?.showYoutubeDetail(youtube)
    }
    
    // MARK: private funcs
    private func loadImage(_ imgURL: String) {
        
        // cancel request if exist
        requestImage?.cancel()
        
        if imgURL.isEmpty { return }
        
        // default cache
        let urlRequest = URLRequest(url: URL(string: imgURL)!)
        
        // Fetch from Cache
        if let cachedImg = ArNetwork.imageCache.image(for: urlRequest, withIdentifier: imgURL) {
            self.thumbnailImageView.image = cachedImg
        } else {
            // default image
            thumbnailImageView.image = UIImage(named: "video_placeholder")
            
            requestImage = Alamofire.request(imgURL).responseData { (response) in
                if response.error == nil, let data = response.data {
                    
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            // crop for remove black area and rounded coner
                            let croppedImg = (image.cropedToScale(scaleTo: 0.73) ?? image).af_imageRounded(withCornerRadius: 2)
                            UIView.transition(with: self.thumbnailImageView, duration: 0.25, options: .curveEaseOut , animations: {
                                self.thumbnailImageView.image = croppedImg
                            }, completion: { (finished) in
                                // Add to cache
                                ArNetwork.imageCache.add(croppedImg, for: urlRequest, withIdentifier: imgURL)
                            })
                        }
                    }
                }
            }
        } // end else
    }
}
