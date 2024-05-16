//
//  VersionService.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/17/24.
//

import Foundation

final class VersionService {
    static let shared: VersionService = VersionService()
    
    var isOldVersion: Bool = false
    
    private let appleID = "6502256367"
    private let bundleID = "com.hoeunlee228.unifest-ios"
    lazy var appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(appleID)"
    
    func loadAppStoreVersion(completion: @escaping (String?) -> Void) {
        let appStoreUrl = "http://itunes.apple.com/kr/lookup?bundleId=\(bundleID)"
        
        let task = URLSession.shared.dataTask(with: URL(string: appStoreUrl)!) { data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                   let results = json["results"] as? [[String: Any]],
                   let appStoreVersion = results[0]["version"] as? String {
                    print("App Store Version: \(appStoreVersion)")
                    completion(appStoreVersion)
                } else {
                    completion(nil)
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func nowVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        return version
    }
}
