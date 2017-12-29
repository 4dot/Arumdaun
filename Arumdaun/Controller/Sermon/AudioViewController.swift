//
//  AudioViewController.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/12/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit
import WebKit

class AudioViewController : UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var audioId: String = ""
    var audioName: String = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // send track event
        ArAnalytics.sendTrackEvent("pv", properties: ["title" : "QT Play", "subTitle" : audioName])
        
        // find file path
        let path = Bundle.main.url(forResource: "SermonPlayer", withExtension: "html", subdirectory: "Assets")
        do {
            let content = try String(contentsOf: path!, encoding: .utf16)
            
            // replace title and link in th html text
            var html = content.replacingOccurrences(of: "{title}", with: audioName)
            html = html.replacingOccurrences(of: "{link}", with: "\(GOOGLE_DRIVE_DOWNLOAD_URL)\(audioId)")
            
            // loading
            webView.loadHTMLString(html, baseURL: path)
            
        } catch  {
            print("Error:file content can't be loaded")
            
            // simple player
            let html = "<!DOCTYPE html><html><body><div  style='width: \(webView.frame.size.width)px; height: \(webView.frame.size.height)px; position: relative;'><iframe src='https://drive.google.com/file/d/\(audioId)/preview' width='100%' height='100%' frameborder='0' scrolling='no' seamless=''></iframe><div style='width: 80px; height: 80px; position: absolute; opacity: 0; right: 0px; top: 0px;'></div></div></body></html>"
            
            webView.loadHTMLString(html, baseURL: path)
        }
    }
    
    // MARK: - IBActions
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
