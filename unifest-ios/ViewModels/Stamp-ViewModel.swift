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
    @Published var stampCount: Int = 0 // 사용자가 받은 스탬프 개수
    @Published var stampRecords: [StampRecordResult]? = [] // 사용자의 스탬프 기록
    @Published var stampEnabledBooths: [StampEnabledBoothResult]? = [] // 스탬프 기능을 제공하는 부스 리스트
    @Published var stampEnabledBoothsCount: Int = 0 // 스탬프 기능을 제공하는 부스 개수
    @Published var qrScanToastMsg: Toast? = nil
    @Published var stampEnabledFestivals: [StampEnabledFestivalResult]? = [] // 스탬프 기능을 제공하는 대학 축제 리스트
    @Published var defaultImgUrl = "" // 스탬프 받기 전 스탬프판 이미지
    @Published var usedImgUrl = "" // 스탬프 받은 후 스탬프판 이미지
    
    private let networkManager: NetworkManager
    private let apiClient: APIClient
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.apiClient = APIClient()
    }
    
    // 사용자의 스탬프 데이터 가져오기
    func fetchStampRecord(deviceId: String, festivalId: Int) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.Stamp.fetchStampRecord(deviceId: deviceId, festivalId: festivalId))
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
                self.stampCount = stampRecords?.count ?? 0 // 배열 길이(스탬프 개수)
            }
        } catch {
            NetworkUtils.handleNetworkError("fetchStampRecord", error, networkManager)
        }
    }
    
    // 스탬프를 찍을 수 있는 부스 목록 가져오기
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
    
    // 스탬프를 지원하는 축제 목록 가져오기
    func fetchStampEnabledFestivals() async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.Stamp.fetchEnabledFestivals)
        let headers: HTTPHeaders = [.accept("application/json")]
        
        do {
            let response: StampEnabledFestivalResponse = try await apiClient.get(
                url: url,
                headers: headers,
                responseType: StampEnabledFestivalResponse.self
            )
            print("fetchStampEnabledFestivals request succeeded")
            print(response)
            
            if response.code == "200", let data = response.data {
                self.stampEnabledFestivals = data
            }
        } catch {
            NetworkUtils.handleNetworkError("FetchStampEnabledFestivals", error, networkManager)
        }
    }
    
    // 스탬프 추가하기
    func addStamp(boothId: Int, deviceId: String, festivalId: Int) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.Stamp.addStamp)
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        let parameters: [String: Any] = [
            "deviceId": deviceId,
            "boothId": boothId,
            "festivalId": festivalId
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
            } else {
                self.qrScanToastMsg = Toast(style: .success, message: "개발자에게 문의해주세요")
            }
        } catch let error as APIClientError {
            switch error {
            case .serverError(let code, _):
                switch code {
                case 9000: self.qrScanToastMsg = Toast(style: .error, message: "이미 스탬프를 받은 부스입니다")
                case 9001: self.qrScanToastMsg = Toast(style: .error, message: "더이상 스탬프를 추가할 수 없습니다")
                case 9002: self.qrScanToastMsg = Toast(style: .error, message: "스탬프를 받을 수 없는 부스입니다")
                case 9003: self.qrScanToastMsg = Toast(style: .error, message: "존재하지 않는 부스입니다")
                case 9004: self.qrScanToastMsg = Toast(style: .error, message: "존재하지 않는 축제입니다")
                case 9005: self.qrScanToastMsg = Toast(style: .error, message: "이미 스탬프 정보가 추가되어 있습니다")
                default: self.qrScanToastMsg = Toast(style: .warning, message: "개발자에게 문의해주세요")
                }
            case .networkError(_): self.qrScanToastMsg = Toast(style: .error, message: "네트워크 연결 실패")
            case .unknownError: self.qrScanToastMsg = Toast(style: .error, message: "개발자에게 문의해주세요")
            }
        } catch {
            // 여기 추가
            self.qrScanToastMsg = Toast(style: .error, message: "개발자에게 문의해주세요")
        }
        
        //            self.qrScanToastMsg = Toast(style: .error, message: "스탬프를 받을 수 없는 부스입니다.")
        //            print("스탬프 관련 오류 발생")
    }
}
