//
//  ArNetwork.swift
//  Arumdaun
//
//  Created by Park, Chanick on 8/29/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage


//
// ArNetwork class
//
class ArNetwork {
    
    // alamofire cache policy
    static var urlCache: URLCache = {
        let capacity = 50 * 1024 * 1024 // MBs
        let urlCache = URLCache(memoryCapacity: capacity, diskCapacity: capacity, diskPath: nil)
        
        return urlCache
    }()
    
    static var manager: SessionManager = {
        let configuration: URLSessionConfiguration = {
            let configuration = URLSessionConfiguration.default
            configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
            configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
            configuration.urlCache = ArNetwork.urlCache
            
            return configuration
        }()
        
        let manager = SessionManager(configuration: configuration)
        return manager
    }()
    
    // image cache
    static let imageCache = AutoPurgingImageCache()
    
    /**
     * @desc cancel all current reuquest
     */
    static func cancelAllRequest() {
        // cancel previous all request
        ArNetwork.manager.session.getAllTasks { (tasks) in
            tasks.forEach { $0.cancel() }
        }
    }
    
    // create urlRequest
    class func urlRequest(_ url: String, _ cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringLocalCacheData) -> URLRequest {
        let parameters = ["Cache-Control": "private"]
        let url = URL(string: url)!
        
        var urlRequest = URLRequest(url: url, cachePolicy: cachePolicy)
        urlRequest.httpMethod = HTTPMethod.get.rawValue
        
        do {
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        } catch {
            return urlRequest
        }
    }
    
    /**
     * @desc load webpage
     * @param pageURL
     * @return complete with html string
     */
    static func loadWebPage(_ pageURL: String, complete: @escaping (String) -> Void) {
        guard let url = URL(string: pageURL) else {
            print("Error: \(pageURL) doesn't seem to be a valid URL")
            complete("")
            return
        }
        
        do {
            let htmlString = try String(contentsOf: url, encoding: .utf8)
            print("HTML : \(htmlString)")
            complete(htmlString)
        } catch let error {
            print("Error: \(error)")
            complete("")
        }
        
        // request
//        ArNetwork.manager.request(ArNetwork.urlRequest(pageURL)).responseString { response in
//            print("\(response.result.isSuccess)")
//
//            if let html = response.result.value {
//                complete(html)
//                return
//            }
//            complete("")
//        }
    }
}
