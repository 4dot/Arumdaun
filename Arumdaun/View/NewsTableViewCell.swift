//
//  NewsTableViewCell.swift
//  Arumdaun
//
//  Created by Park, Chanick on 7/31/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import Lottie


protocol NewsTableViewCellDelegate : class {
    func expandNewsCell(_ idxPath: IndexPath, _ isExpand: Bool)
}

//
// NewsTableViewCell
//
class NewsTableViewCell : UITableViewCell, Reusable {
    class var reuseIdentifier: String {
        return "NewsTableViewCellID"
    }
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    
    var currIdxPath = IndexPath(row: 0, section: 0)
    var loadingAnimation: LOTAnimationView?
    
    weak var delegate: NewsTableViewCellDelegate?
    
    // MARK: - override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.text = ""
        descLabel.text = ""
    }
    
    // MARK: - public function
    
    func setOutline(_ isOutLine: Bool) {
        // outline
        if isOutLine {
            baseView.outline(1, bgColor: .groupTableViewBackground, radius: 0, borderColor: .lightGray)
        } else {
            baseView.outline(0, bgColor: .groupTableViewBackground, radius: 0, borderColor: .clear)
        }
    }
    func showLoadingAnimation(_ isShow: Bool) {
        if isShow {
            if loadingAnimation == nil {
                loadingAnimation = ArUtils.getLottieAnimation(self.contentView, name: LottieAnimationType.loadingBlack.desc)
                self.addSubview(loadingAnimation!)
            }
            loadingAnimation?.play()
        } else {
            loadingAnimation?.pause()
            loadingAnimation?.isHidden = true
        }
        expandButton.isEnabled = !isShow
    }
    
    func setNews(_ idxPath: IndexPath, _ title: String, _ desc: String, isExpand: Bool = false) {
        showLoadingAnimation(false)
        
        currIdxPath = idxPath
        titleLabel.text = title
        expandButton.isSelected = isExpand
        
        // set line spacing in the uilabel
        let attrDesc = NSMutableAttributedString(string: desc)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        //style.minimumLineHeight = 10
        attrDesc.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: desc.utf16.count))
        descLabel.attributedText = attrDesc
        descLabel.numberOfLines = isExpand ? 0 : 1
    }
    
    func toggleExpandNews() {
        // toggle expand button
        let isSelected = !expandButton.isSelected
        expandButton.isSelected = isSelected
        
        // set line count
        descLabel.numberOfLines = isSelected == true ? 0 : 1
        
        // notifiy
        delegate?.expandNewsCell(currIdxPath, isSelected)
    }
    // MARK: - IBActions
    
    @IBAction func expandButtonTapped(_ sender: Any) {
        // toggle expand button
        toggleExpandNews()
    }
}
