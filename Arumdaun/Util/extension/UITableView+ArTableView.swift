//
//  UITableView+ArTableView.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/20/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit

// Shared protocol to represent reusable items, e.g. table or collection view cells
protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

extension UITableView {
    // Allowing UITableView class registration with Reusable
    func registerReusable<T: Reusable>(cellClass: T.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    // Safely dequeue a `Reusable` item
    func dequeueReusable<T: Reusable>(cellClass: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier) as? T else {
            fatalError("Misconfigured cell type, \(cellClass)!")
        }
        
        return cell
    }
    
    // Safely dequeue a `Reusable` item for a given index path
    func dequeueReusable<T: Reusable>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: cellClass.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Misconfigured cell type, \(cellClass)!")
        }
        
        return cell
    }
}
