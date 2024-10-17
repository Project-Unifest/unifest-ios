//
//  DeviceUUIDManager.swift
//  unifest-ios
//
//  Created by 임지성 on 10/17/24.
//

import Foundation
import TAKUUID

class DeviceUUIDManager {
    static let shared = DeviceUUIDManager()
    
    private var deviceToken: String? // 디바이스의 UUID 저장
    
    private init() {
        self.deviceToken = TAKUUIDStorage.sharedInstance().findOrCreate()
    }
    
    // 앱 전체에서 deviceToken에 접근하는 메서드
    func getDeviceToken() -> String {
        // deviceToken이 nil일 경우에는 다시 uuid 생성하는 로직 추가
        return deviceToken ?? (TAKUUIDStorage.sharedInstance().findOrCreate() ?? "emptyDeviceToken")
    }
}
