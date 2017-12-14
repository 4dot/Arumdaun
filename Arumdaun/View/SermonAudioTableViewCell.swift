//
//  SermonAudioTableViewCell.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/11/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation


class SermonAudioTableViewCell : UITableViewCell, Reusable {
    class var reuseIdentifier: String {
        return "SermonAudioTableViewCellID"
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    var audioId: String = ""
    
    
    
    func setData(_ audioId: String, _ title: String, _ subTitle: String) {
        titleLabel.text = title.fileName()
        subTitleLabel.text = subTitle
        
        self.audioId = audioId
    }
}
