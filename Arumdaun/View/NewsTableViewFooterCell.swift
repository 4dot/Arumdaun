//
//  NewsTableViewFooterCell.swift
//  Arumdaun
//
//  Created by Park, Chanick on 7/31/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import Lottie


enum NewsFooterCellType : String {
    case ShowPDF = "이번주 주보 보기(PDF)"
    case ReadMore = "READ MORE"
}

@objc protocol NewsTableViewFooterCellDelegate : NSObjectProtocol {
    @objc optional func showPDFView(_ url: String)
    @objc optional func requestMoreNews(_ idxPath: IndexPath)
}

//
// NewsTableViewCell
//
class NewsTableViewFooterCell : UITableViewCell, Reusable {
    class var reuseIdentifier: String {
        return "NewsTableViewFooterCellID"
    }
    
    @IBOutlet weak var footerButton: UIButton!
    
    var idxPath: IndexPath = IndexPath.init(row: 0, section: 0)
    var footerType: NewsFooterCellType = .ShowPDF
    
    var loadingAnimation: LOTAnimationView?
    
    weak var delegate: NewsTableViewFooterCellDelegate?
    
    
    // MARK: - override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        footerButton.isEnabled = true
        loadingAnimation?.isHidden = true
        
        // round corner
        footerButton.outline(0.5, bgColor: .white, radius: footerButton.frame.size.height/2, borderColor: .blue)
    }
    
    func setFooterData(_ idxPath: IndexPath, _ footerType: NewsFooterCellType, _ url: String = "") {
        self.footerType = footerType
        self.idxPath = idxPath
        
        if footerType == .ShowPDF {
            footerButton.isEnabled = (url.isEmpty) ? false : true
        }
        // button title
        footerButton.setTitle(footerType.rawValue, for: .normal)
    }
    
    func setFooterButtonState(_ isLoading: Bool) {
        footerButton.isEnabled = !isLoading
        
        if isLoading {
            if loadingAnimation == nil {
                loadingAnimation = ArUtils.getLottieAnimation(footerButton, name: LottieAnimationType.loadingBlack.desc)
                footerButton.addSubview(loadingAnimation!)
            }
            loadingAnimation?.play()
        } else {
            loadingAnimation?.pause()
        }
        
        loadingAnimation?.isHidden = !isLoading
    }
    
    // MARK: - IBActions
    @IBAction func footerButtonPressed(_ sender: Any) {
        if footerType == .ShowPDF {
            // show news pdf file
            delegate?.showPDFView?(MainViewController.thisWeekPdfUrl)
        } else if footerType == .ReadMore {
            delegate?.requestMoreNews?(idxPath)
        }
    }
}
