//
//  ExpandableCell.swift
//  ExpandableCell
//
//  Created by Seungyoun Yi on 2017. 8. 10..
//  Copyright © 2017년 SeungyounYi. All rights reserved.
//

import UIKit

open class ExpandableCell: UITableViewCell {
    open var arrowImageView: UIImageView!
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        
        initView()
    }
    
    func initView() {
        let width = self.contentView.frame.width
        let height = self.contentView.frame.height
        
        arrowImageView = UIImageView(frame: CGRect(x: width - 24, y: (height - 22)/2, width: 11, height: 22))
        arrowImageView.image = UIImage(named: "icon_arrow", in: Bundle(for: ExpandableCell.self), compatibleWith: nil)
        self.contentView.addSubview(arrowImageView)
        
    }
    
    func open() {
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi/2), 0.0, 0.0, 1.0)
        }
    }
    
    func close() {
        UIView.animate(withDuration: 0.3) {
            self.arrowImageView.layer.transform = CATransform3DMakeRotation(CGFloat(Double.pi/2), 0.0, 0.0, 0.0)
        }
    }
}
