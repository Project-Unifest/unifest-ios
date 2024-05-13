//
//  APIManager.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/7/24.
//

import Combine
import Foundation
import SwiftUI

final class APIManager: ObservableObject {
    
    static let shared = APIManager(serverType: .dev)
    private var cancellables = Set<AnyCancellable>()
    
    // API 서버 종류별 address
    enum ServerType: String {
        case dev = "http://ec2-43-200-72-31.ap-northeast-2.compute.amazonaws.com:9090"
    }
    
    // API Error 종류
    enum APIError: Error {
        case decodingError
        case errorCode(Int)
        case unknown
    }
    
    // 현재 APIManager가 사용할 서버 종류 및 주소
    private var serverType: ServerType
    private var baseURL: String
    
    // API 요청 반환 종류
    enum APIResponseResult {
        // 요청 결과 반환 성공
        case success
        // 요청 결과 반환 실패 (오류)
        case fail
        // 서버와의 연결 불가
        case lossConnection
    }
    
    enum APIType: String {
        case GET = "GET"
        case POST = "POST"
        case DELETE = "DELETE"
        case PATCH = "PATCH"
    }
    
    enum APICollections: String {
        case fest_name = "/festival" // 학교명으로 검색
        case fest_after = "/festival/after" // 날짜 이후
        case fest_all = "/festival/all" // 모두
        case fest_region = "/festival/region" // 지역 축제
        case fest_today = "/festival/today" // 오늘 축제
        
        case booth_top5 = "/api/booths" // 상위 5개 조회
        case booth_specific = "/api/booths/%@" // 특정 부스 조회
        case booth_all = "/api/booths/%@/booths" // 부스 전체 조회
    }
    
    // static 인스턴스 생성자 (서버 타입 명시 필요)
    private init(serverType: ServerType) {
        self.serverType = serverType
        self.baseURL = serverType.rawValue
    }
    
    static func fetchDataGET(_ endpoint: APICollections,
                                     apiType: APIType,
                                     querys: [String: Any]? = nil,
                                     landmarkID: Int? = nil,
                                     completion: @escaping (Result<Any, Error>) -> Void) {
        // URL과 쿼리 파라미터를 포함하여 URLRequest 생성
        var urlComponents: URLComponents
        
        // URL String
        var urlString = APIManager.shared.serverType.rawValue + endpoint.rawValue
        
        // URL Component 생성
        if let component = URLComponents(string: urlString) {
            urlComponents = component
        } else {
            // URL Component 생성 실패
            completion(.failure(NSError(domain: "Invalied URL", code: 0)))
            return
        }
        
        // URL Component에 Param Query 추가
        var queryItemList: [URLQueryItem] = []
        if let querys = querys {
            for (key, value) in querys {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                queryItemList.append(queryItem)
            }
        }
        urlComponents.queryItems = queryItemList
        
        // URLComponents에서 완전한 URL을 가져와서 사용
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalied URL", code: 0)))
            return
        }
        
        // Request Instance 생성
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)

        // HTTP 메소드 설정
        request.httpMethod = apiType.rawValue

        // 네트워크 요청 수행
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // 에러 처리
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // 응답 처리
            guard let httpResponse = response as? HTTPURLResponse else {
                // 응답이 올바르지 않은 경우
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            // access token 토큰 만료
            if httpResponse.statusCode == 401 {
                completion(.failure(NSError(domain: "Access Token is Fired, New Token is needed", code: 401)))
                return
            }
            
            // 데이터 파싱 및 출력
            guard let data = data else {
                // 데이터가 없는 경우
                completion(.failure(NSError(domain: "No data received", code: 0)))
                return
            }
            
            do {
                // JSON 디코딩
                let decoder = JSONDecoder()
                // let apiResponse = try decoder.decode([String: String].self, from: data)
                
                // MARK: 반환 결과가 특수한 API들 예외 처리
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                completion(.success(apiResponse))
                
            } catch {
                // JSON 디코딩 오류 처리
                completion(.failure(error))
            }
        }
        
        // 네트워크 요청 시작
        task.resume()
    }
}

struct APIResponse: Codable {
    var code: String?
    var message: String?
    var data: [FestivalData]?
}

struct FestivalData: Codable {
    var festivalId: Int?
    var schoolId: Int?
    var thumbnail: String?
    var schoolName: String?
    var region: String?
    var festivalName: String?
    var beginDate: String?
    var endDate: String?
    var latitude: Double?
    var longitude: Double?
}

struct BoothData: Codable {
    var id: Int
    var name: String
    var category: String
    var description: String
    var thumbnail: String
    var location: String
    var latitude: Double
    var longitude: Double
}

struct APITestView: View {
    var body: some View {
        VStack {
            List {
                Button("가장 가까운 랜드마크 - /api/landmarks") {
                    APIManager.fetchDataGET(.fest_all, apiType: .GET) { result in
                        switch result {
                        case .success(let data):
                            print("Data received in View: \(data)")
                        case .failure(let error):
                            print("Error in View: \(error)")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    APITestView()
}
