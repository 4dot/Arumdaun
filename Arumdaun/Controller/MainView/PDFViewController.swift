//
//  PDFViewController.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/5/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import Lottie


protocol PDFViewControllerDelegate : NSObjectProtocol {
}

//
// PDFViewController class
//
class PDFViewController : UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var webLink: String = ""
    var loadingAnimation: LOTAnimationView?
    
    weak var delegate: PDFViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let url = URL(string: webLink.encodingQueryAllowed() ?? "") else {
            return
        }
        webView.loadRequest(URLRequest(url: url))
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        // close
        self.dismiss(animated: true, completion: nil)
    }
}

extension PDFViewController : UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        if loadingAnimation == nil {
            loadingAnimation = ArUtils.getLottieAnimation(webView, name: LottieAnimationType.loadingBlack.desc)
            webView.addSubview(loadingAnimation!)
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        loadingAnimation?.pause()
        loadingAnimation?.isHidden = true
    }
}
