//
//  UICollectionView+ArCollectionView.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/20/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation


extension UICollectionView {
    func registerReusable<T: Reusable>(cellClass: T.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func dequeueReusable<T: Reusable>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Misconfigured cell type, \(cellClass)!")
        }
        
        return cell
    }
}
