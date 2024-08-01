//
//  WaitingRequestView-ViewModel.swift
//  unifest-ios
//
//  Created by 임지성 on 7/31/24.
//

import Alamofire
import Foundation

class WaitingViewModel: ObservableObject {
    var waitingTeamCount: Int = -1
    
    func requestWaiting(boothId: Int, phoeNum: String, deviceId: String, partySize: Int) {
        
    }
    
    func fetchWaitingTeamCount(boothId: Int) async {
        let url = APIManager.shared.serverType.rawValue + "/waiting/\(boothId)/count"
        
        AF.request(url, method: .get)
            .responseDecodable(of: WaitingOrderResponse.self) { response in
                print("Request URL of fetchPendingTeamCount(): \(response.request?.url?.absoluteString ?? "")")
                
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
