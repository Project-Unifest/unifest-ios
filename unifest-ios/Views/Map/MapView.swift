//
//  MapView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/13/24.
//
import CoreLocation
import MapKit
import SwiftUI

// MapPageView에서 보이는 지도 뷰

struct MapViewiOS17: View {
    @Namespace private var mainMap
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.scenePhase) var scenePhase
    
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @EnvironmentObject var tabSelect: TabSelect
    
    @State private var locationState = CLLocationManager().authorizationStatus // 사용자의 위치권한
    @State private var isLocationAuthNotPermittedAlertPresented: Bool = false
    @Binding var searchText: String
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var lastDistance: Double = 4000
    @State private var isClustering: Bool = false
    
    @State private var festivalMapDataIndex: Int = 1
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition, bounds: festivalMapDataList[festivalMapDataIndex].mapCameraBounds, scope: mainMap) {
                UserAnnotation()
                
                let polygon = festivalMapDataList[festivalMapDataIndex].polygonCoordinates
                
                if colorScheme == .dark {
                    MapPolygon(coordinates: polygon)
                        .foregroundStyle(.background.opacity(0.0))
                        .stroke(.white.opacity(0.8), lineWidth: 1.0)
                    
                    if let boxPolygon = makeBoundaries(coordinates: polygon) {
                        MapPolygon(coordinates: boxPolygon)
                            .foregroundStyle(.black.opacity(0.5))
                    }
                } else {
                    MapPolygon(coordinates: polygon)
                        .foregroundStyle(.background.opacity(0.0))
                        .stroke(.black.opacity(0.8), lineWidth: 1.0)
                    
                    if let boxPolygon = makeBoundaries(coordinates: polygon) {
                        MapPolygon(coordinates: boxPolygon)
                            .foregroundStyle(.gray.opacity(0.25))
                    }
                }
                
                ForEach(mapViewModel.annotationList, id: \.self) { annData in
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: annData.latitude, longitude: annData.longitude)) {
                        BoothAnnotation(mapViewModel: mapViewModel, annID: annData.id, boothType: annData.annType, number: annData.boothIDList.count)
                            .onTapGesture {
                                GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_BOOTH_ANNOTATION, params: ["boothID": annData.boothIDList[0]])
                                mapViewModel.setSelectedAnnotationID(annData.id)
                                viewModel.boothModel.updateMapSelectedBoothList(annData.boothIDList)
                                DispatchQueue.main.async {
                                    withAnimation(.spring) {
                                        mapViewModel.isPopularBoothPresented = false
                                        mapViewModel.isBoothListPresented = true
                                    }
                                }
                            }
                    }
                }
            }
            .onChange(of: festivalMapDataIndex) { newIndex in
                cameraPosition = festivalMapDataList[newIndex].mapCameraPosition
            }
            .onChange(of: searchText) {
                mapViewModel.updateAnnotationList(makeCluster: isClustering, searchText: searchText)
            }
            .onChange(of: mapViewModel.isTagSelected) {
                mapViewModel.updateAnnotationList(makeCluster: isClustering, searchText: searchText)
            }
            .mapControls {}
            .controlSize(.mini)
            .safeAreaPadding()
            .onMapCameraChange { mapCameraUpdateContext in
                if searchText.isEmpty { // 검색어가 있으면 지도 재렌더링 막음(이 조건 체크 안하면 검색어로 찾은 부스를 확대했을 때 지도 재렌더링 되면서 다른 annotation 다 나타남)
                    if abs(lastDistance - mapCameraUpdateContext.camera.distance) > 0.1 {
                        let newDistance = mapCameraUpdateContext.camera.distance
                        if newDistance > 500 && lastDistance <= 500 {
                            isClustering = UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP")
                            mapViewModel.updateAnnotationList(makeCluster: isClustering)
                        } else if newDistance < 500 && lastDistance >= 500 {
                            isClustering = false
                            mapViewModel.updateAnnotationList(makeCluster: false)
                        }
                        lastDistance = newDistance
                    }
                }
            }
            
            HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .trailing) {
                    Spacer().frame(height: 200)
                    Group {
                        MapPitchToggle(scope: mainMap)
                            .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.ufBackground))
                            .mapControlVisibility(.automatic)
                            .controlSize(.mini)
                        if locationState == .authorizedAlways || locationState == .authorizedWhenInUse {
                            MapUserLocationButton(scope: mainMap)
                                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(.ufBackground))
                                .mapControlVisibility(.automatic)
                                .controlSize(.mini)
                        } else {
                            Button(action: {
                                isLocationAuthNotPermittedAlertPresented = true
                            }) {
                                Image(systemName: "location")
                                    .foregroundColor(.primary500)
                                    .padding(13)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .foregroundColor(.ufBackground)
                                    )
                            }
                            .controlSize(.mini)
                        }
                        MapCompass(scope: mainMap)
                            .mapControlVisibility(.automatic)
                            .controlSize(.mini)
                    }
                    Spacer()
                }
                .frame(width: 60)
                .padding(.horizontal, 5)
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                locationState = CLLocationManager().authorizationStatus
                
            }
        }
        .alert("위치 권한 안내", isPresented: $isLocationAuthNotPermittedAlertPresented) {
            HStack {
                Button("닫기", role: .cancel) {}
                Button("설정하기", role: nil) {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
            }
        } message: {
            Text("현재 위치를 확인하려면 위치 권한을 허용해야돼요. 앱 설정에서 위치 권한을 수정할 수 있어요.")
        }
        .mapScope(mainMap)
        .task(id: mapViewModel.forceRefreshMapPageView) {
            festivalMapDataIndex = FestivalIdManager.festivalMapDataIndex
            let mapFestivalId = FestivalIdManager.mapFestivalId
            viewModel.boothModel.loadStoreListData(festivalId: mapFestivalId) {
                Task {
                    await MainActor.run {
                        mapViewModel.updateAnnotationList(makeCluster: isClustering)
                    }
                }
            }
            viewModel.boothModel.loadTop5Booth(festivalId: mapFestivalId)
        }
        .onAppear {
            lastDistance = 3000
            cameraPosition = festivalMapDataList[festivalMapDataIndex].mapCameraPosition
            mapViewModel.requestLocationAuthorization()
            mapViewModel.locationManager?.startUpdatingLocation()
            isClustering = UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP")
            mapViewModel.updateAnnotationList(makeCluster: isClustering)
            locationState = CLLocationManager().authorizationStatus
        }
        .onDisappear {
            mapViewModel.locationManager?.stopUpdatingLocation()
        }
    }
    
    func makeBoundaries(coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D]? {
        let sortedLatitudes = coordinates.sorted(by: { $0.latitude > $1.latitude })
        let padding: Double = 10
        let maxItem = sortedLatitudes[0]
        let maxLatitude = maxItem.latitude
        let maxLongitude = maxItem.longitude
        var rearrangedCoordinate = coordinates
        if let maxIndex = rearrangedCoordinate.firstIndex(where: { $0.latitude == maxLatitude && $0.longitude == maxLongitude }) {
            rearrangedCoordinate.rotateLeft(amount: maxIndex)
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
    
    func checkLocationAuthorization() {
        let status = CLLocationManager().authorizationStatus
        if status == .restricted || status == .denied || status == .notDetermined {
            isLocationAuthNotPermittedAlertPresented = true
        }
    }
    
    func clusterAnnotations(clusterRadius: Double, boothType: BoothType) -> [Cluster] {
        var clusters: [Cluster] = []
        let filteredBooths = viewModel.boothModel.booths.filter { $0.category == boothType.rawValue }
        for booth in filteredBooths {
            var isClustered = false
            for cluster in clusters {
                let distance = calculateDistance(itemCoord: cluster.center, mvCoord: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude))
                if distance <= clusterRadius {
                    cluster.points.append(CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude))
                    cluster.boothIDList.append(booth.id)
                    isClustered = true
                    cluster.updateCenter()
                    break
                }
            }
            if !isClustered {
                let newCluster = Cluster(center: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude), points: [CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude)], type: boothType)
                newCluster.boothIDList.append(booth.id)
                clusters.append(newCluster)
            }
        }
        return clusters
    }
    
    func stringToBoothType(_ typeString: String) -> BoothType {
        switch typeString {
        case BoothType.drink.rawValue: return .drink
        case BoothType.food.rawValue: return .food
        case BoothType.event.rawValue: return .event
        case BoothType.booth.rawValue: return .booth
        case BoothType.hospital.rawValue: return .hospital
        case BoothType.toilet.rawValue: return .toilet
        default: return .booth
        }
    }
}



class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var view: UIView?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        self.view = nil
    }
}

struct BoothAnnotation: View {
    @ObservedObject var mapViewModel: MapViewModel
    let annID: Int
    let boothType: BoothType
    let number: Int
    // let annotationSize: CGFloat = 50
    
    var body: some View {
        ZStack {
            //            let annotationSize: CGFloat = (mapViewModel.selectedAnnotationID == self.annID ? 60 : 50)
            let annotationSize: CGFloat = (mapViewModel.selectedAnnotationID == self.annID ? 50 : 40)
            
            switch boothType {
            case .drink:
                Image(mapViewModel.selectedAnnotationID == self.annID ? .drinkBooth1 : .drinkBooth2)
                //                Image(mapViewModel.selectedAnnotationID == self.annID ? .activity1 : .activity2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .toilet:
                Image(mapViewModel.selectedAnnotationID == self.annID ? .toiletBooth1 : .toiletBooth2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .booth:
                Image(mapViewModel.selectedAnnotationID == self.annID ? .generalBooth1 : .generalBooth2)
                //                Image(mapViewModel.selectedAnnotationID == self.annID ? .outsideSchool1 : .outsideSchool2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .hospital:
                Image(mapViewModel.selectedAnnotationID == self.annID ? .hospitalBooth1 : .hospitalBooth2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .food:
                Image(mapViewModel.selectedAnnotationID == self.annID ? .foodBooth1 : .foodBooth2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .event:
                Image(mapViewModel.selectedAnnotationID == self.annID ? .eventBooth1 : .eventBooth2)
                //                Image(mapViewModel.selectedAnnotationID == self.annID ? .insideSchool1 : .insideSchool2)
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
                                    .font(.system(size: 10))
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                        Spacer()
                    }
                }
                // .frame(width: 44, height: 49)
                .frame(width: 39, height: 44)
            }
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
    
    func getBoothIDList() -> [Int] {
        return boothIDList
    }
    
    func updateCenter() {
        var latMean: CLLocationDegrees = 0
        var longMean: CLLocationDegrees = 0
        
        for point in points {
            latMean += point.latitude
            longMean += point.longitude
        }
        
        let newCenter = CLLocationCoordinate2D(latitude: latMean / Double(points.count), longitude: longMean / Double(points.count))
        //        print("center updated from: \(center) \nto: \(newCenter)")
        center = newCenter
    }
}

extension Array {
    mutating func rotateLeft(amount: Int) {
        let amount = amount % count
        self = Array(self[amount ..< count] + self[0 ..< amount])
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

#Preview {
    Group {
        // MapViewiOS17(viewModel: RootViewModel(), mapViewModel: MapViewModel(viewModel: RootViewModel()), searchText: .constant("Search Text"))
    }
}
