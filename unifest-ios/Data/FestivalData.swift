//
//  FestivalData.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/13/24.
//

import SwiftUI
import Combine
import Foundation

struct APIResponse: Codable {
    var code: String?
    var message: String?
    var data: [FestivalItem]?
}

struct FestivalItem: Codable, Hashable, Identifiable {
    var id: UUID? = UUID()
    var festivalId: Int
    var schoolId: Int
    var thumbnail: String
    var schoolName: String
    var region: String
    var festivalName: String
    var beginDate: String
    var endDate: String
    var latitude: Double
    var longitude: Double
    var starList: [StarItem]?
}

//struct APIResponseFestToday: Codable {
//    var code: Int?
//    var message: String?
//    var data: [TodayFestivalItem]?
//}

struct APIResponseFestToday: Codable {
    var code: Code?
    var message: String?
    var data: [TodayFestivalItem]?
    
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

struct TodayFestivalItem: Codable, Hashable, Identifiable {
    var id: UUID? = UUID()
    var schoolId: Int
    var schoolName: String
    var thumbnail: String
    var festivalId: Int
    var festivalName: String
    var beginDate: String
    var endDate: String
    var starList: [StarItem]
}

struct StarItem: Codable, Hashable {
    var starId: Int
    var name: String
    var imgUrl: String
}

class FestivalModel: ObservableObject {
    @Published var festivals: [FestivalItem] = [] {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    @Published var todayFestivals: [TodayFestivalItem] = [] {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // loadData()
        
        loadStoreListData {
            print("data is all loaded")
        }
    }
    
    func loadData() {
        if let url = Bundle.main.url(forResource: "festivalTest", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                
                if apiResponse.data != nil {
                    DispatchQueue.main.async {
                        self.festivals = apiResponse.data!
                        print(self.festivals.count)
                    }
                }
                
            } catch {
                print("Error while decoding JSON: \(error)")
            }
        }
    }
    
    func loadStoreListData(completion: @escaping () -> Void) {
        APIManager.fetchDataGET("/festival/all", api: .fest_all, apiType: .GET) { result in
            switch result {
            case .success(let data):
                print("Data received in View: \(data)")
                if let response = data as? APIResponse {
                    if let festivalData = response.data {
                        DispatchQueue.main.async {
                            self.festivals = festivalData
                        }
                    }
                }
            case .failure(let error):
                print("Error in View: \(error)")
                // self.loadData()
            }
        }
    }
    
    func isFestival(year: Int, month: Int, day: Int) -> Int {
        var count: Int = 0
        
        for festival in festivals {
            // Convert festival beginDate and endDate strings to Date objects
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            guard let beginDate = dateFormatter.date(from: festival.beginDate),
                  let endDate = dateFormatter.date(from: festival.endDate) else {
                continue // Skip iteration if date conversion fails
            }
            
            // Create date components for the given month and day
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            
            // Create date object for the given month and day
            guard let currentDate = Calendar.current.date(from: components) else {
                continue // Skip iteration if date creation fails
            }
            
            // Check if currentDate falls within the range of festival dates
            if (currentDate >= beginDate) && (currentDate <= endDate) {
                count += 1
            }
        }
        
        return count
    }
    
    // API 요청 반환 종류
    enum APIResponseResult {
        // 요청 결과 반환 성공
        case success
        // 요청 결과 반환 실패 (오류)
        case fail
        // 서버와의 연결 불가
        case lossConnection
    }
    
    func getFestivalByDate(year: Int, month: Int, day: Int) {
        print(APIManager.shared.serverType.rawValue + "/festival/today?date=2024-\(String(format: "%02d", month))-\(String(format: "%02d", day))")
        var request = URLRequest(url: URL(string: APIManager.shared.serverType.rawValue + "/festival/today?date=2024-\(String(format: "%02d", month))-\(String(format: "%02d", day))")!,timeoutInterval: Double.infinity)
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
                let apiResponse = try decoder.decode(APIResponseFestToday.self, from: data)
                
                if let responseData = apiResponse.data {
                    // todayFestivalList = responseData
                    if !responseData.isEmpty {
                        DispatchQueue.main.async {
                            self.todayFestivals = responseData
                        }
                        print("today fest loaded: \(self.todayFestivals.count)")
                    } else {
                        print("today fest is loaded but 0")
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
    
//    func getFestivalByDate(year: Int, month: Int, day: Int) -> [FestivalItem] {
//        
//    }
    
    func getFestivalAfter(year: Int, month: Int, day: Int) -> [FestivalItem] {
        var festList: [FestivalItem] = []

        // Get today's date
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // Filter festivals with endDate equal to or later than today's date
        for festival in festivals {
            // Convert festival endDate string to a Date object
        
            guard let endDate = dateFormatter.date(from: festival.endDate) else {
                continue // Skip iteration if date conversion fails
            }

            // Check if endDate is equal to or later than today's date
            if endDate >= currentDate {
                festList.append(festival)
            }
        }

        // Sort festList based on beginDate
        festList.sort {
            guard let date1 = dateFormatter.date(from: $0.beginDate),
                  let date2 = dateFormatter.date(from: $1.beginDate) else {
                return false // Return false if date conversion fails for any item
            }
            return date1 < date2
        }

        return festList
    }
}

struct FestivalDataTestView: View {
    @ObservedObject var festivalModel = FestivalModel()
    
    var body: some View {
        VStack {
            Text("\(festivalModel.festivals.count)")
            
            /* ForEach(festivalModel.festivals) { festival in
                Text(festival.festivalName + " " + festival.schoolName)
            }*/
            ForEach(festivalModel.festivals, id: \.self) { festival in
                Text(festival.schoolName + " " + festival.festivalName)
            }
            
            Text("Number of festivals: \(festivalModel.isFestival(year: 2024, month: 5, day: 23))")
        }
    }
}

#Preview {
    FestivalDataTestView()
}
