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



let CHECK_LIVE_BROADCASTING_IDLE = 30    // sec

//
// MainViewController class
//
public class MainViewController : UITableViewController {
    
    // main model object
    @IBOutlet var mainModel : MainViewModel!
    
    // live broadcasting view
    var liveBroadcastingView: LiveBroadCastingViewController?
    var liveBroadcastringIsShown: Bool = false
    
    // show just one time launch view
    static var isShowLaunchedView: Bool = false
    
    // check live broadcasting timer
    var checkLiveBroadcasting: Timer?
    
    // for access from outside (sidemenu)
    static var thisWeekPdfUrl: String = ""
    
    deinit {
        // stop update timer
        stopUpdateTimer()
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
        
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        // create sidemenu
        createMenuListButton()
        
        // start timer
        startCheckLiveTimer()
        
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
            UIView.animate(withDuration: 0.5, delay: 0.25, options: UIViewAnimationOptions.curveEaseIn, animations: {
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
    
    // MARK: - check live broadcasting is on
    
    private func startCheckLiveTimer() {
        // update every minute
        checkLiveBroadcasting = Timer.scheduledTimer(timeInterval: TimeInterval(CHECK_LIVE_BROADCASTING_IDLE), target: self, selector: #selector(updateLiveBroadCasting), userInfo: nil, repeats: true)
    }
    
    private func stopUpdateTimer() {
        checkLiveBroadcasting?.invalidate()
    }
    
    func updateLiveBroadCasting() {
        let now = Date()
        // show up/down, 1 (sunday)
        guard Calendar.current.component(.weekday, from: now) == 1 else {
            self.showLiveBroadCastingView(false)
            return
        }
        
        // broadcasting time : 8:30 ~ 12:30
        var startComponents = now.toComponent()
        startComponents.hour = 8
        startComponents.minute = 30
        
        var endComponents = now.toComponent()
        endComponents.hour = 12
        endComponents.minute = 30

        let startDate = Date.toDate(from: startComponents)
        let endDate = Date.toDate(from: endComponents)
        
        if now >= startDate && now < endDate {
            self.showLiveBroadCastingView(true)
        } else {
            self.showLiveBroadCastingView(false)
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

// MARK: - Live broad casting pup-up
extension MainViewController {
    
    func showLiveBroadCastingView(_ show: Bool) {
        let livePopupViewHeight: CGFloat = 50
        
        if liveBroadcastringIsShown == show {
            return
        }
        
        let showPos = CGRect(x: 0, y: self.view.frame.size.height - livePopupViewHeight, width: self.view.frame.size.width, height: livePopupViewHeight)
        let hidePos = CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: livePopupViewHeight)
        
        if show == true && liveBroadcastingView == nil {
            liveBroadcastingView = UIStoryboard.loadLiveBroadCastingViewController()
            liveBroadcastingView!.view.frame = showPos
            self.view.superview?.addSubview(liveBroadcastingView!.view)
        }
        
        guard let livePopup = liveBroadcastingView else { return }
        
        let startPos = show ? hidePos : showPos
        let endPos = show ? showPos : hidePos
        
        livePopup.view.frame = startPos
        UIView.animate(withDuration: 0.25, animations: {
            // show/hide
            livePopup.view.frame = endPos
            self.liveBroadcastringIsShown = show
        })
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

