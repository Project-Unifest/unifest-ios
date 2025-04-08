//
//  NetworkUtils.swift
//  unifest-ios
//
//  Created by 임지성 on 11/23/24.
//

import Alamofire
import Foundation

// ViewModel에서 공통적으로 사용할 API URL 빌드 메서드 및 에러 핸들링 메서드
struct NetworkUtils {
    static func buildURL(for path: String) -> String {
        return APIManager.shared.serverType.rawValue + path
    }
    
    static func handleNetworkError(
        _ methodName: String,
        _ error: Error,
        _ networkManager: NetworkManager
    ) {
        networkManager.isServerError = true
        print("\(methodName) network request failed with error:", error)
    }
}

enum APIEndpoint { // case를 사용하면 추가 로직이 필요할 수 있으므로 let과 func로 enum 구성
    // Waiting 관련
    enum Waiting {
        static let cancel = "/waiting"
        static let add = "/waiting"
        static func fetchTeamCount(boothId: Int) -> String { return "/waiting/\(boothId)/count" }
        static func fetchReservedWaiting(deviceId: String) -> String { return "/waiting/me/\(deviceId)" }
        static let checkPin = "/waiting/pin/check"
    }
    
    // FavoriteFestival 관련
    enum FavoriteFestival {
        static let subscribe = "/megaphone/subscribe" // 사용X(2025/02/25~)
        static let getFavoriteFestivalList = "/festival/interest"
        static func addFavoriteFestival(festivalId: Int) -> String { return "/festival/\(festivalId)/interest"}
        static func deleteFavoriteFestival(festivalId: Int) -> String { return "/festival/\(festivalId)/interest"}
    }
    
    // Stamp 관련
    enum Stamp {
        static func fetchStampRecord(deviceId: String, festivalId: Int) -> String { return "/stamps?deviceId=\(deviceId)&festivalId=\(festivalId)"}
        static func fetchEnabledBooths(festivalId: Int) -> String { return "/stamps/\(festivalId)" }
        static let addStamp = "/stamps"
        static let fetchEnabledFestivals = "/stamps/festivals"
    }
    
    // fcm token 발급
    enum FCMToken {
        static let registerFCMToken = "/fcm-token"
    }
}
