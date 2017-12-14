//
//  UIButton+ArButton.swift
//  Arumdaun
//
//  Created by Park, Chanick on 7/13/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit

extension UIButton {
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        /*
        guard let fromImg = self.imageView?.image, let toImg = fromImg.imageWithColor(newColor: UIColor.yellow) else {
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.setImage(toImg, for: .normal)
        }, completion: nil)
        */
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
}
