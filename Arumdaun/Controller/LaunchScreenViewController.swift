//
//  LaunchScreenViewController.swift
//  Arumdaun
//
//  Created by Park, Chanick on 6/26/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import UIKit
//import Lottie
import Kanna
import Alamofire

//
// LaunchScreenViewController class
//
class LaunchScreenViewController : LottieHUDViewController {
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var mainTitleImageView: UIImageView!
    
    static var imgURL: String = ""
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        mainTitleImageView.alpha = 0
    }
    
    // MARK: - public functions
    
    func showSplashViewController(complete: @escaping ()->Void) {
        
        // create Launch
        self.navigationController?.isNavigationBarHidden = true
        
        // show after effect animation
//        let animationView = ArUtils.getLottieAnimation(self.view, "empty_status", CGSize(width: self.view.frame.size.width/2, height: self.view.frame.size.width/2))
//        self.view.addSubview(animationView)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//            animationView.pause()
//            complete()
//        }
        showHUDAnimation(true, .loadingWhite)
        
        loadBGImgFromWeb { (imgURL) in
            LaunchScreenViewController.imgURL = imgURL
            self.setBGImg(imgURL, completion: { (success) in
                self.showHUDAnimation(false)
                
                UIView.transition(with: self.mainTitleImageView, duration: 2, options: .curveEaseInOut, animations: {
                    self.mainTitleImageView.alpha = 1
                }) { (_) in
                    complete()
                }
            })
        }
    }
    
    // MARK: - private
    fileprivate func setBGImg(_ imgURL: String, completion: @escaping (_ success: Bool)->Void) {
        guard let url = URL(string: imgURL) else {
            completion(false)
            return
        }
        
        // default cache
        let urlRequest = URLRequest(url: url)
        let ratio = self.bgImgView.frame.size.height / self.bgImgView.frame.size.width
        
        if let cachedImg = ArNetwork.imageCache.image(for: urlRequest, withIdentifier: imgURL) {
            self.bgImgView.image = (cachedImg.cropedToRatio(ratio: ratio) ?? cachedImg)
            completion(true)
        } else {
            // default image
            //bgImgView.image = UIImage(named: "splash_bg")
            Alamofire.request(imgURL).responseData { (response) in
                guard let data = response.data,
                      let image = UIImage(data: data),
                          response.error == nil else {
                    completion(false)
                    return
                }
                // crop for remove black area, rounded image
                let croppedImg = (image.cropedToRatio(ratio: ratio) ?? image)
                // Add to cache(original image)
                ArNetwork.imageCache.add(image, for: urlRequest, withIdentifier: imgURL)
                // update ui
                DispatchQueue.main.async {
                    UIView.transition(with: self.bgImgView, duration: 0.5, options: .transitionCrossDissolve , animations: {
                        self.bgImgView.image = croppedImg
                    }, completion: nil)
                }
                completion(true)
            }
        }
    }
}

extension LaunchScreenViewController {
    // MARK: - network
    /**
     * @desc find sesonal image from main url
     */
    func loadBGImgFromWeb(_ complete: @escaping (_ sesonalImg: String)->Void) {
        ArNetwork.loadWebPage(AR_MAIN_PAGE) { (html) in
            // parse to html ducument
            if let doc = Kanna.HTML(html: html, encoding: String.Encoding.utf8) {
                
                // find first sesonal images link from html doc
                if let component = doc.xpath("//img[contains(@class, 'ls-bg')]").first {
                    print(component["src"] ?? "")
                    complete(component["src"] ?? "")
                    return
                }
            }
            complete("")
        }
    }
}
