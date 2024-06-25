//
//  UserDataManager.swift
//  unifest-ios2
//
//  Created by Hoeun Lee on 6/25/24.
//

import Foundation

final class UserDataManager: ObservableObject {
    static let shared = UserDataManager()
    static var likeBoothIDList: [Int] = []
    
    // static var festivalList: [FestivalData] = []
    
    func fetchData() {
        /* APIManager.fetchDataGET("", apiType: .GET) { result in
            switch result {
            case .success(let data):
                print("Data received in View: \(data)")
            case .failure(let error):
                print("Error in View: \(error)")
            }
        }*/
    }
}
