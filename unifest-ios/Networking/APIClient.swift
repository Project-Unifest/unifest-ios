//
//  APIClient.swift
//  unifest-ios
//
//  Created by 임지성 on 11/9/24.
//

import Alamofire
import Foundation

enum APIClientError: Error {
    case networkError(AFError) // 네트워크 자체 문제
    case serverError(code: Int, message: String) // 서버가 보낸 에러(code, message)
    case unknownError
}

class APIClient {
    func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        headers: HTTPHeaders? = nil,
        parameters: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                .responseDecodable(of: responseType) { response in
                    switch response.result {
                    case .success(let data):
                        continuation.resume(returning: data)
                    case .failure(let afError):
                        if let data = response.data,
                           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                           let code = json["code"] as? Int,
                           let message = json["message"] as? String {
                            continuation.resume(throwing: APIClientError.serverError(code: code, message: message))
                        } else {
                            continuation.resume(throwing: APIClientError.networkError(afError))
                        }
                    }
                }
        }
    }
    
    // GET 요청 메서드
    func get<T: Decodable>(
        url: String,
        headers: HTTPHeaders? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(url: url, method: .get, headers: headers, responseType: responseType)
    }
    
    // POST 요청 메서드
    func post<T: Decodable>(
        url: String,
        headers: HTTPHeaders? = nil,
        parameters: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(url: url, method: .post, headers: headers, parameters: parameters, responseType: responseType)
    }
    
    // PUT 요청 메서드
    func put<T: Decodable>(
        url: String,
        headers: HTTPHeaders? = nil,
        parameters: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(url: url, method: .put, headers: headers, parameters: parameters, responseType: responseType)
    }
    
    func delete<T: Decodable>(
        url: String,
        headers: HTTPHeaders? = nil,
        parameters: [String: Any]? = nil,
        responseType: T.Type
    ) async throws -> T {
        return try await request(url: url, method: .delete, headers: headers, parameters: parameters, responseType: responseType)
    }
}
