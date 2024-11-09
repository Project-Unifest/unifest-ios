//
//  FavoriteFestivalViewModel.swift
//  unifest-ios
//
//  Created by 임지성 on 8/26/24.
//

import Alamofire
import Foundation

class FavoriteFestivalViewModel: ObservableObject {
    @Published var isAddFavoriteFestivalSucceeded: Bool = false
    @Published var isDeleteFavoriteFestivalSucceeded: Bool = false
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func addFavoriteFestival(festivalId: Int, fcmToken: String) async {
        await withCheckedContinuation { continuation in
            let url = APIManager.shared.serverType.rawValue + "/megaphone/subscribe"
            
            let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/megaphone/subscribe"
            let parameters: [String: Any] = [
                "festivalId": 2,
                "fcmToken": fcmToken
            ]
            let headers: HTTPHeaders = [
                .accept("application/json"),
                .contentType("application/json")
            ]
            print("addFavoriteFestival: \(parameters)")
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: AddFavoriteFestivalResponse.self) { response in
                    switch response.result {
                    case .success(let res):
                        DispatchQueue.main.async {
                            self.isAddFavoriteFestivalSucceeded = true
                        }
                        print("addFavoriteFestival 요청 성공")
                        print(res)
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.isAddFavoriteFestivalSucceeded = false
                            self.networkManager.isServerError = true
                        }
                        
                        print("addFavoriteFestival 서버 요청 실패")
                        print("에러: \(error.localizedDescription)")
                        
                        if let data = response.data {
                            let responseData = String(data: data, encoding: .utf8)
                            print("서버 응답 데이터: \(responseData ?? "데이터 없음")")
                        }
                        
                        if let httpResponse = response.response {
                            print("HTTP 상태 코드: \(httpResponse.statusCode)")
                        }
                    }
                    
                    continuation.resume()
                }
        }
    }
    
    func deleteFavoriteFestival(festivalId: Int, fcmToken: String) async {
        await withCheckedContinuation { continuation in
            let url = APIManager.shared.serverType.rawValue + "/megaphone/subscribe"
            
            let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/megaphone/subscribe"
            let parameters: [String: Any] = [
                "festivalId": 2,
                "fcmToken": fcmToken
            ]
            let headers: HTTPHeaders = [
                .accept("application/json"),
                .contentType("application/json")
            ]
            
            AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: DeleteFavoriteFestivalResponse.self) { response in
                    switch response.result {
                    case .success(let res):
                        DispatchQueue.main.async {
                            self.isDeleteFavoriteFestivalSucceeded = true
                        }
                        print("deleteFavoriteFestival 요청 성공")
                        print(res)
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.isDeleteFavoriteFestivalSucceeded = false
                            self.networkManager.isServerError = true
                        }
                        print("deleteFavoriteFestival 서버 요청 실패")
                        print("에러: \(error.localizedDescription)")
                        
                        if let data = response.data {
                            let responseData = String(data: data, encoding: .utf8)
                            print("서버 응답 데이터: \(responseData ?? "데이터 없음")")
                        }
                        
                        if let httpResponse = response.response {
                            print("HTTP 상태 코드: \(httpResponse.statusCode)")
                        }
                    }
                    
                    continuation.resume()
                }
        }
    }
}

