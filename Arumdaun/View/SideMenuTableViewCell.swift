//
//  SideMenuTableViewCell.swift
//  Arumdaun
//
//  Created by chanick park on 6/27/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import UIKit







//
// SideMenuTableViewCell class
//
class SideMenuTableViewCell : UITableViewCell, Reusable {
    class var reuseIdentifier: String {
        return "SideMenuTableViewCellID"
    }
    
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var headerColorView: UIView!
    var id: Int = -1
}

//
// SideMenuTableViewExpandableCell class
//
class SideMenuTableViewExpandableCell : ExpandableCell, Reusable {
    class var reuseIdentifier: String {
        return "SideMenuTableViewExpandableCellID"
    }
    
    @IBOutlet weak var menuNameLabel: UILabel!
    @IBOutlet weak var headerColorView: UIView!
    var id: Int = -1
}

//
// SideMenuTableViewExpandedCell class
//
class SideMenuTableViewExpandedCell : UITableViewCell, Reusable {
    class var reuseIdentifier: String {
        return "SideMenuTableViewExpandedCellID"
    }
    
    @IBOutlet weak var menuNameLabel: UILabel!
    
    var id: Int = -1
    var parent: Int = -1
    
    func setData(_ name: String, parent: Int, id: Int) {
        self.menuNameLabel.text = name
        self.parent = parent
        self.id = id
    }
}

//
// SideMenuTableButtonCell class
//
protocol SideMenuTableButtonCellDelegate : NSObjectProtocol {
    func sendAction(action: SideMenuType)
}

class SideMenuTableButtonCell : UITableViewCell, Reusable {
    class var reuseIdentifier: String {
        return "SideMenuTableButtonCellID"
    }
    
    @IBOutlet weak var actionButton: UIButton!
    
    var actionType: SideMenuType = .OpenPDF
    weak var delegate: SideMenuTableButtonCellDelegate?
    
    // MARK: - override
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        actionButton.outline(1, bgColor: .clear, radius: actionButton.frame.size.height/2, borderColor: .white)
    }
    
    // MARK: - IBAction
    @IBAction func actionButtonTapped(_ sender: Any) {
        delegate?.sendAction(action: actionType)
    }
}
