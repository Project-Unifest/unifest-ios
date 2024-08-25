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
    let data: AddWaitingResult?
}

struct AddWaitingResult: Codable {
    let boothId: Int
    let waitingId: Int // 웨이팅 번호
    let partySize: Int
    let tel: String
    let deviceId: String
    let createdAt: String
    let updatedAt: String
    let status: String
    let waitingOrder: Int // 웨이팅 순서
    let boothName: String
    
    // 기본 초기화 메서드 추가
    static var empty: AddWaitingResult {
        return AddWaitingResult(
            boothId: -1,
            waitingId: -1,
            partySize: -1,
            tel: "Dummy num",
            deviceId: "",
            createdAt: "",
            updatedAt: "",
            status: "",
            waitingOrder: -1,
            boothName: "Dummy name"
        )
    }
}

// 예약된 대기열 조회
struct ReservedWaitingResponse: Codable {
    let code: String
    let message: String
    let data: [ReservedWaitingResult]?
}

struct ReservedWaitingResult: Codable {
    let boothId: Int
    let waitingId: Int
    let partySize: Int
    let tel: String
    let deviceId: String
    let createdAt: String
    let updatedAt: String
    let status: String
    let waitingOrder: Int
    let boothName: String
    
    static var empty: ReservedWaitingResult {
        return ReservedWaitingResult(
            boothId: -1,
            waitingId: -1,
            partySize: -1,
            tel: "Dummy num",
            deviceId: "",
            createdAt: "",
            updatedAt: "",
            status: "",
            waitingOrder: -1,
            boothName: "Dummy name"
        )
    }
}

// 대기 중인 팀의 수 조회
struct WaitingOrderResponse: Codable {
    let code: String
    let message: String
    let data: Int?
}

// 사용자의 웨이팅 취소
struct CancelWaitingResponse: Codable {
    let code: String
    let message: String
    let data: CancelWaitingResult?
}

struct CancelWaitingResult: Codable {
    let boothId: Int
    let waitingId: Int 
    let partySize: Int
    let tel: String
    let deviceId: String
    let createdAt: String
    let updatedAt: String
    let status: String
    let waitingOrder: Int?
    let boothName: String
}

// 핀 번호 확인
struct PinCheckResponse: Codable {
    let code: String
    let message: String
    let data: Int?
}
