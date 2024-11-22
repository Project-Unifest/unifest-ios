//
//  StampViewModel.swift
//  unifest-ios
//
//  Created by 임지성 on 10/7/24.
//

import Alamofire
import Foundation
import SwiftUI

@MainActor
class StampViewModel: ObservableObject {
    @Published var stampCount: Int = 0
    @Published var stampEnabledBooths: [StampEnabledBoothResult]? = []
    @Published var stampEnabledBoothsCount: Int = 0
    @Published var qrScanToastMsg: Toast? = nil
    
    private let networkManager: NetworkManager
    private let apiClient: APIClient
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.apiClient = APIClient()
    }
    
    enum StampAPI {
        case count(String)
        case enabledBooths(Int)
        case add
        
        var path: String {
            switch self {
            case .count(let token):
                return "/stamps?token=\(token)"
            case .enabledBooths(let festivalId):
                return "/stamps/\(festivalId)"
            case .add:
                return "/stamps"
            }
        }
        
        var url: String {
            return APIManager.shared.serverType.rawValue + path
        }
    }
    
    private func buildURL(for endpoint: StampAPI) -> String {
        return endpoint.url
    }
    
    private func handleNetworkError(_ methodName: String, _ error: Error) {
        self.networkManager.isServerError = true
        print("\(methodName) network request failed with error:", error)
    }
    
    func fetchStampCount(token: String) async {
        let url = buildURL(for: .count(token))
        let headers: HTTPHeaders = [.accept("application/json")]
        
        do {
            let response: StampCountResponse = try await apiClient.get(
                url: url,
                headers: headers,
                responseType: StampCountResponse.self
            )
            print("FetchStampCount request succeeded")
            print(response)
            
            if response.code == "200", let data = response.data {
                self.stampCount = data
            }
        } catch {
            handleNetworkError("FetchStampCount", error)
        }
    }
    
    func fetchStampEnabledBooths(festivalId: Int) async {
        let url = buildURL(for: .enabledBooths(festivalId))
        let headers: HTTPHeaders = [.accept("application/json")]
        
        do {
            let response: StampEnabledBoothResponse = try await apiClient.get(
                url: url,
                headers: headers,
                responseType: StampEnabledBoothResponse.self
            )
            print("FetchStampEnabledBooths request succeeded")
            print(response)
            
            if response.code == "200", let data = response.data {
                self.stampEnabledBooths = data
                self.stampEnabledBoothsCount = data.count
            }
        } catch {
            handleNetworkError("FetchStampEnabledBooths", error)
        }
    }
    
    func addStamp(boothId: Int, token: String) async {
        let url = buildURL(for: .add)
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        let parameters: [String: Any] = [
            "token": token,
            "boothId": boothId
        ]
        
        do {
            let response: AddStampResponse = try await apiClient.post(
                url: url,
                headers: headers,
                parameters: parameters,
                responseType: AddStampResponse.self
            )
            print("AddStamp request succeeded")
            print(response)
            
            if response.code == "200", let data = response.data {
                self.stampCount = data
                self.qrScanToastMsg = Toast(style: .success, message: "스탬프가 추가되었습니다")
            } else if response.code == "9000" {
                self.qrScanToastMsg = Toast(style: .error, message: "이미 스탬프를 받은 부스입니다")
            } else if response.code == "9001" {
                self.qrScanToastMsg = Toast(style: .error, message: "더이상 스탬프를 받을 수 없습니다")
            } else if response.code == "9002" { // 스탬프 미지원 부스
                self.qrScanToastMsg = Toast(style: .error, message: "스탬프를 받을 수 없는 부스입니다")
            } else if response.code == "4000" { // 존재하지 않는 부스
                self.qrScanToastMsg = Toast(style: .error, message: "올바르지 않은 QR코드입니다")
            } else { // 기타 오류
                self.qrScanToastMsg = Toast(style: .warning, message: "개발자에게 문의해주세요")
            }
        } catch {
            handleNetworkError("AddStamp", error)
        }
    }
}
