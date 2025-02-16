//
//  FCMTokenModel.swift
//  unifest-ios
//
//  Created by 임지성 on 2/16/25.
//

import Foundation

struct RegisterFCMTokenResponse: Codable {
    let code: String
    let message: String
    let data: String?
}
