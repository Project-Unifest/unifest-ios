//
//  IntroView-ViewModel.swift
//  unifest-ios
//
//  Created by 임지성 on 8/26/24.
//

import Alamofire
import Foundation

class MegaphoneViewModel: ObservableObject {
    func addFavoriteFestival() async {
        let fcmToken = "" // 실제 fcmToken을 사용할 때는 코드에 노출되지 않도록 관리하기
        let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/megaphone/subscribe"
        let parameters: [String: Any] = [
            "festivalId": 2,
            "fcmToken": fcmToken
        ]
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        
        AF.request(testUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: AddFavoriteFestivalResponse.self) { response in
                switch response.result {
                case .success(let res):
                    print("addFavoriteFestival 요청 성공")
                    print(res)
                case .failure(let error):
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
            }
    }
    
    func deleteFavoriteFestival() async {
        let fcmToken = "" // 실제 fcmToken을 사용할 때는 코드에 노출되지 않도록 관리하기
        let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/megaphone/subscribe"
        let parameters: [String: Any] = [
            "festivalId": 2,
            "fcmToken": fcmToken
        ]
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        
        AF.request(testUrl, method: .delete, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: DeleteFavoriteFestivalResponse.self) { response in
                switch response.result {
                case .success(let res):
                    print("deleteFavoriteFestival 요청 성공")
                    print(res)
                case .failure(let error):
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
            }
    }
}

