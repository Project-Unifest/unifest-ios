//
//  WaitingRequestView-ViewModel.swift
//  unifest-ios
//
//  Created by 임지성 on 7/31/24.
//

import Alamofire
import Foundation

class WaitingViewModel: ObservableObject {
    // Waiting그룹 관련 변수
    @Published var reservedWaitingList: [ReservedWaitingResult]? = nil // [.empty]
    @Published var cancelWaiting = false // WaitingCancelView를 띄움
    @Published var waitingIdToCancel = -1 // 취소할 웨이팅의 WaitingId 저장
    @Published var waitingStatus = "" // WaitingCancelView에 어떤 문구를 띄울 지 결정
    @Published var waitingCancelToast: Toast? = nil
    
    // Detail그룹 관련 변수
    @Published var waitingTeamCount: Int = -1 // WaitingRequestView와 WaitingCompleteView에서 웨이팅 팀 수를 보여주는 변수
    @Published var requestedWaitingInfo: AddWaitingResult? = nil // .empty
    @Published var isPinNumberValid: Bool? = nil
    @Published var addWaitingResponseCode = "" // 웨이팅 신청 API의 응답코드
    @Published var addWaitingResponseMessage = "" // 웨이팅 신청 API의 응답 메세지
    @Published var reservedWaitingCount = 0 // 사용자가 예약한 웨이팅 개수
    @Published var reservedWaitingCountExceededToast: Toast? = nil // 해당 축제에서 지정한 웨이팅 최대 개수를 초과해서 웨이팅을 시도하려고 할 때 Toast를 띄움
    
    private let networkManager: NetworkManager
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    /// 사용자의 웨이팅 취소
    func cancelWaiting(waitingId: Int, deviceId: String) async {
        await withCheckedContinuation { continuation in
            let url = APIManager.shared.serverType.rawValue + "/waiting"
            
            let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/waiting"
            
            let headers: HTTPHeaders = [
                .accept("application/json"),
                .contentType("application/json")
            ]
            
            let parameters: [String: Any] = [
                "waitingId": waitingId,
                "deviceId": deviceId
            ]
            
            AF.request(testUrl, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: CancelWaitingResponse.self) { response in
                    print("Request URL of cancelWaiting: \(response.request?.url?.absoluteString ?? "")")
                    
                    switch response.result {
                    case .success(let res):
                        print("cancelWaiting 요청 성공")
                        print(res)
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.networkManager.isServerError = true
                        }
                        print("cancelWaiting 서버 요청 실패")
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
    
    /// 웨이팅 추가(WaitingRequestView에서 호출)
    func addWaiting(boothId: Int, phoneNumber: String, deviceId: String, partySize: Int, pinNumber: String) async {
        await withCheckedContinuation { continuation in
            print("requestWaiting - requestedBoothId: \(boothId), phoneNumber: \(phoneNumber), deviceId: \(deviceId), partySize: \(partySize), pinNumber: \(pinNumber)")
            
            let url = APIManager.shared.serverType.rawValue + "/waiting"
            
            let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/waiting"
            
            let headers: HTTPHeaders = [
                .accept("application/json"),
                .contentType("application/json")
            ]
            
            let parameters: [String: Any] = [
                "boothId": 79,
                "tel": phoneNumber,
                "deviceId": deviceId,
                "partySize": partySize,
                "pinNumber": pinNumber
            ]
            
            AF.request(testUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: AddWaitingResponse.self) { response in
                    print("Request URL of addWaiting: \(response.request?.url?.absoluteString ?? "")")
                    
                    switch response.result {
                    case .success(let res):
                        print("addWaiting 서버 요청 성공")
                        print(res)
                        self.addWaitingResponseCode = res.code
                        if res.code == "201" { // 웨이팅 추가 성공
                            DispatchQueue.main.async {
                                if let data = res.data {
                                    self.requestedWaitingInfo = data
                                }
                            }
                        } else { // 이미 대기열에 존재(code 400) or 기타
                            DispatchQueue.main.async {
                                self.addWaitingResponseMessage = res.message
                            }
                        }
                    case .failure(let error):
                        print("addWaiting 서버 요청 실패")
                        print("에러: \(error.localizedDescription)")
                        
                        if let data = response.data {
                            let responseData = String(data: data, encoding: .utf8)
                            print("서버 응답 데이터: \(responseData ?? "데이터 없음")")
                        }
                        
                        if let httpResponse = response.response {
                            print("HTTP 상태 코드: \(httpResponse.statusCode)")
                        }
                    }
                    
                    continuation.resume() // async 작업 종료
                }
        }
    }
    
    /// 대기 중인 팀의 수 조회
    func fetchWaitingTeamCount(boothId: Int) async {
        await withCheckedContinuation { continuation in
            print("fetchWaitingTeamCount - requested boothId: \(boothId)")
            
            let url = APIManager.shared.serverType.rawValue + "/waiting/\(boothId)/count"
            
            let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/waiting/79/count"
            
            let headers: HTTPHeaders = [.accept("application/json")]
            
            AF.request(testUrl, method: .get, headers: headers)
                .responseDecodable(of: WaitingOrderResponse.self) { response in
                    print("Request URL of fetchWaitingTeamCount: \(response.request?.url?.absoluteString ?? "")")
                    
                    switch response.result {
                    case .success(let res):
                        print("fetchWaitingTeamCount 서버 요청 성공")
                        print("code: \(res.code), message: \(res.message), waitingTeamCount: \(res.data ?? -1)")
                        DispatchQueue.main.async {
                            if let waitingTeamCount = res.data {
                                self.waitingTeamCount = waitingTeamCount
                            }
                        }
                    case .failure(let error):
                        print("fetchWaitingTeamCount 서버 요청 실패")
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
    
    /// 내 웨이팅 조회(WaitingView에서 호출)
    func fetchReservedWaiting(deviceId: String) async {
        await withCheckedContinuation { continuation in
            let url = APIManager.shared.serverType.rawValue + "/waiting/me/\(deviceId)"
            
            let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/waiting/me/\(deviceId)"
            
            let headers: HTTPHeaders = [
                .accept("application/json")
            ]
            
            AF.request(testUrl, method: .get, headers: headers)
                .responseDecodable(of: ReservedWaitingResponse.self) { response in
                    print("Request URL of fetchReservedWaiting: \(response.request?.url?.absoluteString ?? "")")
                    
                    switch response.result {
                    case .success(let res):
                        print("FetchReservedWaiting 요청 성공")
                        print(res)
                        DispatchQueue.main.async {
                            self.reservedWaitingList = res.data // 웨이팅을 신청했다가 res.data가 nil(신청한 웨이팅이 없는 상태)로 돌아올 수도 있으므로 unwrap없이 바로 res.data 반환함
                            if let reservedWaitingList = self.reservedWaitingList {
                                self.reservedWaitingCount = reservedWaitingList.count
                            } else {
                                self.reservedWaitingCount = 0
                            }
                            
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self.networkManager.isServerError = true
                        }
                        print("FetchReservedWaiting 서버 요청 실패")
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
    
    /// 핀 번호 검증 및 웨이팅 대기팀 수 확인
    func checkPinNumber(boothId: Int, pinNumber: String) async {
        await withCheckedContinuation { continuation in
            let url = APIManager.shared.serverType.rawValue + "/waiting/pin/check"
            
            let testUrl = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090" + "/waiting/pin/check"
            
            let headers: HTTPHeaders = [
                .accept("application/json"),
                .contentType("application/json")
            ]
            
            let parameters: [String: Any] = [
                "boothId": boothId,
                "pinNumber": pinNumber
            ]
            
            AF.request(testUrl, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: PinCheckResponse.self) { response in
                    print("Requested URL: \(response.request?.url?.absoluteString ?? "")")
                    
                    switch response.result {
                    case .success(let res):
                        print("pinNumberCheck 서버 요청 성공")
                        print(res)
                        if let waitingTeamCount = res.data {
                            if waitingTeamCount == -1 { // 잘못된 pin 번호
                                self.isPinNumberValid = false
                            } else { // 올바른 pin 번호
                                self.waitingTeamCount = waitingTeamCount
                                self.isPinNumberValid = true
                            }
                        } else { // 요청 실패, 잘못된 boothId 등
                            self.isPinNumberValid = false
                        }
                    case .failure(let error):
                        print("pinNumberCheck 서버 요청 실패")
                        print("에러: \(error.localizedDescription)")
                        
                        if let data = response.data {
                            let responseData = String(data: data, encoding: .utf8)
                            print("서버 응답 데이터: \(responseData ?? "데이터 없음")")
                        }
                        
                        if let httpResponse = response.response {
                            print("HTTP 상태 코드: \(httpResponse.statusCode)")
                        }
                    }
                    
                    print("CheckPinNumber 작업 종료")
                    continuation.resume() // async 작업 종료
                }
            }
        }
}
