//
//  VersionService.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/17/24.
//

import Foundation

struct AppStoreResponse: Decodable {
    var results: [Result]
    
    struct Result: Decodable {
        var version: String
    }
}

final class VersionService {
    static let shared: VersionService = VersionService()
    
    var isOldVersion: Bool = false
    
    private let appleID = "6502256367"
    private let bundleID = "com.hoeunlee228.unifest-ios"
    lazy var appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(appleID)"
    
    func loadAppStoreVersion() async throws -> String? {
        let appStoreUrl = "http://itunes.apple.com/kr/lookup?bundleId=\(bundleID)"

        let (data, _) = try await URLSession.shared.data(from: URL(string: appStoreUrl)!)
        let json = try JSONDecoder().decode(AppStoreResponse.self, from: data)
        return json.results.first?.version
    }
    
    func currentVersion() -> String? {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
