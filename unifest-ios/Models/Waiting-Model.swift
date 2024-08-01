//
//  WaitingRequestView-Model.swift
//  unifest-ios
//
//  Created by 임지성 on 7/31/24.
//

import Foundation

// 웨이팅 추가
struct AddWaitingResponse: Codable {
    let code: String
    let message: String
    let data: AddWaitingResult
}

struct AddWaitingResult: Codable {
    let boothId: Int
    let waitingId: Int
    let partySize: Int
    let tel: String
    let deviceId: String
    let createdAt: String
    let updatedAt: String
    let status: String
}

// 웨이팅 대기 순 확인
struct WaitingOrderResponse: Codable {
    let code: String
    let message: String
    let data: Int?
}

