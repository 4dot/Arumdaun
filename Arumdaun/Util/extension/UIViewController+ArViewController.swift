//
//  UIViewController+ArViewController.swift
//  Arumdaun
//
//  Created by Park, Chanick on 11/30/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import Alamofire


protocol NetworkReachability : class {
    var reachabilityMgr: NetworkReachabilityManager? { get }
    func isNetworkReachable(_ isReachable: Bool)
}


extension UIViewController {
    // MARK: - check internet connection
    /**
     * @brief check network status
     */
    func startNetworkConnectionCheck(_ target: NetworkReachability) {
        target.reachabilityMgr?.listener = { status in
            print("Network Status Changed: \(status)")

            switch status {
            case .notReachable:
                target.isNetworkReachable(false)
            case .reachable(_), .unknown:
                target.isNetworkReachable(true)
            }
        }
        target.reachabilityMgr?.startListening()
    }
}
