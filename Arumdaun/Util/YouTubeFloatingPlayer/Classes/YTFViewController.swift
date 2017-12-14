//
//  YTDViewController.swift
//  YTDraggablePlayer
//
//  Created by Ana Paula on 5/23/16.
//  Copyright © 2016 Ana Paula. All rights reserved.
//

import UIKit
import youtube_ios_player_helper

class YTFViewController: UIViewController {
    
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var fullscreen: UIButton!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var tableViewContainer: UIView!
    @IBOutlet weak var minimizeButton: YTFPopupCloseButton!
    @IBOutlet weak var playerControlsView: UIView!
    @IBOutlet weak var backPlayerControlsView: UIView!
    @IBOutlet weak var slider: CustomSlider!
    @IBOutlet weak var progress: CustomProgress!
    @IBOutlet weak var entireTimeLabel: UILabel!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var progressIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var videoView: YTPlayerView!
    
    var videoID: String?
    var customView: UIView?
    var delegate: UITableViewDelegate?
    var dataSource: UITableViewDataSource?
    var tableCellNibName: String?
    var tableCellReuseIdentifier: String?
    
    var isOpen: Bool = false
    var isPlaying: Bool = false
    var isFullscreen: Bool = false
    var sliderValueChanged: Bool = false
    var isMinimized: Bool = false
    
    var hideTimer: Timer?
    
    var playerControlsFrame: CGRect?
    var playerViewFrame: CGRect?
    var tableViewContainerFrame: CGRect?
    var playerViewMinimizedFrame: CGRect?
    var minimizedPlayerFrame: CGRect?
    var initialFirstViewFrame: CGRect?
    var viewMinimizedFrame: CGRect?
    var restrictOffset: Float?
    var restrictTrueOffset: Float?
    var restictYaxis: Float?
    var transparentView: UIView?
    var onView: UIView?
    var playerTapGesture: UITapGestureRecognizer?
    var panGestureDirection: UIPanGestureRecognizerDirection?
    var touchPositionStartY: CGFloat?
    var touchPositionStartX: CGFloat?
    
    var playImage: UIImage?
    var pauseImage: UIImage?
    var fullscreenImage: UIImage?
    var unfullscreenImage: UIImage?
    var minimizeImage: UIImage?
    
    var subviewForDetailsView: UIView?
    
    enum UIPanGestureRecognizerDirection {
        case Undefined
        case Up
        case Down
        case Left
        case Right
    }
    
    override func viewDidLoad() {
        
        initPlayerWithURLs()
        setupImageAssets()
        initViews()
        initDetailsView()
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        calculateFrames()
    }
    
    func initPlayerWithURLs() {
        
        if (isMinimized) {
            expandViews()
        }
        
        videoView.delegate = self
        
        if let videoID = videoID {
            videoView.isUserInteractionEnabled = false
            let playerVars = ["playsinline" : 1, "controls" : 0, "showinfo" : 0]
            videoView.load(withVideoId: videoID, playerVars: playerVars)
        }
    }
    
    func initViews() {
        
        self.view.backgroundColor = UIColor.clear
        self.view.alpha = 0.0
        playerControlsView.alpha = 0.0
        backPlayerControlsView.alpha = 0.0
        self.fullscreen.setImage(fullscreenImage, for: .normal)
        self.minimizeButton.setImage(minimizeImage, for: .normal)
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(YTFViewController.panAction(recognizer:)))
        playerView.addGestureRecognizer(gesture)
        self.playerTapGesture = UITapGestureRecognizer(target: self, action: #selector(YTFViewController.showPlayerControls))
        self.playerView.addGestureRecognizer(self.playerTapGesture!)
    }
    
    func initDetailsView() {
        
        if let view = subviewForDetailsView {
            view.removeFromSuperview()
        }
        
        if let _ = delegate, let _ = dataSource, let tableCellNibName = tableCellNibName, let tableCellReuseIdentifier = tableCellReuseIdentifier {
            
            let tableView = UITableView()
            tableView.delegate = delegate
            tableView.dataSource = dataSource
            
            tableView.register(UINib(nibName: tableCellNibName, bundle: Bundle.main), forCellReuseIdentifier: tableCellReuseIdentifier)
            
            tableView.frame.size = detailsView.frame.size
            subviewForDetailsView = tableView
        }
        
        if let customView = customView {
            customView.frame.size = detailsView.frame.size
            subviewForDetailsView = customView
        }
        
        if let subview = subviewForDetailsView {
            detailsView.addSubview(subview)
            detailsView.bringSubview(toFront: subview)
        }
    }
    
    func calculateFrames() {
        
        self.initialFirstViewFrame = self.view.frame
        self.playerViewFrame = self.playerView.frame
        self.tableViewContainerFrame = self.tableViewContainer.frame
        self.playerViewMinimizedFrame = self.playerView.frame
        self.viewMinimizedFrame = self.tableViewContainer.frame
        self.playerControlsFrame = self.playerControlsView.frame
        
        playerView.translatesAutoresizingMaskIntoConstraints = true
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = true
        playerControlsView.translatesAutoresizingMaskIntoConstraints = true
        backPlayerControlsView.translatesAutoresizingMaskIntoConstraints = true
        tableViewContainer.frame = self.initialFirstViewFrame!
        self.playerControlsView.frame = self.playerControlsFrame!
        
        transparentView = UIView.init(frame: initialFirstViewFrame!)
        transparentView?.backgroundColor = UIColor.black
        transparentView?.alpha = 0.0
        onView?.addSubview(transparentView!)
        
        self.restrictOffset = Float(self.initialFirstViewFrame!.size.width) - 200
        self.restrictTrueOffset = Float(self.initialFirstViewFrame!.size.height) - 180
        self.restictYaxis = Float(self.initialFirstViewFrame!.size.height - playerView.frame.size.height)
    }
    
    func setupImageAssets() {
        
        let bundle = Bundle(identifier: "org.cocoapods.YouTubeFloatingPlayer")
        if let pathForAssetBundle = bundle?.path(forResource: "YouTubeFloatingPlayer", ofType: "bundle") {
            if let assetBundle = Bundle(path: pathForAssetBundle) {
                playImage = UIImage(named: "play", in: assetBundle, compatibleWith: nil)
                pauseImage = UIImage(named: "pause", in: assetBundle, compatibleWith: nil)
                fullscreenImage = UIImage(named: "fullscreen", in: assetBundle, compatibleWith: nil)
                unfullscreenImage = UIImage(named: "unfullscreen", in: assetBundle, compatibleWith: nil)
                minimizeImage = UIImage(named: "NowPlayingCollapseChevronMask", in: assetBundle, compatibleWith: nil)
            }
        }
    }
    
    func cuePlayerVideo() {
        
        if let videoID = videoID {
            videoView.cueVideo(byId: videoID, startSeconds: 0, suggestedQuality: .auto)
        }
    }
    
    @IBAction func minimizeButtonTouched(sender: AnyObject) {
        
        minimizeViews()
    }
    
    func setupSlider(with duration: Double, currentTime: Float = 0.0) {
        
        slider.minimumValue = 0.0
        slider.maximumValue = Float(duration)
        slider.value = currentTime
    }
}

