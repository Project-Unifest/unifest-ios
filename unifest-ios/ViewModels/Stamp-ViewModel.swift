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
    let universities = ["건국대학교", "서울시립대학교", "한국교통대학교", ]
    @Published var selectedUniversity = "건국대학교"
    @Published var selectedUniversityIndex = 0
    @Published var stampCount: Int = 0
    @Published var stampRecords: [StampRecordResult]? = []
    @Published var stampEnabledBooths: [StampEnabledBoothResult]? = []
    @Published var stampEnabledBoothsCount: Int = 0
    @Published var qrScanToastMsg: Toast? = nil
    
    private let networkManager: NetworkManager
    private let apiClient: APIClient
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.apiClient = APIClient()
    }
    
    func fetchStampRecord(deviceId: String) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.Stamp.fetchStampCount(deviceId: deviceId))
        let headers: HTTPHeaders = [.accept("application/json")]
        
        do {
            let response: StampRecordResponse = try await apiClient.get(
                url: url,
                headers: headers,
                responseType: StampRecordResponse.self
            )
            print("fetchStampRecord request succeeded")
            print(response)
            
            if response.code == "200", let data = response.data {
                self.stampRecords = data
                self.stampCount = stampRecords?.count ?? 0
            }
        } catch {
            NetworkUtils.handleNetworkError("fetchStampRecord", error, networkManager)
        }
    }
    
    func fetchStampEnabledBooths(festivalId: Int) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.Stamp.fetchEnabledBooths(festivalId: festivalId))
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
            NetworkUtils.handleNetworkError("FetchStampEnabledBooths", error, networkManager)
        }
    }
    
    func addStamp(boothId: Int, deviceId: String) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.Stamp.addStamp)
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        let parameters: [String: Any] = [
            "deviceId": deviceId,
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
            } else if response.code == "9003" { // 존재하지 않는 부스
                self.qrScanToastMsg = Toast(style: .error, message: "올바르지 않은 QR코드입니다")
            } else { // 기타 오류
                self.qrScanToastMsg = Toast(style: .warning, message: "개발자에게 문의해주세요")
            }
        } catch {
            NetworkUtils.handleNetworkError("AddStamp", error, networkManager)
        }
    }
}
