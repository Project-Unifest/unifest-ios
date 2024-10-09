//
//  StampViewModel.swift
//  unifest-ios
//
//  Created by 임지성 on 10/7/24.
//

import Alamofire
import Foundation
import SwiftUI

class StampViewModel: ObservableObject {
    @Published var stampCount: Int = -1
    @Published var stampEnabledBooths: [StampEnabledBoothResult]? = []
    @Published var stampEnabledBoothsCount: Int = 0
    
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func stampCount(token: String) async {
        await withCheckedContinuation { continuation in
            let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/stamps?token=\(token)"
            
            let headers: HTTPHeaders = [
                .accept("application/json")
            ]
            
            AF.request(testUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: StampCountResponse.self) { response in
                    switch response.result {
                    case .success(let res):
                        print(res)
                        if res.code == "200", let data = res.data {
                            DispatchQueue.main.async {
                                self.stampCount = data
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.networkManager.isServerError = true
                        }
                        print("stampCount 서버 요청 실패")
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
    
    func getStampEnabledBooths(festivalId: Int) async {
        await withCheckedContinuation { continuation in
            let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/stamps/\(festivalId)"
            
            let headers: HTTPHeaders = [
                .accept("application/json")
            ]
            
            AF.request(testUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: StampEnabledBoothResponse.self) { response in
                    switch response.result {
                    case .success(let res):
                        print(res)
                        if res.code == "200", let data = res.data {
                            DispatchQueue.main.async {
                                self.stampEnabledBooths = data
                                self.stampEnabledBoothsCount = data.count
                            }
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.networkManager.isServerError = true
                        }
                        print("getStampEnabledBooths 서버 요청 실패")
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
