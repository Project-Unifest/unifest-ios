//
//  MapViewModel.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/13/24.
//

import CoreLocation
import MapKit
import Combine
import Foundation
import SwiftUI

import Combine
import CoreLocation
import Foundation
import MapKit
import SwiftUI

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    @ObservedObject var viewModel: RootViewModel
    @Published var isAuthorized: CLAuthorizationStatus = .notDetermined
    
    // 띄울 학교 지도
    @Published var mapSelectedFestivalId = 1
    @Published var festivalMapDataIndex = 0
    @Published var forceRefreshMapPageView = UUID()
    
    // 사용자의 최신 위치 데이터
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var userHeading: Double = 0
    
    @Published var annotationCount: Int = 0 {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    @Published var selectedAnnotationID: Int = -1 {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    @Published var selectedBoothIDList: [Int] = []
    @Published var isBoothListPresented: Bool = false
    @Published var isPopularBoothPresented: Bool = false
    @Published var isTagSelected: [BoothType: Bool] = [.drink: true, .food: true, .booth: true, .event: true, .hospital: true, .toilet: true]
    
    @Published var annotationList: [MapAnnotationData] = [] {
        willSet {
            DispatchQueue.main.async {
                self.objectWillChange.send()
            }
        }
    }
    
    init(viewModel: RootViewModel) {
        // super.init()
        self.viewModel = viewModel
    }
    
    // MapViewModel Instance화 시 권한 요청하려면 아래 initializer 사용
    /* override init() {
        super.init()
        requestLocationAuthorization()
    }*/
    
    func getAnnotationID() -> Int {
        if annotationCount == Int.max - 1 {
            annotationCount = 0
        }
        annotationCount += 1
        return annotationCount
    }
    
    func requestLocationAuthorization() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        DispatchQueue.global().async {
            guard let locationManager = self.locationManager else { return }
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        print("location manager status: \(locationManager.authorizationStatus)")
        isAuthorized = locationManager.authorizationStatus

        switch locationManager.authorizationStatus {
        case .notDetermined:
            print("not determined")
            break
            // requestLocationAuthorization()
        case .restricted:
            print("restricted")
            break
            // requestLocationAuthorization()
        case .denied:
            print("denied")
            break
            // requestLocationAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            print("allowed")
            break
        @unknown default:
            break
        }

        isAuthorized = locationManager.authorizationStatus
        print("isAuthorized: \(isAuthorized)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.async {
                self.checkLocationAuthorization()
            }
    }
    
    // 이 함수 호출 시 사용자 위치 정보 업데이트 시작
    func startUpdatingLocation() {
        self.locationManager?.startUpdatingLocation()
        self.locationManager?.startUpdatingHeading()
    }
    
    // 이 함수 호출 시 사용자 위치 정보 업데이트 중지
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.stopUpdatingHeading()
    }
    
    // 사용자의 위치 정보 실시간으로 업데이트
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        userHeading = heading.trueHeading
    }
    
    // 사용자가 권한 거부 시 설정으로 직접 이동하는 함수
    // Apple 정책 상 사용자가 한 번 위치 권한 거절 시 앱에서 재요청 불가, 사용자가 직접 설정 가서 켜야 함
    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func updateAnnotationList(makeCluster: Bool = false, clusterRadius: Double = 0.1, searchText: String = "") {
        var newList: [MapAnnotationData] = []
        var counter: Int = 0
        
        print("*** booths: \(viewModel.boothModel.booths.count)")
        
        // 검색
        if !searchText.isEmpty {
            for booth in viewModel.boothModel.booths.filter({ searchKeyword(booth: $0.self, keyword: searchText) }) {
                if booth.enabled {
                    if isTagSelected[stringToBoothType(booth.category)] ?? false {
                        let newAnn = MapAnnotationData(id: counter, annType: stringToBoothType(booth.category), boothIDList: [booth.id], latitude: booth.latitude, longitude: booth.longitude)
                        newList.append(newAnn)
                        counter += 1
                    }
                }
            }
        }
        
        // 클러스터링
        else if makeCluster {
            for boothType in BoothType.allCases {
                if isTagSelected[boothType] ?? false {
                    let clusteredList = clusterAnnotations(clusterRadius: clusterRadius, boothType: boothType)
                    
                    for clustered in clusteredList {
                        let newAnn = MapAnnotationData(id: counter, annType: boothType, boothIDList: clustered.boothIDList, latitude: clustered.center.latitude, longitude: clustered.center.longitude)
                        newList.append(newAnn)
                        counter += 1
                    }
                }
            }
        }
        
        // 분리
        else {
            for booth in viewModel.boothModel.booths {
                if booth.enabled {
                    if isTagSelected[stringToBoothType(booth.category)] ?? false {
                        let newAnn = MapAnnotationData(id: counter, annType: stringToBoothType(booth.category), boothIDList: [booth.id], latitude: booth.latitude, longitude: booth.longitude)
                        newList.append(newAnn)
                        counter += 1
                    }
                }
            }
        }
        
        DispatchQueue.main.async {
            print("*** newList Updated, count: \(newList.count)")
            self.annotationList = newList
        }
    }
    
    func searchKeyword(booth: BoothItem, keyword: String) -> Bool {
        let keyword = keyword.lowercased()
        let descriptionContainsKeyword = booth.description.lowercased().contains(keyword)
        let nameContainsKeyword = booth.name.lowercased().contains(keyword)
        
        return descriptionContainsKeyword || nameContainsKeyword
    }
    
    func clusterAnnotations(clusterRadius: Double, boothType: BoothType) -> [Cluster] {
        var clusters: [Cluster] = []
        
        let filteredBooths = viewModel.boothModel.booths.filter({ $0.category == boothType.rawValue && $0.enabled == true })
        
        for booth in filteredBooths {
            var isClustered = false
            
            var clusterId: Int = 0
            for cluster in clusters {
                let distance = calculateDistance(itemCoord: cluster.center, mvCoord: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude))
                
                // 클러스터링 반경 조절 가능(clusterRadius 값이 클수록 클러스터링 되는 반경이 늘어남)
                if distance <= clusterRadius {
                    cluster.points.append(CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude))
                    cluster.boothIDList.append(booth.id)
                    isClustered = true
                    // print("store appended to cluster \(clusterId): \(distance)")
                    cluster.updateCenter()
                    break
                }
                clusterId += 1
            }
            
            // 아무 곳에도 못 들어갔다면
            if !isClustered {
                let newCluster = Cluster(center: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude), points: [CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude)], type: boothType)
                newCluster.boothIDList.append(booth.id)
                clusters.append(newCluster)
                // print("new \(clusters.count)th cluster created: \(newCluster.center)")
            }
        }
        
        // print("number of clusters: \(clusters.count)")
        return clusters
    }
    
    func stringToBoothType(_ typeString: String) -> BoothType {
        switch typeString {
        case BoothType.drink.rawValue:
            return .drink
        case BoothType.food.rawValue:
            return .food
        case BoothType.event.rawValue:
            return .event
        case BoothType.booth.rawValue:
            return .booth
        case BoothType.hospital.rawValue:
            return .hospital
        case BoothType.toilet.rawValue:
            return .toilet
        default:
            return .booth
        }
    }
    
    func setSelectedAnnotationID(_ id: Int) {
        DispatchQueue.main.async {
            self.selectedAnnotationID = id
            print("selectedAnnotationID set to \(id)")
        }
    }
}

struct MapAnnotationData: Hashable, Identifiable {
    var id: Int
    var annType: BoothType
    var boothIDList: [Int]
    var latitude: Double
    var longitude: Double
}

struct MapViewTestView: View {
    @ObservedObject var vm: MapViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("isAuthorized: \(vm.isAuthorized.rawValue.description)")
            Text("Location: (\(vm.userLatitude), \(vm.userLongitude))")
            Text("Heading: \(vm.userHeading)")
            
            Button("권한 체크 및 요청") {
                // 위치 권한 체크, 권한 없는 경우 요청
                vm.requestLocationAuthorization()
            }
            .buttonStyle(.borderedProminent)
            
            Button("업데이트 시작") {
                vm.startUpdatingLocation()
            }
            .buttonStyle(.borderedProminent)
            
            Button("업데이트 중지") {
                vm.stopUpdatingLocation()
            }
            .buttonStyle(.borderedProminent)
            
            Button("설정으로") {
                vm.openSettings()
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    RootView(rootViewModel: RootViewModel(), networkManager: NetworkManager())
}


#Preview {
    @ObservedObject var vm = MapViewModel(viewModel: RootViewModel())
    
    return Group {
        MapViewTestView(vm: vm)
    }
}
