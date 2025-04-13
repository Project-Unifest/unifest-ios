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
    @Published var isAddFavoriteFestivalSucceeded: Bool = false // 사용X
    @Published var isDeleteFavoriteFestivalSucceeded: Bool = false // 사용X
    @Published var favoriteFestivalList: [Int] = []
    @Published var updateSucceededToast: Toast? = nil
    
    private let networkManager: NetworkManager
    private let apiClient: APIClient
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.apiClient = APIClient()
    }
    
    func getFavoriteFestivalList(deviceId: String) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.FavoriteFestival.getFavoriteFestivalList) + "?deviceId=\(deviceId)"
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        
        do {
            let response: GetFavoriteFestivalListResponse = try await apiClient.get(
                url: url,
                headers: headers,
                responseType: GetFavoriteFestivalListResponse.self
            )
            print("getFavoriteFestivalList request succeeded")
            self.favoriteFestivalList = response.data ?? [] // 빈 배열 또는 [Int]가 반환됨
            print(response)
        } catch {
            NetworkUtils.handleNetworkError("getFavoriteFestivalList", error, networkManager)
        }
    }
    
    func addFavoriteFestival(festivalId: Int, deviceId: String) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.FavoriteFestival.addFavoriteFestival(festivalId: festivalId))
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        let parameters: [String: Any] = [
            "deviceId": deviceId
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
            //            self.isAddFavoriteFestivalSucceeded = true
        } catch {
            NetworkUtils.handleNetworkError("AddFavoriteFestival", error, networkManager)
            //            self.isAddFavoriteFestivalSucceeded = false
        }
    }
    
    func deleteFavoriteFestival(festivalId: Int, deviceId: String) async {
        let url = NetworkUtils.buildURL(for: APIEndpoint.FavoriteFestival.deleteFavoriteFestival(festivalId: festivalId))
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("application/json")
        ]
        let parameters: [String: Any] = [
            "deviceId": deviceId
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
            //            self.isDeleteFavoriteFestivalSucceeded = true
        } catch {
            NetworkUtils.handleNetworkError("DeleteFavoriteFestival", error, networkManager)
            //            self.isDeleteFavoriteFestivalSucceeded = false
        }
    }
}
