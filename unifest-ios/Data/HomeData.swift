//
//  HomeData.swift
//  unifest-ios
//
//  Created by 김영현 on 7/30/25.
//

import Foundation

struct HomeModelResponse: Decodable {
    let code: String
    let message: String
    let data: HomeModelResult
}

struct HomeModelResult: Decodable {
    let homeCardList: [HomeCard]
    let homeTipList: [HomeTip]
}

struct HomeCard: Decodable, Hashable {
    let id: Int
    let thumbnailImgUrl: String
    let detailImgUrl: String
}

struct HomeTip: Decodable, Hashable {
    let id: Int
    let tipContent: String
}

final class HomeModel: ObservableObject {
    
    @Published var homeCardList: [HomeCard] = [] {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    @Published var homeTipList: [HomeTip] = [] {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    init() {
        loadHomeInfoData()
    }
    
    func loadHomeInfoData() {
        APIManager.fetchDataGET("/home/info", api: .home_info, apiType: .GET) { result in
            switch result {
            case .success(let data):
                print("Data received in View: \(data)")
                if let response = data as? HomeModelResponse {
                    let homeInfoData = response.data
                    DispatchQueue.main.async {
                        self.homeCardList = homeInfoData.homeCardList
                        self.homeTipList = homeInfoData.homeTipList
                    }
                }
            case .failure(let error):
                print("Error in View: \(error)")
            }
        }
    }
}
