//
//  StampModel.swift
//  unifest-ios
//
//  Created by 임지성 on 10/7/24.
//

import Foundation

struct StampRecordResponse: Codable {
    let code: String
    let message: String
    let data: [StampRecordResult]?
}

struct StampRecordResult: Codable {
    let stampRecordId: Int
    let boothId: Int
    let deviceId: String
}

struct StampEnabledBoothResponse: Codable {
    let code: String
    let message: String
    let data: [StampEnabledBoothResult]?
}

struct StampEnabledBoothResult: Codable {
    let id: Int
    let name: String
    let category: String
    let description: String?
    let thumbnail: String?
    let location: String?
    let latitude: Double
    let longitude: Double
    let enabled: Bool?
    let waitingEnabled: Bool
    let openTime: String?
    let closeTime: String?
    let stampEnabled: Bool
}

struct AddStampResponse: Codable {
    let code: String
    let message: String
    let data: Int?
}

struct StampEnabledFestivalResponse: Codable {
    let code: String
    let message: String
    let data: [StampEnabledFestivalResult]?
}

struct StampEnabledFestivalResult: Codable {
    let festivalId: Int
    let name: String
}
