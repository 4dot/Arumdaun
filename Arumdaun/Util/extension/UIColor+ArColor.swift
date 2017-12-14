//
//  UIColor+ArColor.swift
//  Arumdaun
//
//  Created by Park, Chanick on 8/22/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit

extension UIColor {
    static let random =  UIColor(red:CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
    
    static let QTGreen = UIColor(red: 99/255, green: 126/255, blue: 91/255, alpha: 1)
    static let QTBrown = UIColor(red: 116/255, green: 92/255, blue: 69/255, alpha: 1)
    
    // side menu
    static let MenuBlue = UIColor(red: 66/255, green: 79/255, blue: 94/255, alpha: 1)
    static let MenuOrange = UIColor(red: 102/255, green: 84/255, blue: 62/255, alpha: 1)
    static let MenuYellow = UIColor(red: 108/255, green: 108/255, blue: 73/255, alpha: 1)
    static let MenuPink = UIColor(red: 119/255, green: 69/255, blue: 140/255, alpha: 1)
    static let MenuGray = UIColor(red: 109/255, green: 115/255, blue: 121/255, alpha: 1)
}


