//
//  BoothData.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/13/24.
//

import SwiftUI
import Foundation
import Combine

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

class BoothModel: ObservableObject {
    @Published var booths: [BoothItem] = []
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadStoreListData {
            print("data is all loaded")
        }
    }
    
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
    
    func loadStoreListData(completion: @escaping () -> Void) {
        APIManager.fetchDataGET("/api/booths/1/booths", api: .booth_all, apiType: .GET) { result in
            switch result {
            case .success(let data):
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
}

struct BoothDataTestView: View {
    @ObservedObject var boothModel = BoothModel()
    
    var body: some View {
        VStack {
            Text("\(boothModel.booths.count)")
            
            ForEach(boothModel.booths) { festival in
                Text(festival.name)
            }
        }
    }
}

#Preview {
    BoothDataTestView()
}
