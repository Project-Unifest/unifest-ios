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
    
    func addFavoriteFestival(festivalId: Int, fcmToken: String) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.FavoriteFestival.subscribe)
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
            NetworkUtils.handleNetworkError("AddFavoriteFestival", error, networkManager)
            self.isAddFavoriteFestivalSucceeded = false
        }
    }
    
    func deleteFavoriteFestival(festivalId: Int, fcmToken: String) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.FavoriteFestival.subscribe)
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
            NetworkUtils.handleNetworkError("DeleteFavoriteFestival", error, networkManager)
            self.isDeleteFavoriteFestivalSucceeded = false
        }
    }
}
