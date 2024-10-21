//
//  ThrottleManager.swift
//  unifest-ios
//
//  Created by 임지성 on 10/21/24.
//

// throttling이 필요한 특정 api 요청에 throttling을 적용함

import Foundation

class ThrottleManager {
    private var lastRequestTime: Date?
    private var throttleInterval: TimeInterval // 시간 간격을 초로 나타낼 때 사용되는 타입, Double
    
    init(throttleInterval: TimeInterval = 1.0) {
        self.throttleInterval = throttleInterval
    }
    
    func throttle(_ action: () async -> Void) async {
        let now = Date()
        if let lastTime = lastRequestTime, now.timeIntervalSince(lastTime) < throttleInterval {
            // print("\n\n호출 무시\n\n")
            return // throttleInterval초 이내에 호출 시 요청을 무시함
        }
        // print("\n\n호출 정상 처리\n\n")
        lastRequestTime = now
        await action()
    }
}
