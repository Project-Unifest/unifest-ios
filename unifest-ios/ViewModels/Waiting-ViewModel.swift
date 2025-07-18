//
//  WaitingRequestView-ViewModel.swift
//  unifest-ios
//
//  Created by 임지성 on 7/31/24.
//

import Alamofire
import Foundation

@MainActor
class WaitingViewModel: ObservableObject {
    // Waiting폴더 관련 변수
    @Published var reservedWaitingList: [ReservedWaitingResult]? = nil
    @Published var cancelWaiting = false // WaitingCancelView를 띄움
    @Published var waitingIdToCancel = -1 // 취소할 웨이팅의 WaitingId 저장
    @Published var waitingStatus = "" // WaitingCancelView에 어떤 문구를 띄울 지 결정
    @Published var waitingCancelToast: Toast? = nil
    
    // Detail폴더 관련 변수
    @Published var waitingTeamCount: Int = -1 // WaitingRequestView와 WaitingCompleteView에서 웨이팅 팀 수를 보여주는 변수
    @Published var requestedWaitingInfo: AddWaitingResult? = nil
    @Published var isPinNumberValid: Bool? = nil
    @Published var addWaitingResponseCode = "" // 웨이팅 신청 API의 응답코드
    @Published var addWaitingResponseMessage = "" // 웨이팅 신청 API의 응답 메세지
    @Published var reservedWaitingCount = 0 // 사용자가 예약한 웨이팅 개수
    @Published var reservedWaitingCountExceededToast: Toast? = nil // 해당 축제에서 지정한 웨이팅 최대 개수를 초과해서 웨이팅을 시도하려고 할 때 Toast를 띄움
    @Published var alreadyReservedToast: Toast? = nil // 이미 웨이팅을 신청한 부스에 다시 웨이팅하기 버튼을 탭했을 때 Toast를 띄움
    
    private let networkManager: NetworkManager
    private let apiClient: APIClient
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.apiClient = APIClient()
    }
    
    /// 사용자의 웨이팅 취소
    func cancelWaiting(waitingId: Int, deviceId: String) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.Waiting.cancel)
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        let parameters: [String: Any] = [
            "waitingId": waitingId,
            "deviceId": deviceId
        ]
        
        do {
            let response: CancelWaitingResponse = try await apiClient.put(
                url: url,
                headers: headers,
                parameters: parameters,
                responseType: CancelWaitingResponse.self
            )
            print("Cancel waiting request succeeded")
        } catch {
            NetworkUtils.handleNetworkError("CancelWaiting", error, networkManager)
        }
    }
    
    /// 웨이팅 추가(WaitingRequestView에서 호출)
    func addWaiting(boothId: Int, phoneNumber: String, deviceId: String, partySize: Int, pinNumber: String) async  {
        let url = NetworkUtils.buildURL(for: APIEndpoint.Waiting.add)
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        var tempParameters: [String: Any] = [
            "boothId": boothId,
            "tel": phoneNumber,
            "deviceId": deviceId,
            "partySize": partySize,
            "pinNumber": pinNumber,
        ]
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
            tempParameters["fcmToken"] = fcmToken
        }
        let parameters = tempParameters
        print("웨이팅 요청 파라미터:")
        print(parameters)
        
        do {
            let response: AddWaitingResponse = try await apiClient.post(
                url: url,
                headers: headers,
                parameters: parameters,
                responseType: AddWaitingResponse.self
            )
            print("Add waiting request succeeded")
            print(response)
            
            if response.code == "201", let data = response.data {
                self.requestedWaitingInfo = data
                self.addWaitingResponseCode = "201"
            } else {
                self.addWaitingResponseMessage = response.message
            }
        } catch {
            NetworkUtils.handleNetworkError("AddWaiting", error, networkManager)
        }
    }
    
    /// **현재는 사용되지 않는 메서드**
    /// 대기 중인 팀의 수 조회
    /// checkPinNumber의 api 반환값에 waitingTeamCount가 있으므로 현재 사용되지 않는 메서드임
    func fetchWaitingTeamCount(boothId: Int) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.Waiting.fetchTeamCount(boothId: boothId))
        let headers: HTTPHeaders = [.accept("application/json")]
        
        do {
            let response: WaitingOrderResponse = try await apiClient.get(
                url: url,
                headers: headers,
                responseType: WaitingOrderResponse.self
            )
            print("fetchWaitingTeamCount request succeeded")
            print(response)
            
            if let waitingTeamCount = response.data {
                self.waitingTeamCount = waitingTeamCount
            }
        } catch {
            NetworkUtils.handleNetworkError("FetchWaitingTeamCount", error, networkManager)
        }
    }
    
    /// 내 웨이팅 조회(WaitingView에서 호출)
    func fetchReservedWaiting(deviceId: String) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.Waiting.fetchReservedWaiting(deviceId: deviceId))
        let headers: HTTPHeaders = [.accept("application/json")]
        
        do {
            let response: ReservedWaitingResponse = try await apiClient.get(
                url: url,
                headers: headers,
                responseType: ReservedWaitingResponse.self
            )
            print("fetchReservedWaiting request succeeded")
            print(response)
            
            // 웨이팅을 신청했다가 res.data가 nil(신청한 웨이팅이 없는 상태)로 돌아올 수도 있으므로 unwrap없이 바로 res.data 반환
            self.reservedWaitingList = response.data
            if let reservedWaitingList = self.reservedWaitingList {
                self.reservedWaitingCount = reservedWaitingList.count
            } else {
                self.reservedWaitingCount = 0
            }
        } catch {
            NetworkUtils.handleNetworkError("FetchReservedWaiting", error, networkManager)
        }
    }
    
    /// 핀 번호 검증(웨이팅 대기팀 수 반환됨)
    func checkPinNumber(boothId: Int, pinNumber: String) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.Waiting.checkPin)
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        let parameters: [String: Any] = [
            "boothId": boothId,
            "pinNumber": pinNumber
        ]
        
        do {
            let response: PinCheckResponse = try await apiClient.post(
                url: url,
                headers: headers,
                parameters: parameters,
                responseType: PinCheckResponse.self
            )
            print("chedkPinNumber request succeeded")
            print(response)
            
            if let waitingTeamCount = response.data {
                if waitingTeamCount == -1 { // 잘못된 pin 번호
                    self.isPinNumberValid = false
                } else { // 올바른 pin 번호
                    self.waitingTeamCount = waitingTeamCount
                    self.isPinNumberValid = true
                }
            } else { // 요청 실패, 잘못된 boothId 등
                self.isPinNumberValid = false
            }
        } catch {
            NetworkUtils.handleNetworkError("CheckPinNumber", error, networkManager)
        }
    }
}
