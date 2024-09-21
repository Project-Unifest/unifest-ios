//
//  BoothData.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/13/24.
//

import SwiftUI
import Foundation
import Combine
import UIKit

struct APIResponseBooth: Codable {
    var code: String?
    var message: String?
    var data: [BoothItem]?
}

struct BoothItem: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var category: String
    var description: String
    var thumbnail: String
    var location: String
    var latitude: Double
    var longitude: Double
    var enabled: Bool
}

struct APIResponseBoothDetail: Codable {
    var code: Code?
    var message: String?
    var data: BoothDetailItem?
    
    enum Code: Codable {
        case integer(Int)
        case string(String)
        
        init(from decoder: Decoder) throws {
            if let intValue = try? decoder.singleValueContainer().decode(Int.self) {
                self = .integer(intValue)
                return
            }
            if let stringValue = try? decoder.singleValueContainer().decode(String.self) {
                self = .string(stringValue)
                return
            }
            throw DecodingError.typeMismatch(Code.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode Code"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .integer(let intValue):
                try container.encode(intValue)
            case .string(let stringValue):
                try container.encode(stringValue)
            }
        }
    }
}

struct BoothDetailItem: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var category: String
    var description: String?
    var thumbnail: String?
    var warning: String?
    var location: String?
    var latitude: Double
    var longitude: Double
    var menus: [MenuItem]?
    var enabled: Bool?
    var waitingEnabled: Bool
    var openTime: String?
    var closeTime: String?
}

struct MenuItem: Codable, Hashable, Identifiable {
    var id: Int
    var name: String?
    var price: Int?
    var imgUrl: String?
    var menuStatus: String?
}

struct APIResponseIntData: Codable {
    var code: Code?
    var message: String?
    var data: Int?
    
    enum Code: Codable {
        case integer(Int)
        case string(String)
        
        init(from decoder: Decoder) throws {
            if let intValue = try? decoder.singleValueContainer().decode(Int.self) {
                self = .integer(intValue)
                return
            }
            if let stringValue = try? decoder.singleValueContainer().decode(String.self) {
                self = .string(stringValue)
                return
            }
            throw DecodingError.typeMismatch(Code.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode Code"))
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .integer(let intValue):
                try container.encode(intValue)
            case .string(let stringValue):
                try container.encode(stringValue)
            }
        }
    }
}

class BoothModel: ObservableObject {
    // static let shared = BoothModel()
    
    // @Published가 objectWillChange.send()를 수행해주므로 willSet { } 구문이 꼭 필요하지는 않은 듯?
    @Published var booths: [BoothItem] = [] {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    // 가장 인기 많은 부스 다섯개
    @Published var top5booths: [BoothItem] = [] {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    // 사용자가 선택한 부스
    @Published var selectedBooth: BoothDetailItem? {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    @Published var likedBoothList: [Int] = [] {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    // 사용자가 선택한 부스의 boothId
    @Published var selectedBoothID: Int = -1 {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    @Published var selectedBoothNumLike: Int = 0 {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    @Published var mapSelectedBoothList: [BoothItem] = [] {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadStoreListData {
            print("data is all loaded")
        }
    }
    
    // 프로젝트 내의 JSON데이터로 테스트용 메서드
    func loadData() {
        if let url = Bundle.main.url(forResource: "boothTest", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponseBooth.self, from: data)
                
                if apiResponse.data != nil {
                    DispatchQueue.main.async {
                        self.booths = apiResponse.data!
                        print(self.booths.count)
                    }
                }
                
                for index in 0..<booths.count {
                    booths[index].id = index
                }
                
                print(booths[0])
                
            } catch {
                print("Error while decoding JSON: \(error)")
            }
        }
    }
    
    // 실제로 서버에서 부스 데이터를 가져오는 메서드
    func loadStoreListData(completion: @escaping () -> Void) {
        // API 호출을 통해 부스 데이터를 가져옴
        APIManager.fetchDataGET("/api/booths/2/booths", api: .booth_all, apiType: .GET) { result in
            // fetchDataGet: 해당 링크에서 데이터를 가져옴
            switch result {
            case .success(let data):
                // 데이터를 가져오는 데 성공하면 self.booths에 데이터를 설정함(가져온 booth 정보를 BoothModel 클래스의 booths 프로퍼티에 저장)
                print("Data received in View: \(data)")
                if let response = data as? APIResponseBooth {
                    if let boothData = response.data {
                        DispatchQueue.main.async {
                            self.booths = boothData
                        }
                    }
                }
            case .failure(let error):
                print("Error in View: \(error)")
                // self.loadData()
            }
        }
    }
    
    func loadTop5Booth() {
        print(APIManager.shared.serverType.rawValue + "/api/booths?festivalId=1")
        var request = URLRequest(url: URL(string: APIManager.shared.serverType.rawValue + "/api/booths?festivalId=1")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print("Error: \(error)")
                } else {
                    print("No data received")
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponseBooth.self, from: data)
                
                if let responseData = apiResponse.data {
                    // todayFestivalList = responseData
                    if !responseData.isEmpty {
                        DispatchQueue.main.async {
                            self.top5booths = responseData
                        }
                        print("top 5 booth loaded: \(self.top5booths.count)")
                    } else {
                        print("top 5 booth is loaded but 0")
                    }
                } else {
                    print("responseData is nil")
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }

        task.resume()
    }
    
    func loadBoothDetail(_ selectedBoothID: Int) {
        self.selectedBoothID = selectedBoothID
        
        print("loadBoothDetail: " + APIManager.shared.serverType.rawValue + "/api/booths/\(selectedBoothID)")
        if let validURL = URL(string: APIManager.shared.serverType.rawValue + "/api/booths/\(selectedBoothID)") {
            var request = URLRequest(url: validURL, timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                        print("No data received")
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let apiResponse = try decoder.decode(APIResponseBoothDetail.self, from: data)
                    
                    if let responseData = apiResponse.data {
                        DispatchQueue.main.async {
                            self.selectedBooth = responseData
                            // print(self.selectedBooth)
                            self.fetchLikeNum(self.selectedBoothID)
                        }
                    } else {
                        print("responseData is nil")
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
            
            task.resume()
        }
    }
    
    private func saveLikeBoothListDB() {
        let stringData = self.likedBoothList.map(String.init).joined(separator: ",")
        UserDefaults.standard.set(stringData, forKey: "LIKE_BOOTH_LIST")
    }
    
    // 사용자가 부스를 관심있음 했는지 아닌지 확인하는 메서드(BoothFooterView에서 체크 가능)
    func isBoothContain(_ boothID: Int) -> Bool {
        if !likedBoothList.contains(boothID) {
            return false
        }
        
        for booth in booths {
            // hit
            if booth.id == boothID {
                return true
            }
        }
        print("** boothID: \(boothID) is not in booths")
        return false
    }
    
    func loadLikeBoothListDB() {
        guard let stringData = UserDefaults.standard.string(forKey: "LIKE_BOOTH_LIST") else {
            DispatchQueue.main.async {
                self.likedBoothList = []
                print("no LIKE BOOTH LIST, set [], count: \(self.likedBoothList.count)")
            }
            return
        }
        let stringArray = stringData.split(separator: ",")
        let intArray = stringArray.compactMap { Int($0) }
        DispatchQueue.main.async {
            self.likedBoothList = intArray
            print("LIKE BOOTH LIST is Loaded, count: \(self.likedBoothList.count)")
            return
        }
    }
    
    func insertLikeBoothDB(_ boothID: Int) {
        DispatchQueue.main.async {
            self.likedBoothList.append(boothID)
            
            let stringData = self.likedBoothList.map(String.init).joined(separator: ",")
            UserDefaults.standard.set(stringData, forKey: "LIKE_BOOTH_LIST")
        }
    }
    
    func deleteLikeBoothListDB(_ boothID: Int) {
        if let index = self.likedBoothList.firstIndex(of: boothID) {
            likedBoothList.remove(at: index)
            
            let stringData = self.likedBoothList.map(String.init).joined(separator: ",")
            UserDefaults.standard.set(stringData, forKey: "LIKE_BOOTH_LIST")
        }
    }
    
    /* func updateMapSelectedBoothList(_ boothIDList: [Int]) {
        print("updateMapSelectedBoothList")
        var boothList: [BoothItem] = []
        
        for boothID in boothIDList {
            if let booth = self.getBoothByID(boothID) {
                /* if boothIDList.contains(boothID) {
                    
                    boothIDList.append(boothID)
                }*/
                boothList.append(booth)
            }
        }
        
        print("updateMapSelectBoothList, count : \(boothList.count)")
        DispatchQueue.main.async {
            self.mapSelectedBoothList = boothList
        }
    }*/
    func updateMapSelectedBoothList(_ boothIDList: [Int]) {
        print("updateMapSelectedBoothList")
        var boothList: [BoothItem] = []
        var processedIDs: Set<Int> = Set()

        for boothID in boothIDList {
            // Check if the booth ID has already been processed
            if processedIDs.contains(boothID) {
                continue // Skip if the ID has already been processed
            }

            if let booth = self.getBoothByID(boothID) {
                boothList.append(booth)
                processedIDs.insert(boothID) // Mark the ID as processed
            }
        }

        print("updateMapSelectBoothList, count : \(boothList.count)")
        DispatchQueue.main.async {
            self.mapSelectedBoothList = boothList
        }
    }
    
    func getFullLikedBoothList() -> [Int] {
        if likedBoothList.isEmpty {
            return []
        }
        
        var likedList: [Int] = []
        
        for likedID in likedBoothList {
            if isBoothContain(likedID) {
                likedList.append(likedID)
            }
        }
        
        print("liked List: ")
        print(likedList)
        return likedList
    }
    
    func getRandomLikedBooths(count: Int=3) -> [Int] {
        if likedBoothList.isEmpty {
            return []
        }
        
        /* // likedBoothList 배열의 길이가 3 이하인 경우, likedBoothList 그대로 반환
        guard likedBoothList.count > count else {
            return likedBoothList
        }
        
        // likedBoothList 배열의 길이가 3 이상인 경우, 최대 3개의 정수를 랜덤하게 뽑아 반환
        var randomLikedBooths: [Int] = []
        var likedBoothsCopy = likedBoothList // likedBoothList를 복사하여 사용
        
        // likedBoothsCopy 배열에서 최대 3개의 정수를 랜덤하게 선택하여 randomLikedBooths에 추가
        while randomLikedBooths.count < count {
            let randomIndex = Int.random(in: 0..<likedBoothsCopy.count)
            let randomBoothID = likedBoothsCopy[randomIndex]
            if isBoothContain(randomBoothID) {
                randomLikedBooths.append(randomBoothID)
            }
            likedBoothsCopy.remove(at: randomIndex) // 선택한 정수를 복사한 배열에서 제거
        }
        
        // print("randomly selected: ")
        // print(randomLikedBooths)
        return randomLikedBooths*/
        
        var randomLikedBooths: [Int] = []
        var likedBoothsCopy = likedBoothList
        
        for likedID in likedBoothsCopy {
            let randomIndex = Int.random(in: 0..<likedBoothsCopy.count)
            let randomBoothID = likedBoothsCopy[randomIndex]
            
            if isBoothContain(randomBoothID) {
                randomLikedBooths.append(randomBoothID)
            }
            likedBoothsCopy.remove(at: randomIndex)
            
            if randomLikedBooths.count >= 3 {
                break
            }
        }
        
        print("randomly selected: ")
        print(randomLikedBooths)
        return randomLikedBooths
    }
    
    func addLike(_ boothID: Int) {
        DispatchQueue.main.async {
            self.selectedBoothNumLike += 1
        }
        uploadLikeNum(boothID)
    }
    
    func deleteLike(_ boothID: Int) {
        DispatchQueue.main.async {
            self.selectedBoothNumLike -= 1
        }
        uploadLikeNum(boothID)
    }
    
    func getBoothByID(_ boothID: Int) -> BoothItem? {
        return booths.first { $0.id == boothID }
    }
    
    private func uploadLikeNum(_ boothID: Int) {
        let parameters = "{\"boothId\": \(boothID),\"token\": \"\(UIDevice.current.deviceToken)\"}"
        print(parameters)
        let postData = parameters.data(using: .utf8)
        
        if let validURL = URL(string: APIManager.shared.serverType.rawValue + "/api/likes") {
            var request = URLRequest(url: validURL, timeoutInterval: Double.infinity)
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            
            URLSession.shared.dataTaskPublisher(for: request)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .receive(on: DispatchQueue.main)
                .tryMap(validate)
                .decode(type: APIResponseIntData.self, decoder: JSONDecoder())
                .sink { _ in
                } receiveValue: { [weak self] returnedPost in
                    print("booth like uploaded : \(returnedPost)")
                    self?.fetchLikeNum(boothID)
                    // completion()
                }
                .store(in: &cancellables)
        }
    }
    
    // 요청이 성공했는지 검사 (http response 200 ~ 299)
    private func validate(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        return data
    }
    
    func fetchLikeNum(_ boothID: Int) {
        // 해당 부스 좋아요 수 조회
        if let validURL = URL(string: APIManager.shared.serverType.rawValue + "/api/likes/\(boothID)") {
            var request = URLRequest(url: validURL, timeoutInterval: Double.infinity)
            request.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    if let error = error {
                        print("Error: \(error)")
                    } else {
                        print("No data received")
                    }
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let apiResponse = try decoder.decode(APIResponseIntData.self, from: data)
                    
                    if let responseData = apiResponse.data {
                        DispatchQueue.main.async {
                            self.selectedBoothNumLike = responseData
                            print("Fetch num like: \(self.selectedBoothNumLike)")
                        }
                    } else {
                        print("Fetch responseData is nil")
                    }
                } catch {
                    print("Fetch Error decoding JSON: \(error)")
                }
            }
            
            task.resume()
        }
    }
}

extension UIDevice {
    var deviceToken: String {
        if let identifierForVendor = UIDevice.current.identifierForVendor {
            return identifierForVendor.uuidString
        } else {
            return ""
        }
    }
}

struct BoothDataTestView: View {
    @ObservedObject var boothModel = BoothModel()
    
    var body: some View {
        ScrollView {
            Text("\(boothModel.booths.count)")
            
            ForEach(boothModel.booths) { festival in
                Text(festival.name)
            }
            
            Text("Device UUID: \(UIDevice.current.deviceToken)")
        }
    }
}

#Preview {
    BoothDataTestView()
}
