//
//  SideMenuViewController.swift
//  Arumdaun
//
//  Created by Park, Chanick on 6/26/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation
import UIKit
import Alamofire



// side menu list
enum SideMenuType : Int {
    case HomeScreen, Sermon, Worship, QT, News
    case OpenPDF, OpenWeb, PrivacyPolicy
    case Count
    
    static var count: Int { return SideMenuType.Count.rawValue }
    var desc: String {
        switch self {
        case .HomeScreen: return "홈스크린"
        case .Sermon: return "설교 말씀"
        case .Worship: return "찬양 동영상"
        case .QT: return "매일성경 QT"
        case .News: return "교회소식"
        case .OpenPDF: return "(이번주 주보 보기(PDF)"
        case .OpenWeb: return "arumdaunchurch.org"
        case .PrivacyPolicy: return "Privacy Policy"
        default: return ""
        }
    }
    
    var headerColor: UIColor {
        switch self {
        case .HomeScreen: return .MenuBlue
        case .Sermon: return .MenuOrange
        case .Worship: return .MenuYellow
        case .QT: return .MenuPink
        case .News: return .MenuGray
        default: return .clear
        }
    }
    enum SermonSub : Int {
        case Weekend, WdnesdayVision, MissioSaturDei, MorningQT, Special
        
        static var count: Int { return SermonSub.Special.rawValue + 1 }
        var desc: String {
            switch self {
            case .Weekend: return YTPlayList.WeekendSermon.ids.title // "주일예배 설교"
            case .WdnesdayVision: return YTPlayList.WdnesdayVision.ids.title // "수요비젼 예배"
            case .MissioSaturDei: return YTPlayList.MissioSaturDei.ids.title // "토요 Misson Satur Dei"
            case .MorningQT: return "새벽기도 QT 말씀"
            case .Special: return YTPlayList.SpecialSermon.ids.title //"특별예배 설교"
            }
        }
    }
    
    enum WorshipSub : Int {
        case Sion, Kairos, Immanuel, Special
        
        static var count: Int { return WorshipSub.Special.rawValue + 1 }
        var desc: String {
            switch self {
            case .Sion: return YTPlayList.SionWorship.ids.title // "시온 찬양대"
            case .Kairos: return YTPlayList.KairosWorship.ids.title // "카이로스 찬양대"
            case .Immanuel: return YTPlayList.ImmanuelWorship.ids.title // "임마누엘 찬양대"
            case .Special: return YTPlayList.SpecialWorship.ids.title // "특별찬양"
            }
        }
    }
}



//
// SideMenuViewController class
//
class SideMenuViewController : UIViewController {
    
    @IBOutlet weak var menuTable: ExpandableTableView!
    @IBOutlet weak var gradientAreaView: UIView!
    @IBOutlet weak var versionLbl: UILabel!
    
    
    var wasOpen: Bool = false
    
    // sub menus
    var menus: [SideMenuType] = []
    
    let cellHeight: CGFloat = 50
    
    
    
    
    // MARK: - override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuTable.expandableDelegate = self
        menuTable.tableFooterView = UIView()
        
        // tap gesture
        // add touch gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGradientAreaTapped(_:)))
        gradientAreaView.addGestureRecognizer(tapGesture)
        
        // create menu
        for menu in 0..<SideMenuType.count {
            guard let menuType = SideMenuType(rawValue: menu) else { continue }
            menus.append(menuType)
        }
        
        versionLbl.text = "ver. \(Bundle.main.versionString)"
        // append extra cell, show PDF, open Web
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IBActions 
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        open(false)
    }
    
    // MARK: - public functions
    
    func open(_ isOpen: Bool) {
        if isOpen == true {
            showSideMenuView()
        } else {
            hideSideMenuView()
        }
    }
    
    func selectSideMenu(_ idx: Int, _ parentId: Int) {
        
        // open detail view
        guard let menuType = SideMenuType(rawValue: parentId) else { return }
        var destViewController : UIViewController
        
        // send track event
        ArAnalytics.sendTrackEvent("pv", properties: ["title" : menuType.desc])
        
        switch menuType {
        case .HomeScreen:
            // goto mainview
            let main = UIStoryboard.loadMainViewController()
            destViewController = main
            
        case .Sermon:
            // open SermonView controller
            let sermon = UIStoryboard.loadSermonController()
            sermon.selectedType = SideMenuType.SermonSub(rawValue: idx) ?? .Weekend
            destViewController = sermon
            
        case .Worship:
            // open worship controller
            let worship = UIStoryboard.loadWorshipViewController()
            worship.selectedType = SideMenuType.WorshipSub(rawValue: idx) ?? .Sion
            destViewController = worship
            
        case .News:
            // open newsView controller
            let news = UIStoryboard.loadNewsViewController()
            destViewController = news
        
        case .QT:
            // open web page
            UIApplication.shared.openURL(URL(string: SU_DAILY_QT_URL)!)
            open(false)
            return
            
        default:
            return
        }
        
        // cancel previous all request
        ArNetwork.cancelAllRequest()
        
        // change to dest view
        sideMenuController()?.setContentViewController(destViewController)
        
        // close sidemenu
        open(false)
    }
    
    // MARK: private 
    
    // MARK: TapGestureRecognizer
    @objc func handleGradientAreaTapped(_ sender: UITapGestureRecognizer) {
        // close
        open(false)
    }
}

// MARK: - UITableViewDelegate, ExpandableDelegate

extension SideMenuViewController : ExpandableDelegate {
    
    /**
     * @desc add sub menus for expand
     */
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        guard let menuType = SideMenuType(rawValue: indexPath.row) else { return [] }
        
        // create sub menus
        var subMenus: [UITableViewCell] = []
        switch menuType {
        case .Sermon:
            for sub in 0..<SideMenuType.SermonSub.count {
                let cell = expandableTableView.dequeueReusable(cellClass: SideMenuTableViewExpandedCell.self)
                cell.setData(SideMenuType.SermonSub(rawValue: sub)?.desc ?? "", parent: menuType.rawValue, id: sub)
                subMenus.append(cell)
            }
            return subMenus
            
        case .Worship:
            for sub in 0..<SideMenuType.WorshipSub.count {
                let cell = expandableTableView.dequeueReusable(cellClass: SideMenuTableViewExpandedCell.self)
                cell.setData(SideMenuType.WorshipSub(rawValue: sub)?.desc ?? "", parent: menuType.rawValue, id: sub)
                subMenus.append(cell)
            }
            return subMenus
            
        default: break
        }
        return nil
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        guard let menuType = SideMenuType(rawValue: indexPath.row) else { return [] }
        
        var subMenusHight: [CGFloat] = []
        switch menuType {
        case .Sermon:
            for _ in 0..<SideMenuType.SermonSub.count {
                subMenusHight.append(cellHeight)
            }
            return subMenusHight
            
        case .Worship:
            for _ in 0..<SideMenuType.WorshipSub.count {
                subMenusHight.append(cellHeight)
            }
            return subMenusHight
            
        default: break
        }
        return nil
        
    }
    
    func numberOfSections(in tableView: ExpandableTableView) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        let cell = expandableTableView.cellForRow(at: indexPath)
        
        if let normalCell = cell as? SideMenuTableViewCell {
            print("cell: \(normalCell.id)")
            selectSideMenu(normalCell.id, normalCell.id)
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
        // send notify
        if let cell = expandableTableView.cellForRow(at: indexPath) as? SideMenuTableViewExpandedCell {
            print("expanded cell: \(cell.id), \(cell.parent)")
            selectSideMenu(cell.id, cell.parent)
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCell: UITableViewCell, didSelectExpandedRowAt indexPath: IndexPath) {
        if let cell = expandedCell as? SideMenuTableViewExpandableCell {
            print("\(cell.menuNameLabel.text ?? "")")
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let menuType = SideMenuType(rawValue: indexPath.row) else { return UITableViewCell() }
        
        switch menuType {
        case .Sermon, .Worship:
            let cell = expandableTableView.dequeueReusable(cellClass: SideMenuTableViewExpandableCell.self)
            cell.menuNameLabel.text = menuType.desc
            cell.id = indexPath.row
            cell.headerColorView.backgroundColor = menuType.headerColor
            return cell
            
        case .OpenPDF, .OpenWeb, .PrivacyPolicy:
            let cell = expandableTableView.dequeueReusable(cellClass: SideMenuTableButtonCell.self)
            cell.delegate = self
            cell.actionButton.setTitle(menuType.desc, for: .normal)
            cell.actionType = menuType
            return cell
            
        default:
            let cell = expandableTableView.dequeueReusable(cellClass: SideMenuTableViewCell.self)
            cell.menuNameLabel.text = menuType.desc
            cell.id = indexPath.row
            cell.headerColorView.backgroundColor = menuType.headerColor
            return cell
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let menuType = SideMenuType(rawValue: indexPath.row) else { return 0 }
        
        switch menuType {
        case .OpenPDF, .OpenWeb, .PrivacyPolicy: return 40
        default: return cellHeight
        }
    }
}

extension SideMenuViewController : SideMenuTableButtonCellDelegate {
    func sendAction(action: SideMenuType) {
        
        // close sidemenu
        open(false)
        
        // send tracking event
        ArAnalytics.sendTrackEvent("pv", properties: ["title" : action.desc])
        
        switch action {
        case .OpenPDF:
            if MainViewController.thisWeekPdfUrl.isEmpty {
                return
            }
            let vc = UIStoryboard.loadPDFViewController()
            vc.modalPresentationStyle = .overFullScreen
            vc.webLink = MainViewController.thisWeekPdfUrl
            
            // get top view
            guard let topView = UIApplication.shared.keyWindow?.rootViewController else {
                return
            }
            topView.present(vc, animated: true, completion: nil)
            
        case .OpenWeb:
            // open safari
            UIApplication.shared.openURL(URL(string: AR_MAIN_PAGE)!)
            
        case .PrivacyPolicy:
            // open safari
            UIApplication.shared.openURL(URL(string: PRIVACY_POLICY_URL)!)
            
        default:
            break
        }
    }
}

