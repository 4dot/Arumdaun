//
//  Dynamic.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/14/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation


class Dynamic<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
