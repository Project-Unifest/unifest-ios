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
    @Published var stampCount: Int = 0
    @Published var stampEnabledBooths: [StampEnabledBoothResult]? = []
    @Published var stampEnabledBoothsCount: Int = 0
    @Published var qrScanToastMsg: Toast? = nil
    
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
                        } else {
                            DispatchQueue.main.async {
                                print("stampCount - request succeeded but unidentified response code")
                                self.networkManager.isServerError = true
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
                        } else {
                            DispatchQueue.main.async {
                                print("getStampEnabledBooths - request succeeded but unidentified response code")
                                self.networkManager.isServerError = true
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
    
    func addStamp(boothId: Int, token: String) async {
        await withCheckedContinuation { continuation in
            let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/stamps"
            
            let headers: HTTPHeaders = [
                .accept("application/json"),
                .contentType("application/json")
            ]
            
            let parameters: [String: Any] = [
                "token": token,
                "boothId": boothId
            ]
            
            AF.request(testUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: AddStampResponse.self) { response in
                    switch response.result {
                    case .success(let res):
                        print(res)
                        if res.code == "200" {
                            if let data = res.data {
                                self.stampCount = data
                            }
                            self.qrScanToastMsg = Toast(style: .success, message: "스탬프가 추가되었습니다")
                        } else if res.code == "9000" {
                            self.qrScanToastMsg = Toast(style: .error, message: "이미 스탬프를 받은 부스입니다")
                        } else if res.code == "9001" {
                            self.qrScanToastMsg = Toast(style: .error, message: "더이상 스탬프를 받을 수 없습니다")
                        } else if res.code == "9002" { // 스탬프 미지원 부스
                            self.qrScanToastMsg = Toast(style: .error, message: "스탬프를 받을 수 없는 부스입니다")
                        } else if res.code == "4000" { // 존재하지 않는 부스
                            self.qrScanToastMsg = Toast(style: .error, message: "올바르지 않은 QR코드입니다")
                        } else { // 기타 오류
                            self.qrScanToastMsg = Toast(style: .warning, message: "개발자에게 문의해주세요")
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.networkManager.isServerError = true
                        }
                        print("addStamp 서버 요청 실패")
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
