//
//  ArDefine.swift
//  Arumdaun
//
//  Created by chanick park on 6/23/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation

// web page links --------------------------------------------------------------
let AR_MAIN_PAGE = "https://www.arumdaunchurch.org/"

// News web page
let NEWS_WEB_PAGE = AR_MAIN_PAGE + "%EA%B3%B5%EB%8F%99%EC%B2%B4%EC%99%80%EA%B5%90%EC%9C%A1/%EA%B5%90%ED%9A%8C%EC%86%8C%EC%8B%9D/" //공동체와교육/교회소식

// church news url, xml feed
// ex. https://www.arumdaunchurch.org/category/church-news/feed/?paged=1
let AR_NEWSFEED_URL = AR_MAIN_PAGE + "category/church-news/feed/"

// Daily QT webppage, first page
let SU_DAILY_QT_URL = "http://www.su.or.kr/03bible/daily/qtView.do?qtType=QT1"

let PRIVACY_POLICY_URL = AR_MAIN_PAGE + "privacy-policy"


// Youtube API ----------------------------------------------------------------
// arumdaunweb: "AIzaSyCa7dAbw2Oai90RvbOSpjNrLbwELK78r6M"//
// arumdaunmobile: "AIzaSyDZr8crx9oB6TgLY8P6s9iHGhmz0pK1FeM"//
let YT_API_KEY = "AIzaSyDZr8crx9oB6TgLY8P6s9iHGhmz0pK1FeM"
let YT_PLAYLIST_ITEM = "https://www.googleapis.com/youtube/v3/playlistItems"

let YT_SEARCH = "https://www.googleapis.com/youtube/v3/search"
let YT_LIVEVIDEO_CHANNEL_ID = "UC_SMi4TOmGvZnVb2SLpbGyw" // test, "UCHd62-u_v4DvJ8TCFtpi4GA" (government)
let YT_LIVEVIDEO_ID = "uod4YBW9Cv0"
// ex. https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=UC_SMi4TOmGvZnVb2SLpbGyw&eventType=live&type=video&key=AIzaSyCa7dAbw2Oai90RvbOSpjNrLbwELK78r6M
// https://www.youtube.com/embed/live_stream?channel=UC_SMi4TOmGvZnVb2SLpbGyw&autohide=2&showsearch=0&showinfo=1&iv_load_policy=1&wmode=transparent&wmode=opaque&wmode=opaque

// google drive for morning sermons ------------------------------------------
let GOOGLE_DRIVE_FILE_URL = "https://www.googleapis.com/drive/v3/files"
let GOOGLE_DRIVE_API_KEY = "AIzaSyCsXg_HV2dxmHKE53onhPwVZh_A5r0ZVu0"
let GOOGLE_DRIVE_QT_FOLDER_ID = "0B8tfjhHvC9vdfkR2ZnF1eHRKY0JHV2tyYXY0SlhnQnk0dGZfLXN6X0E5bkNkUXRPbllhem8"
let GOOGLE_DRIVE_VIEW_URL = "https://drive.google.com/file/d/"
let GOOGLE_DRIVE_DOWNLOAD_URL = "https://drive.google.com/uc?export=download&id="
// ex. download url : https://drive.google.com/uc?export=download&id=0B8tfjhHvC9vdd3hHbTNWMHJ2M00

