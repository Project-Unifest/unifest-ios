//
//  FestivalIdManager.swift
//  unifest-ios
//
//  Created by 임지성 on 4/28/25.
//

import Foundation

final class FestivalIdManager {
    // UserDefaults Key
    private static let mapFestivalIdKey = "mapFestivalId"
    private static let stampFestivalIdKey = "stampFestivalId"
    private static let festivalMapDataIndexKey = "festivalMapDataIndex"
    
    // 기본값
    static let defaultMapFestivalId: Int = 14 // festivalId 14: 상명대
    static let defaultStampFestivalId: Int = 13 // festivalId 13: 고려대
    static let defaultFestivalMapDataIndex = 3 // Map/FestivalMapData(로컬데이터)의 3번째 element: 상명대
    
    // 현재 선택된 축제 ID (지도)
    static var mapFestivalId: Int {
        get {
            UserDefaults.standard.object(forKey: mapFestivalIdKey) as? Int ?? defaultMapFestivalId
        }
        set {
            UserDefaults.standard.set(newValue, forKey: mapFestivalIdKey)
        }
    }
    
    // 현재 선택된 축제 ID (스탬프)
    static var stampFestivalId: Int {
        get {
            UserDefaults.standard.object(forKey: stampFestivalIdKey) as? Int ?? defaultStampFestivalId
        }
        set {
            UserDefaults.standard.set(newValue, forKey: stampFestivalIdKey)
        }
    }
    
    // festivalMapDataList의 인덱스 (지도화면용)
    static var festivalMapDataIndex: Int {
        get {
            UserDefaults.standard.object(forKey: festivalMapDataIndexKey) as? Int ?? defaultFestivalMapDataIndex
        }
        set {
            UserDefaults.standard.set(newValue, forKey: festivalMapDataIndexKey)
        }
    }
}
