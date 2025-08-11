//
//  FestivalIdManager.swift
//  unifest-ios
//

import Foundation

final class FestivalIdManager {
    // UserDefaults Key
    private static let mapFestivalIdKey = "mapFestivalId"
    private static let stampFestivalIdKey = "stampFestivalId"
    private static let festivalMapDataIndexKey = "festivalMapDataIndex"
    
    
    /*
     지도탭에 축제 지도를 렌더링 할 때는
     - 서버에서 받아오는 데이터,
     - 로컬 데이터(unifest-iosViews/Map/FestivalMapData.swift(FestivalMapData 파일))의 데이터를 함께 사용합니다.
     
     서버에서는 축제 데이터 요청 API를 통해 어떤 축제를 지원하는지, 해당 축제의 FestivalId는 무엇인지 등의 데이터를 받아오고,
     로컬 파일인 FestivalMapData.swift 파일에서는 특정 축제의 지도 관련 상수(확대율, 지도 polygon 좌표 등)를 가져옵니다.
     
     아래의 defaultMapFestivalId는 서버 API 요청 시 넣을 FestivalId를 저장하는 static 변수,
     defaultFestivalMapDataIndex는 FestivalMapData.swift에 저장된 축제 배열의 index를 저장하는 static 변수입니다.
     */
    static let defaultMapFestivalId: Int = 15 // 지도탭의 기본 FestivalId
    static let defaultFestivalMapDataIndex = 4 // unifest-iosViews/Map/FestivalMapData(로컬 파일)
    static let defaultStampFestivalId: Int = 13 // 스탬프탭의 기본 FestivalId
    
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
