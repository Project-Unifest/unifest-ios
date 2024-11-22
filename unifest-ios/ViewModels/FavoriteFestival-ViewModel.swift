//
//  FavoriteFestivalViewModel.swift
//  unifest-ios
//
//  Created by 임지성 on 8/26/24.
//

import Alamofire
import Foundation

@MainActor
class FavoriteFestivalViewModel: ObservableObject {
    @Published var isAddFavoriteFestivalSucceeded: Bool = false
    @Published var isDeleteFavoriteFestivalSucceeded: Bool = false
    
    private let networkManager: NetworkManager
    private let apiClient: APIClient
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.apiClient = APIClient()
    }
    
    enum FavoriteFestivalAPI {
        case add
        case delete
        
        var path: String {
            switch self {
            case .add, .delete:
                return "/megaphone/subscribe"
            }
        }
        
        var url: String {
            return APIManager.shared.serverType.rawValue + path
        }
    }
    
    private func buildURL(for endpoint: FavoriteFestivalAPI) -> String {
        return endpoint.url
    }
    
    private func handleNetworkError(_ methodName: String, _ error: Error) {
        self.networkManager.isServerError = true
        print("\(methodName) network request failed with error:", error)
    }
    
    func addFavoriteFestival(festivalId: Int, fcmToken: String) async {
        let url = buildURL(for: .add)
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        let parameters: [String: Any] = [
            "festivalId": festivalId,
            "fcmToken": fcmToken
        ]
        
        do {
            let response: AddFavoriteFestivalResponse = try await apiClient.post(
                url: url,
                headers: headers,
                parameters: parameters,
                responseType: AddFavoriteFestivalResponse.self
            )
            print("AddFavoriteFestival request succeeded")
            print(response)
            self.isAddFavoriteFestivalSucceeded = true
        } catch {
            handleNetworkError("AddFavoriteFestival", error)
            self.isAddFavoriteFestivalSucceeded = false
        }
    }
    
    func deleteFavoriteFestival(festivalId: Int, fcmToken: String) async {
        let url = buildURL(for: .delete)
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        let parameters: [String: Any] = [
            "festivalId": festivalId,
            "fcmToken": fcmToken
        ]
        
        do {
            let response: DeleteFavoriteFestivalResponse = try await apiClient.delete(
                url: url,
                headers: headers,
                parameters: parameters,
                responseType: DeleteFavoriteFestivalResponse.self
            )
            print("DeleteFavoriteFestival request succeeded")
            print(response)
            self.isDeleteFavoriteFestivalSucceeded = true
        } catch {
            handleNetworkError("DeleteFavoriteFestival", error)
            self.isDeleteFavoriteFestivalSucceeded = false
        }
    }
}
