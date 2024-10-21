//
//  DeviceUUIDManager.swift
//  unifest-ios
//
//  Created by 임지성 on 10/17/24.
//
//
//  This file is part of the unifest-ios project.
//
//  This project uses TAKUUID, an open-source library, to manage device UUIDs.
//  TAKUUID Library:
//  Copyright (c) 2013-2014 Katsumi Takahashi (https://github.com/taka0125/TAKUUID)
//
//  Licensed under the MIT License (MIT). You may use this library in accordance with the MIT License.
//  The full license is available at: https://opensource.org/licenses/MIT
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
