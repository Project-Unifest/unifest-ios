//
//  GATracking.swift
//  petspace-ios
//
//  Created by Hoeun Lee on 11/15/23.
//

import Foundation
import FirebaseCore
import FirebaseAnalytics
import FirebaseAnalyticsSwift
import Firebase

// 2023. 11. 15. 23:20
struct GATracking {
    // 가입 단계 (Welcome)
    struct LogEventType {
        struct HomeView {
            static let HOME_EXPAND_CALENDAR = "HOME_EXPAND_CALENDAR" // 캘린더 확장
            static let HOME_SHRINK_CALENDAR = "HOME_SHRINK_CALENDAR" // 캘린더 축소
            static let HOME_CHANGE_DATE = "HOME_CHANGE_DATE" // 달력에서 날짜 넘김
            static let HOME_CHANGE_CALENDAR_PAGE = "HOME_CHANGE_CALENDAR_PAGE" // 달력 페이지 넘김
            static let HOME_CLICK_CELEB_PROFILE = "HOME_CLICK_CELEB_PROFILE" // 연예인 프로필 클릭
        }
        
        struct MapView {
            static let MAP_OPEN_FABOR_BOOTH = "MAP_OPEN_FABOR_BOOTH" // 인기 부스 열기
            static let MAP_CLOSE_FABOR_BOOTH = "MAP_CLOSE_FABOR_BOOTH" // 인기 부스 닫기
            static let MAP_CLICK_BOOTH_ANNOTATION = "MAP_CLICK_BOOTH_ANNOTATION" // 부스 클릭, 부스 id
            static let MAP_CLICK_BOOTH_CLUSTER = "MAP_CLICK_BOOTH_CLUSTER" // 클러스터 클릭
            static let MAP_CLICK_SEARCHED_BOOTH_ANNOTATION = "MAP_CLICK_SEARCHED_BOOTH_ANNOTATION"
            static let MAP_CLICK_TAG_BUTTON = "MAP_CLICK_TAG_BUTTON" // 태그 버튼 클릭, param 타입 on off
            static let MAP_CLICK_SEARCH_BOX = "MAP_CLICK_SEARCH_BOX" // 검색 버튼 클릭
            static let MAP_CLICK_BOOTH_ROW = "MAP_CLICK_BOOTH_ROW"
            static let MAP_CLICK_FABOR_BOOTH_ROW = "MAP_CLICK_FABOR_BOOTH_ROW"
        }
        
        struct WaitingView {
            // static let WAITING_CLICK_EXPROE_BUTTON = "WAITING_CLICK_MOVE_TO" // 구경하러 가기 버튼 클릭
        }
        
        struct MenuView {
            static let MENU_BOOTH_LIKE_CANCEL = "MENU_BOOTH_LIKE_CANCEL"
            static let MENU_CLICK_BOOTH_ROW = "MENU_CLICK_BOOTH_ROW"
            static let MENU_CLICK_KAKAO_CHANNEL = "MENU_CLICK_KAKAO_CHANNEL"
            static let MENU_CLICK_OPERATOR_SITE = "MENU_CLICK_OPERATOR_SITE"
            static let MENU_CLICK_INSTAGRAM = "MENU_CLICK_INSTAGRAM"
            static let MENU_TURN_ON_CLUSTERING = "MENU_TURN_ON_CLUSTERING"
            static let MENU_TURN_OFF_CLUSTERING = "MENU_TURN_OFF_CLUSTERING"
            static let MENU_OPEN_SETTING = "MENU_OPEN_SETTING"
            static let MENU_OPEN_PRIVACY = "MENU_OPEN_PRIVACY"
            static let MENU_MAIL_TO_DEV = "MENU_MAIL_TO_DEV"
        }
        
        struct BoothListView {
            static let BOOTHLIST_BOOTH_LIKE_CANCEL = "BOOTHLIST_BOOTH_LIKE_CANCEL"
            static let BOOTHLIST_CLICK_BOOTH_ROW = "BOOTHLIST_CLICK_BOOTH_ROW"
        }
        
        struct BoothDetailView {
            static let BOOTH_DETAIL_LIKE_ADD = "BOOTH_DETAIL_LIKE_ADD"
            static let BOOTH_DETAIL_LIKE_CANCEL = "BOOTH_DETAIL_LIKE_CANCEL"
        }
    }
    
    // 로그 전송
    static func sendLogEvent(_ eventName: String, params: [String : Any]?=nil) {
        // user ID 가져오기
        let userID = UIDevice.current.deviceToken
        
        // version 가져오기
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        
        Analytics.setUserID(userID)
        Analytics.setUserProperty(version, forName: "appVersion")
        Analytics.logEvent(eventName, parameters: params)
        
        if params == nil {
            print("** [GA] Log Event: \(eventName)")
        } else {
            print("** [GA] Log Event: \(eventName), with params: \(params!.description)")
        }
    }
    
    struct ScreenNames {
        static let homeView = "HomeView"
        
        static let mapView = "MapView"
        static let boothDetailView = "BoothDetailView"
        static let oneMapView = "OneMapView"
        
        static let waitingView = "WaitingView"
        
        static let menuView = "MenuView"
        static let likedBoothListView = "LikedBoothListView"
        
        static let networkErrorView = "NetworkErrorView"
    }
    
    static func eventScreenView(_ screenName: String) {
        print("** [GA] Screen Event: \(screenName)")
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: screenName,
                                       AnalyticsParameterScreenClass: screenName])
    }
}
