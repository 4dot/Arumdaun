//
//  BaseViewModel.swift
//  Arumdaun
//
//  Created by Park, Chanick on 9/7/17.
//  Copyright © 2017 Chanick Park. All rights reserved.
//

import Foundation


enum QTContentType : Int{
    case MorningQT
    case DailyQT
}

// total : 11
enum YTPlayList : String {
    case WeekendSermon = "주일예배 설교"
    case SpecialWorship = "특별찬양"
    case SionWorship = "시온 찬양"
    case KairosWorship = "카이로스 찬양"
    case ImmanuelWorship = "임마누엘 찬양"
    case KoreanSchool = "한국학교"
    case MissionBomb = "전도폭발"
    case StudentTraning = "제자교육"
    case FridaySermon = "금요예배 설교"
    case WomansChorus = "여성합창"
    case MansChorus = "남성합창"
    
    var ids : (playListId: String, title: String) {
        get {
            var id: String = ""
            switch self {
            case .WeekendSermon: id = "PL9906CBD305FAD6DB"
            case .SpecialWorship: id = "PL99649D9F1BE8CA80"
            case .SionWorship: id = "PL3844EAE62711F3AB"
            case .KairosWorship: id = "PL125330946A5A0030"
            case .ImmanuelWorship: id = "PL3A3B6C11D6170A85"
            case .KoreanSchool: id = "PL12CF60E5C6175D21"
            case .MissionBomb: id = "PL7B9E36C40F5012E4"
            case .StudentTraning: id = "PLA38540E0E14F5155"
            case .FridaySermon: id = "PL9749E26E24038CE0"
            case .WomansChorus: id = "PLE006ADEC2ACE185F"
            case .MansChorus: id = "PL8BD24C4ADB10A595"
            }
            return (id, self.rawValue)
        }
    }
    
    static func getType(with playListId: String)-> YTPlayList? {
        for list in YTPlayList.YTPlayListAll {
            if list.ids.playListId == playListId {
                return list
            }
        }
        return nil
    }
    
    static let YTPlayListAll : [YTPlayList] =
        [.WeekendSermon, .SpecialWorship, .SionWorship, .KairosWorship, .ImmanuelWorship, .KoreanSchool, .MissionBomb, .StudentTraning, .FridaySermon, .WomansChorus, .MansChorus]
}

//
//
//
class BaseViewModel : NSObject {
    
}
