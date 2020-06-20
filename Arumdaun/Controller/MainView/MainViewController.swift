//
//  MainViewController.swift
//  Arumdaun
//
//  Created by Park, Chanick on 6/26/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import UIKit
import Alamofire
import Lottie



//
// MainViewController class
//
public class MainViewController : UIViewController {
    
    // main model object
    @IBOutlet var mainModel : MainViewModel!
    
    @IBOutlet var tableView : UITableView!
    
    // live broadcasting view
    @IBOutlet weak var liveBroadCastingView: UIView!
    @IBOutlet weak var liveBroadCastingViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var liveBroadCastingViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var liveStreamingTitleLbl: UILabel!
    
    var liveStreamingModel = LiveStreamingViewModel()
    var liveBroadcastringIsShown: Bool = false
    var liveStreamingData: YoutubeData?
    
    // live broadcasting timer
    var checkLiveBroadcasting: Timer?
    
    
    // show just one time launch view
    static var isShowLaunchedView: Bool = false
    
    // for access from outside (sidemenu)
    static var thisWeekPdfUrl: String = ""
    
    
    
    deinit {
        // stop timer
        stopCheckLiveTimer()
    }
    
    var reachabilityMgr = NetworkReachabilityManager()
    var lottieAnimation: LOTAnimationView?
    
    
    // MARK: - override functions
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if MainViewController.isShowLaunchedView == false {
            // create launch screen
            showLaunchScreen()
        } else {
            createMainView()
        }
        
        // init UI
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        
        // create sidemenu
        createMenuListButton()
        
        // start timer after checking
        //updateLiveBroadCasting()
        //startCheckLiveTimer()
        
        // start network connection checking
        startNetworkConnectionCheck(self)
    }
    
    // MARK: - public functions
    
    func createMainView() {
        // title image 0.23 0.56
        let imgW = self.view.frame.size.width * 0.23
        let imgH = imgW * 0.4
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imgW, height: imgH))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "arumdaun_logo")
        imageView.image = image
        navigationItem.titleView = imageView
        
        mainModel.loadPlaceHolderContent { 
            self.tableView.reloadData()
        }
    }
    
    // MARK: - private
    
    private func showLaunchScreen() {
        let launch = UIStoryboard.loadLaunchScreenViewController()
        self.navigationController?.view.addSubview(launch.view)
        
        launch.showSplashViewController {
            UIView.animate(withDuration: 0.5, delay: 0.25, options: UIView.AnimationOptions.curveEaseIn, animations: {
                launch.view.alpha = 0
            }, completion: { finished in
                
                MainViewController.isShowLaunchedView = true
                
                // show main view
                self.createMainView()
                
                // delete
                launch.view.removeFromSuperview()
            })
        }
    }
}

// MARK: - YTPreviewCollectionViewCellDelegate 

extension MainViewController : YTPreviewCollectionViewCellDelegate {
    
    func showYoutubeDetail(_ youtubeData: YoutubeData) {
        // open full screen youtube player
        ArNavigationViewController.openYoutubeContentView(self, youtubeData: youtubeData)
    }
}

extension MainViewController : NetworkReachability {
    // MARK: - check network connection
    func isNetworkReachable(_ isReachable: Bool) {
        print("connection: \(isReachable)")
        //showHUDAnimation(!isReachable)
    }
    
    // MARK: - show lottie animation
    func showHUDAnimation(_ isShow: Bool, _ type: LottieAnimationType = .noInternetConnection, isLoop: Bool = true) {
        if isShow {
            if lottieAnimation == nil {
                lottieAnimation = ArUtils.getLottieAnimation(self.view, name: type.desc, size: CGSize(width: 100, height: 100), loop: isLoop)
                self.view.addSubview(lottieAnimation!)
            }
            lottieAnimation?.play()
        } else {
            lottieAnimation?.pause()
            lottieAnimation?.isHidden = true
        }
    }
}

