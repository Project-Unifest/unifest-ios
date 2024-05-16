//
//  MapView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/13/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var boothModel: BoothModel
    
    @Binding var isTagSelected: [BoothType: Bool]
    @Binding var searchText: String
    
    @Binding var selectedBoothIDList: [Int]
    @Binding var isBoothListPresented: Bool
    @Binding var isPopularBoothPresented: Bool
    
    // 건국대학교 중심: 북 37.54263°, 동 127.07687°
    @State var mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 37.542_634, longitude: 127.076_769), distance: 3000, heading: 0.0, pitch: 0))
    
    // let mapCameraBounds: MapCameraBounds = MapCameraBounds(minimumDistance: 0, maximumDistance: 4000)
    let mapCameraBounds: MapCameraBounds = MapCameraBounds(centerCoordinateBounds: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.542_634, longitude: 127.076_769), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.01)), minimumDistance: 0, maximumDistance: 4000)
    
    let polygonKonkuk: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.54508, longitude: 127.07658),
        CLLocationCoordinate2D(latitude: 37.54468, longitude: 127.07663),
        CLLocationCoordinate2D(latitude: 37.54470, longitude: 127.07615),
        CLLocationCoordinate2D(latitude: 37.54461, longitude: 127.07561),
        CLLocationCoordinate2D(latitude: 37.54462, longitude: 127.07507),
        CLLocationCoordinate2D(latitude: 37.54461, longitude: 127.07455),
        CLLocationCoordinate2D(latitude: 37.54470, longitude: 127.07396),
        CLLocationCoordinate2D(latitude: 37.54462, longitude: 127.07348),
        CLLocationCoordinate2D(latitude: 37.54452, longitude: 127.07331),
        CLLocationCoordinate2D(latitude: 37.54266, longitude: 127.07252),
        CLLocationCoordinate2D(latitude: 37.54230, longitude: 127.07227),
        CLLocationCoordinate2D(latitude: 37.54132, longitude: 127.07179),
        CLLocationCoordinate2D(latitude: 37.54099, longitude: 127.07283),
        CLLocationCoordinate2D(latitude: 37.53957, longitude: 127.07216),
        CLLocationCoordinate2D(latitude: 37.53873, longitude: 127.07504),
        CLLocationCoordinate2D(latitude: 37.53933, longitude: 127.07516),
        CLLocationCoordinate2D(latitude: 37.53919, longitude: 127.07674),
        CLLocationCoordinate2D(latitude: 37.53908, longitude: 127.07719),
        CLLocationCoordinate2D(latitude: 37.53910, longitude: 127.07839),
        CLLocationCoordinate2D(latitude: 37.53900, longitude: 127.07850),
        CLLocationCoordinate2D(latitude: 37.53902, longitude: 127.07903),
        CLLocationCoordinate2D(latitude: 37.53886, longitude: 127.07906),
        CLLocationCoordinate2D(latitude: 37.53891, longitude: 127.07995),
        CLLocationCoordinate2D(latitude: 37.53925, longitude: 127.07993),
        CLLocationCoordinate2D(latitude: 37.53934, longitude: 127.07973),
        CLLocationCoordinate2D(latitude: 37.53982, longitude: 127.07962),
        CLLocationCoordinate2D(latitude: 37.54014, longitude: 127.07999),
        CLLocationCoordinate2D(latitude: 37.54067, longitude: 127.08086),
        CLLocationCoordinate2D(latitude: 37.54119, longitude: 127.08131),
        CLLocationCoordinate2D(latitude: 37.54208, longitude: 127.08131),
        CLLocationCoordinate2D(latitude: 37.54234, longitude: 127.08115),
        CLLocationCoordinate2D(latitude: 37.54257, longitude: 127.07857),
        CLLocationCoordinate2D(latitude: 37.54382, longitude: 127.07876),
        CLLocationCoordinate2D(latitude: 37.54394, longitude: 127.07966),
        CLLocationCoordinate2D(latitude: 37.54429, longitude: 127.08006),
        CLLocationCoordinate2D(latitude: 37.54496, longitude: 127.07994),
        CLLocationCoordinate2D(latitude: 37.54493, longitude: 127.07897),
        CLLocationCoordinate2D(latitude: 37.54485, longitude: 127.07754),
        CLLocationCoordinate2D(latitude: 37.54494, longitude: 127.07704),
        CLLocationCoordinate2D(latitude: 37.54516, longitude: 127.07688)
    ]
    
    // distance
    @State private var lastDistance: Double = 4000
    
    // last center
    // @State private var lastLatitude: CLLocationDegrees = 37.542_630
    // @State private var lastLongitude: CLLocationDegrees = 127.076_870
    
    var body: some View {
        ZStack {
            Map(initialPosition: mapCameraPosition, bounds: mapCameraBounds) {
                UserAnnotation()
                
                MapPolygon(coordinates: polygonKonkuk)
                    .foregroundStyle(.background.opacity(0.0))
                    .stroke(.black.opacity(0.8), lineWidth: 1.0)
                
                if let boxPolygon = makeBoundaries(coordinates: polygonKonkuk) {
                    MapPolygon(coordinates: boxPolygon)
                        .foregroundStyle(.gray.opacity(0.2))
                }
                
                if searchText.isEmpty {
                    // setting
                    let isClustering = UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP")
                    
                    if (lastDistance < 1000 || !isClustering) {
                        ForEach(boothModel.booths, id: \.self) { booth in
                            if (isTagSelected[stringToBoothType(booth.category)] ?? false) {
                                Annotation("", coordinate: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude)) {
                                    BoothAnnotation(number: 0, boothType: stringToBoothType(booth.category))
                                        .onTapGesture {
                                            boothModel.updateMapSelectedBoothList([booth.id])
                                            print("tab: \(booth.id)")
                                            withAnimation(.spring) {
                                                isPopularBoothPresented = false
                                                isBoothListPresented = true
                                            }
                                        }
                                }
                            }
                        }
                    } else {
                        ForEach(BoothType.allCases, id: \.self) { boothType in
                            if (isTagSelected[boothType] ?? false) {
                                ForEach(clusterAnnotations(clusterRadius: 1, boothType: boothType)) { cluster in
                                    Annotation("", coordinate: cluster.center) {
                                        BoothAnnotation(number: cluster.points.count, boothType: boothType)
                                            .onTapGesture {
                                                boothModel.updateMapSelectedBoothList(cluster.boothIDList)
                                                print("cluster tab: \(cluster.points.count)")
                                                withAnimation(.spring) {
                                                    isPopularBoothPresented = false
                                                    isBoothListPresented = true
                                                }
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
                // 검색 결과만 표시
                else {
                    ForEach(boothModel.booths, id: \.self) { booth in
                        if searchKeyword(booth: booth, keyword: searchText) {
                            Annotation("", coordinate: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude)) {
                                BoothAnnotation(number: 0, boothType: stringToBoothType(booth.category))
                                    .onTapGesture {
                                        boothModel.updateMapSelectedBoothList([booth.id])
                                        print("tab: \(booth.id)")
                                        withAnimation(.spring) {
                                            isPopularBoothPresented = false
                                            isBoothListPresented = true
                                        }
                                    }
                            }
                        }
                    }
                }
                
                // 37.540_03 127.074_20
                // 37.543_02 127.076_65
                // 37.542_18 127.078_40
                /* Annotation("", coordinate: CLLocationCoordinate2D(latitude: 37.540_03, longitude: 127.074_20)) {
                    BoothAnnotation(number: 8, boothType: .booth, isSelected: $isBoothSelected[0])
                }
                
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: 37.543_02, longitude: 127.076_65)) {
                    BoothAnnotation(number: 13, boothType: .drink, isSelected: $isBoothSelected[1])
                }
                
                Annotation("", coordinate: CLLocationCoordinate2D(latitude: 37.542_18, longitude: 127.078_40)) {
                    BoothAnnotation(number: 1, boothType: .toilet, isSelected: $isBoothSelected[2])
                }*/
                
            }
            // .ignoresSafeArea()
            .mapControls {
//                MapCompass()
//                MapPitchToggle()
//                MapUserLocationButton()
//                MapScaleView()
            }
            .controlSize(.mini)
            .mapStyle(.standard)
            .safeAreaPadding()
            .onMapCameraChange { mapCameraUpdateContext in
                print("mapCam distance: \(mapCameraUpdateContext.camera.distance)")
                print("mapCam Center: (\(mapCameraUpdateContext.camera.centerCoordinate.latitude), \(mapCameraUpdateContext.camera.centerCoordinate.longitude))")
                
                // 확대, 축소 비율이 1.1 이상 변한 경우만 업데이트
                /* print("map distance ratio: \(max(lastDistance, mapCameraUpdateContext.camera.distance) / min(lastDistance, mapCameraUpdateContext.camera.distance))")
                if max(lastDistance, mapCameraUpdateContext.camera.distance) / min(lastDistance, mapCameraUpdateContext.camera.distance) > 1.1 && lastDistance >= 40000 {
                    clusters = clusterAnnotations(clusterRadius: 2 * (lastDistance / 120_000))
                }*/
                
                // 비율이 달라진 경우에만 업데이트
                if (abs(lastDistance - mapCameraUpdateContext.camera.distance) > 0.1) {
                    print("last dist: \(lastDistance), new dist: \(mapCameraUpdateContext.camera.distance)")
                    lastDistance = mapCameraUpdateContext.camera.distance
                }
                
                // lastLatitude = mapCameraUpdateContext.camera.centerCoordinate.latitude
                // lastLongitude = mapCameraUpdateContext.camera.centerCoordinate.longitude
                // print(lastDistance)
            }
        }
        .onAppear() {
            mapViewModel.checkLocationServiceEnabled()
            mapViewModel.locationManager?.startUpdatingLocation()
        }
        .onDisappear() {
            mapViewModel.locationManager?.stopUpdatingLocation()
        }
    }
    
    func searchKeyword(booth: BoothItem, keyword: String) -> Bool {
        let descriptionContainsKeyword = booth.description.contains(keyword)
        let nameContainsKeyword = booth.name.contains(keyword)
        
        return descriptionContainsKeyword || nameContainsKeyword
    }
    
    func makeBoundaries(coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D]? {
        // 위도 기준 정렬
        let sortedLatitudes = coordinates.sorted(by: { $0.latitude > $1.latitude })
        let padding: Double = 10
        
        // 위도가 가장 큰 값
        let maxItem: CLLocationCoordinate2D = sortedLatitudes[0]
        let maxLatitude = maxItem.latitude
        let maxLongitude = maxItem.longitude
        
        // maxLatitude가 첫 번째 값이 되도록 리스트를 조정
        var rearrangedCoordinate = coordinates
        if let maxIndex = rearrangedCoordinate.firstIndex(where: { $0.latitude == maxLatitude && $0.longitude == maxLongitude }) {
            rearrangedCoordinate.rotateLeft(amount: maxIndex)
            
            // 박스를 감싸는 5개의 점 추가
            let topCenterPoint = CLLocationCoordinate2D(latitude: maxLatitude + padding, longitude: maxLongitude)
            let topLeftPoint = CLLocationCoordinate2D(latitude: maxLatitude + padding, longitude: maxLongitude - padding)
            let bottomLeftPoint = CLLocationCoordinate2D(latitude: maxLatitude - padding, longitude: maxLongitude - padding)
            let bottomRightPoint = CLLocationCoordinate2D(latitude: maxLatitude - padding, longitude: maxLongitude + padding)
            let topRightPoint = CLLocationCoordinate2D(latitude: maxLatitude + padding, longitude: maxLongitude + padding)
            
            let boxCoordinates: [CLLocationCoordinate2D] = [maxItem, topCenterPoint, topRightPoint, bottomRightPoint, bottomLeftPoint, topLeftPoint, topCenterPoint]
            
            return boxCoordinates + rearrangedCoordinate
        } else {
            print("unknown error")
            return nil
        }
    }
    
    func clusterAnnotations(clusterRadius: Double, boothType: BoothType) -> [Cluster] {
        var clusters: [Cluster] = []
        
        let filteredBooths = boothModel.booths.filter({ $0.category == boothType.rawValue })
        
        for booth in filteredBooths {
            var isClustered = false
            
            var clusterId: Int = 0
            for cluster in clusters {
                let distance = calculateDistance(itemCoord: cluster.center, mvCoord: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude))
                
                if distance <= clusterRadius {
                    cluster.points.append(CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude))
                    cluster.boothIDList.append(booth.id)
                    isClustered = true
                    // print("store appended to cluster \(clusterId): \(distance)")
                    // cluster.updateCenter()
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
}

class Cluster: Identifiable {
    var id: UUID
    var center: CLLocationCoordinate2D
    var points: [CLLocationCoordinate2D]
    var type: BoothType
    var boothIDList: [Int]
    
    init(center: CLLocationCoordinate2D, points: [CLLocationCoordinate2D], type: BoothType) {
        self.id = UUID()
        self.center = center
        self.points = points
        self.type = type
        self.boothIDList = []
    }
    
    func updateCenter() {
        var latMean: CLLocationDegrees = 0
        var longMean: CLLocationDegrees = 0
        
        for point in points {
            latMean += point.latitude
            longMean += point.longitude
        }
        
        let newCenter = CLLocationCoordinate2D(latitude: latMean / Double(points.count), longitude: longMean / Double(points.count))
        print("center updated from: \(center) \nto: \(newCenter)")
        center = newCenter
    }
}

extension Array {
    mutating func rotateLeft(amount: Int) {
        let amount = amount % count
        self = Array(self[amount ..< count] + self[0 ..< amount])
    }
}

struct BoothAnnotation: View {
    let number: Int
    let boothType: BoothType
    // @State private var isSelected: Bool
    @State private var annotationSize: CGFloat = 50
    @State private var isSelected: Bool = false
    
    var body: some View {
        ZStack {
            switch boothType {
            case .drink:
                Image(isSelected ? .drinkBooth1 : .drinkBooth2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .toilet:
                Image(isSelected ? .toiletBooth1 : .toiletBooth2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .booth:
                Image(isSelected ? .generalBooth1 : .generalBooth2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .hospital:
                Image(isSelected ? .hospitalBooth1 : .hospitalBooth2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .food:
                Image(isSelected ? .foodBooth1 : .foodBooth2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .event:
                Image(isSelected ? .eventBooth1 : .eventBooth2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            }
            
            if number > 1 {
                HStack {
                    Spacer()
                    VStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                            .fill(.black)
                            .frame(width: 16, height: 16)
                            .overlay {
                                Text("\(number)")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                        Spacer()
                    }
                }
                .frame(width: 44, height: 49)
            }
        }
        .onChange(of: isSelected) {
            if isSelected {
                annotationSize = 70
            } else {
                annotationSize = 50
            }
        }
        /* .onTapGesture {
            withAnimation(.spring(duration: 0.2)) {
                isSelected.toggle()
                
                if isSelected {
                    annotationSize = 70
                } else {
                    annotationSize = 50
                }
            }
        }*/
    }
}

enum BoothType: String, CaseIterable {
    case drink = "BAR"
    case food = "FOOD"
    case event = "EVENT"
    case booth = "NORMAL"
    case hospital = "MEDICAL"
    case toilet = "TOILET"
}

//#Preview {
//    @ObservedObject var mapViewModel = MapViewModel()
//    @State var list: [Int] = []
//    @State var isPresented: Bool = false
//    @State var isFabPresented: Bool = false
//    
//    return Group {
//        MapView(mapViewModel: mapViewModel, boothModel: BoothModel(), isTagSelected: .constant([.drink: true, .food: true, .booth: true, .event: true, .hospital: true, .toilet: true]), searchText: .constant(""), selectedBoothIDList: $list, isBoothListPresented: $isPresented, isPopularBoothPresented: $isFabPresented)
//    }
//}

#Preview {
    TabView {
        MapPageView(mapViewModel: MapViewModel(), boothModel: BoothModel())
            .tabItem {
                Image(.tabMapSelected)
                Text("지도")
            }
    }
}
