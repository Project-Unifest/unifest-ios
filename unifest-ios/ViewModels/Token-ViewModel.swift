//
//  Token-ViewModel.swift
//  unifest-ios
//
//  Created by 임지성 on 2/16/25.
//

// 서버에 FCM token을 전달하는 메서드

import Alamofire
import Foundation

@MainActor
class TokenViewModel: ObservableObject {
    private let networkManager: NetworkManager
    private let apiClient: APIClient
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.apiClient = APIClient()
    }
    
    func registerFCMToken(deviceId: String) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.FCMToken.registerFCMToken)
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        var tempParameters: [String: Any] = [
            "deviceId": deviceId
        ]
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
            tempParameters["fcmToken"] = fcmToken
        }
        let parameters = tempParameters
        
        do {
            let response: RegisterFCMTokenResponse = try await apiClient.put(
                url: url,
                headers: headers,
                parameters: parameters,
                responseType: RegisterFCMTokenResponse.self
            )
            print("RegisterFCMTokenResponse request succeeded")
            print(response)
        } catch {
            NetworkUtils.handleNetworkError("RegisterFCMTokenResponse", error, networkManager)
        }
    }
}
