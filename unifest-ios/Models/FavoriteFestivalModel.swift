//
//  FavoriteFestivalModel.swift
//  unifest-ios
//
//  Created by 임지성 on 8/26/24.
//

import Foundation

struct AddFavoriteFestivalResponse: Codable {
    let code: Int
    let message: String
    let data: String?
}

struct DeleteFavoriteFestivalResponse: Codable {
    let code: Int
    let message: String
    let data: String?
}

