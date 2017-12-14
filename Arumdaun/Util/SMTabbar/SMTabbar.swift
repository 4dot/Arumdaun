//
//  SMTabbar.swift
//
//  Created by JaN on 2017/2/13.
//  Copyright © 2017年 Yu-Chun-Chen. All rights reserved.
//

import UIKit

class SMTabbar: UIScrollView {
    enum LinePosition  {
        case bottom
        case top
    }
    // MARK: Public Member Variables
    var padding : CGFloat = 20.0
    var extraConstant : CGFloat = 40.0 
    var buttonWidth : CGFloat = 52.0 {
        didSet {
            if buttonWidth < 1 {
                buttonWidth = oldValue
            }
        }
    }
    
    var lineHeight : CGFloat = 4.0 {
        didSet {
            if lineHeight < 1 {
                lineHeight = oldValue
            }
        }
    }
    
    var moveDuration : CGFloat = 0.3 {
        didSet {
            if moveDuration < 0.01 {
                moveDuration = oldValue
            }
        }
    }
    
    var fontSize : CGFloat = 13.0 {
        didSet {
            if fontSize < 8 {
                fontSize = oldValue
            }
        }
    }
    
    var linePosition : LinePosition = .bottom
    var fontColor : UIColor = .black
    var lineColor : UIColor = .orange
    var buttonBackgroundColor : UIColor = .white
    var scrollBGColor: UIColor = .white
    var isDynamicWidth: Bool = false
    let DEFAULT_FONT = UIFont(name: "NanumGothicBold", size: 13)
    
    // outline option
    var outlineColor: UIColor = UIColor.darkGray
    var outlineBorder: CGFloat = 1
    var outlineBGColor: UIColor = UIColor.white
    
    // MARK: Private Member Variables
    private var m_aryTitleList : [String] = []
    private var m_buttons: [UIButton] = []
    private var m_layerLine : CALayer = CALayer()
    private var m_completionHandler : ((_ index : Int)->(Void))?
    
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: Public Methods
    
    func configureSMTabbar(titleList : [String], selectedIdx: Int, completionHandler :@escaping ((_ index : Int)->(Void))){
        self.m_completionHandler = completionHandler
        self.m_aryTitleList = titleList
        self.initScrollView()
        self.addButtons()
        changeButotnStatus(selectedIdx)
    }
    
    // MARK: Private Methods
    private func initScrollView() {
        self.backgroundColor = scrollBGColor
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    private func setBtnOutline(_ btn: UIButton, _ isSelected: Bool = false, _ animation: Bool = true) {
        btn.layer.cornerRadius = btn.frame.size.height/2
        btn.layer.borderColor = outlineColor.cgColor
        btn.layer.borderWidth = outlineBorder
        
        UIView.transition(with: btn, duration: 0.25, options: .curveEaseInOut, animations: { 
            btn.backgroundColor = isSelected ? self.outlineColor : self.outlineBGColor
            btn.setTitleColor(isSelected ? self.outlineBGColor : self.outlineColor, for: .normal)
        }, completion: nil)
    }
    
    private func initLineLayer() {
        let y : CGFloat = self.linePosition == .bottom ? self.frame.height - self.lineHeight : 0
        self.m_layerLine.frame = CGRect(x: padding, y: y, width: self.buttonWidth, height: self.lineHeight)
        self.m_layerLine.backgroundColor = self.lineColor.cgColor
        self.m_layerLine.contentsScale = UIScreen.main.scale
        
        self.layer.addSublayer(self.m_layerLine)
    }
    
    private func estimatedString (_ text :String) -> CGRect {
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: self.frame.height - self.lineHeight)
        let nsstring = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: nsstring, attributes: [NSFontAttributeName : DEFAULT_FONT ?? UIFont.systemFont(ofSize: self.fontSize)], context: nil)
    }
    
    private func addButtons() {
        var x : CGFloat = self.padding / 2
        let y : CGFloat = 10

        let btnHeight = self.frame.height * 0.7
        
        for (index,title) in (self.m_aryTitleList.enumerated()) {
            
            if index > 0 {
                // create split bar
                let split: UIView = UIView(frame: CGRect(x: x, y: btnHeight/3, width: 1, height: btnHeight/3))
                split.backgroundColor = .groupTableViewBackground
                self.addSubview(split)
                x += 1
            }
            
            var btnWidth = isDynamicWidth ? estimatedString(title).size.width : self.buttonWidth
            btnWidth += padding
            
            // create button
            let btn : UIButton = UIButton(type: .custom)
            
            btn.titleLabel?.lineBreakMode = .byWordWrapping
            btn.titleLabel?.textAlignment = .center
            btn.titleLabel?.numberOfLines = 1
            btn.titleLabel?.minimumScaleFactor = 0.5
            btn.tag = index
            btn.titleLabel?.font = DEFAULT_FONT ?? UIFont.systemFont(ofSize: self.fontSize)
            btn.setTitle(title, for: .normal)
            btn.frame = CGRect(x: x, y: y, width: btnWidth, height: btnHeight)
            x += (btnWidth + self.padding / 2)
            btn.addTarget(self, action: #selector(SMTabbar.handleTap(_:)), for: .touchUpInside)
            self.setBtnOutline(btn, false, false)
            
            self.m_buttons.append(btn)
            self.addSubview(btn)
        }
        
        self.contentSize = CGSize(width: x, height: 1)
    }
    
    // MARK: Handle Action
    @objc fileprivate func handleTap(_ sender : UIButton) {
        let target_x = sender.frame.origin.x

        //self.m_layerLine.frame = CGRect(x: target_x, y: self.m_layerLine.frame.origin.y, width: sender.frame.size.width, height: self.lineHeight)
        
        if self.contentOffset.x + self.frame.width < target_x + sender.frame.size.width {
            let extraMove : CGFloat = sender.tag == self.m_aryTitleList.count - 1 ? 0 : self.extraConstant
            
            UIView.animate(withDuration: 0.3, animations: { 
                self.contentOffset.x = target_x + self.padding + sender.frame.size.width - self.frame.width + extraMove
            })
        } else if self.contentOffset.x > target_x {
            let extraMove : CGFloat = sender.tag == 0 ? 0 : self.extraConstant
            
            UIView.animate(withDuration: 0.3, animations: {
                self.contentOffset.x = target_x - self.padding - extraMove
            })
        }
        
        changeButotnStatus(sender.tag)
    }
    
    // MARK: Handle Action
    @objc fileprivate func changeButotnStatus(_ idx : Int) {
        // unselected all
        for btn in m_buttons {
            setBtnOutline(btn, false, true)
            if btn.tag == idx  {
                // reverse color
                setBtnOutline(btn, true, true)
            }
        }
        
        if self.m_completionHandler != nil {
            self.m_completionHandler!(idx)
        }
    }
}
