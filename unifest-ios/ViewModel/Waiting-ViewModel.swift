//
//  WaitingRequestView-ViewModel.swift
//  unifest-ios
//
//  Created by 임지성 on 7/31/24.
//

import Alamofire
import Foundation

class WaitingViewModel: ObservableObject {
    @Published var waitingTeamCount: Int = -1 // WaitingRequestView와 WaitingComplete에서 웨이팅 팀 수를 보여주는 변수
    @Published var requestedWaitingInfo: AddWaitingResult = AddWaitingResult(boothId: -1, waitingId: -1, partySize: -1, tel: "01012345678", deviceId: "-1", createdAt: "2000.01.01", updatedAt: "2000.01.01", status: "STATUS")
    
    // headers와 encoding 설정 제대로 됐는지 확인해보기
    func addWaiting(boothId: Int, phoneNumber: String, deviceId: String, partySize: Int) {
        print("requestWaiting - requestedBoothId: \(boothId), phoneNumber: \(phoneNumber), deviceId: \(deviceId), partySize: \(partySize)")
        
        let url = APIManager.shared.serverType.rawValue + "/waiting"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
        ]
        
        let parameters: [String: Any] = [
            "boothId": boothId,
            "tel": phoneNumber,
            "deviceId": deviceId,
            "partySize": partySize
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: AddWaitingResponse.self) { response in
                print("Request URL of addWaiting: \(response.request?.url?.absoluteString ?? "")")
                
                switch response.result {
                case .success(let res):
                    print("addWaiting request succeeded")
                    print("Result:\n \(res)")
                    DispatchQueue.main.async {
                        if let data = res.data {
                            self.requestedWaitingInfo = data
                        }
                    }
                case .failure(let error):
                    print("addWaiting - 서버 요청 실패")
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
    
    func fetchWaitingTeamCount(boothId: Int) async {
        print("fetchWaitingTeamCount - requested boothId: \(boothId)")
        
        let url = APIManager.shared.serverType.rawValue + "/waiting/\(boothId)/count"
        
        AF.request(url, method: .get)
            .responseDecodable(of: WaitingOrderResponse.self) { response in
                print("Request URL of fetchWaitingTeamCount: \(response.request?.url?.absoluteString ?? "")")
                
                switch response.result {
                case .success(let res):
                    print("code: \(res.code), message: \(res.message), waitingTeamCount: \(String(describing: res.data))")
                    DispatchQueue.main.async {
                        if let waitingTeamCount = res.data {
                            self.waitingTeamCount = waitingTeamCount
                        }
                    }
                case .failure(let error):
                    print("fetchWaitingTeamCount - 서버 요청 실패")
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
