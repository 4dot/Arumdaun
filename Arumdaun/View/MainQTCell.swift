//
//  MainQTCell.swift
//  Arumdaun
//
//  Created by Park, Chanick on 8/28/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit



protocol MainQTCellDelegate : class {
    func openQT(contentType: MainViewContentType, audioId: String, audioName: String)
}

//
// MainQTCell
//
class MainQTCell : UITableViewCell, Reusable {
    class var reuseIdentifier: String {
        return "MainQTCellID"
    }
    
    // qt
    @IBOutlet weak var baseImageView: UIImageView!
    @IBOutlet weak var baseQTView: UIView!
    @IBOutlet weak var qtTitleLabel: UILabel!
    @IBOutlet weak var qtDetailLabel: UILabel!
    @IBOutlet weak var qtPlayNowButton: UIButton!
    
    var qtPreviewValue: String = ""
    var qtPreviewName: String = ""
    var contentType: MainViewContentType = .MorningQT
    
    weak var delegate: MainQTCellDelegate?
    
    // image names
    static let MorningQTImg = "morning_qt"
    static let DailyQTImg = "daily_qt"
    
    // MARK: - override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // button outline
        qtPlayNowButton.outline(1, bgColor: .clear, radius: qtPlayNowButton.frame.size.height/2, borderColor: .white)
        
        setQTData(contentType, "", "", "")
    }
    
    // MARK: - public function
    
    func setQTData(_ type: MainViewContentType, _ title: String = "", _ subTitle: String = "", _ value: String = "") {
        baseQTView.backgroundColor = (type == .MorningQT) ? .QTGreen : .QTBrown
        let baseImg = UIImage(named: (type == .MorningQT) ? MainQTCell.MorningQTImg : MainQTCell.DailyQTImg)
        baseImageView.image = baseImg
        
        qtTitleLabel.text = title
        qtDetailLabel.text = subTitle
        
        qtPreviewValue = value
        qtPreviewName = title
        contentType = type
    }
    
    // MARK: - IBActions
    
    @IBAction func playQTTapped(_ sender: Any) {
        delegate?.openQT(contentType: self.contentType, audioId: self.qtPreviewValue, audioName: qtPreviewName)
    }
}
