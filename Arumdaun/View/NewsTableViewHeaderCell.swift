//
//  NewsTableViewHeaderCell.swift
//  Arumdaun
//
//  Created by Park, Chanick on 7/31/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation


//
// NewsTableViewCell
//
class NewsTableViewHeaderCell : UITableViewCell, Reusable {
    class var reuseIdentifier: String {
        return "NewsTableViewHeaderCellID"
    }
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dateLabel.text = ""
    }
    
    // MARK: - public
    func setOutline(_ isOutline: Bool) {
        if isOutline {
            baseView.outline(0.5, bgColor: .white, radius: 0, borderColor: .lightGray)
        } else {
            baseView.outline(0, bgColor: .clear, radius: 0, borderColor: .clear)
        }
    }
}
