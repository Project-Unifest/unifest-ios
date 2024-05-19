//
//  MapView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/13/24.
//

import SwiftUI
import CoreLocation
import MapKit

@available(iOS 17, *)
struct MapViewiOS17: View {
    @Namespace private var mainMap
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel

    @Binding var searchText: String
    
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
    
    let personalBoothList: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.54376, longitude: 127.07689),
        CLLocationCoordinate2D(latitude: 37.54367, longitude: 127.07789),
        CLLocationCoordinate2D(latitude: 37.54374, longitude: 127.07791),
        CLLocationCoordinate2D(latitude: 37.54382, longitude: 127.07690)
    ]
    
    // distance
    @State private var lastDistance: Double = 4000
    
    @State private var isClustering: Bool = false
    
    // last center
    // @State private var lastLatitude: CLLocationDegrees = 37.542_630
    // @State private var lastLongitude: CLLocationDegrees = 127.076_870
    
    var body: some View {
        ZStack {
            Map(initialPosition: mapCameraPosition, bounds: mapCameraBounds, scope: mainMap) {
                UserAnnotation()
                
                if colorScheme == .dark {
                    MapPolygon(coordinates: polygonKonkuk)
                        .foregroundStyle(.background.opacity(0.0))
                        .stroke(.white.opacity(0.8), lineWidth: 1.0)
                    
                    if let boxPolygon = makeBoundaries(coordinates: polygonKonkuk) {
                        MapPolygon(coordinates: boxPolygon)
                            .foregroundStyle(.black.opacity(0.6))
                    }
                } else {
                    MapPolygon(coordinates: polygonKonkuk)
                        .foregroundStyle(.background.opacity(0.0))
                        .stroke(.black.opacity(0.8), lineWidth: 1.0)
                    
                    if let boxPolygon = makeBoundaries(coordinates: polygonKonkuk) {
                        MapPolygon(coordinates: boxPolygon)
                            .foregroundStyle(.gray.opacity(0.2))
                    }
                }
                
                ForEach(mapViewModel.annotationList, id: \.self) { annData in
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: annData.latitude, longitude: annData.longitude)) {
                        BoothAnnotation(mapViewModel: mapViewModel, annID: annData.id, boothType: annData.annType, number: annData.boothIDList.count)
                            .onTapGesture {
                                GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_BOOTH_ANNOTATION, params: ["boothID": annData.boothIDList[0]])
                                mapViewModel.setSelectedAnnotationID(annData.id)
                                viewModel.boothModel.updateMapSelectedBoothList(annData.boothIDList)
                                print("tab: \(annData.boothIDList[0])")
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
            .onChange(of: searchText) {
                mapViewModel.updateAnnotationList(makeCluster: isClustering, searchText: searchText)
            }
            .onChange(of: mapViewModel.isTagSelected) {
                mapViewModel.updateAnnotationList(makeCluster: isClustering, searchText: searchText)
            }
            .mapControls {
//                MapCompass()
//                MapPitchToggle()
//                MapUserLocationButton()
//                MapScaleView()
            }
            .controlSize(.mini)
            // .mapStyle(.standard)
            .safeAreaPadding()
            .onMapCameraChange { mapCameraUpdateContext in
                print("mapCam distance: \(mapCameraUpdateContext.camera.distance)")
                print("mapCam Center: (\(mapCameraUpdateContext.camera.centerCoordinate.latitude), \(mapCameraUpdateContext.camera.centerCoordinate.longitude))")
       
                // 비율이 달라진 경우에만 업데이트
                if (abs(lastDistance - mapCameraUpdateContext.camera.distance) > 0.1) {
                    print("last dist: \(lastDistance), new dist: \(mapCameraUpdateContext.camera.distance)")
                    let newDistance = mapCameraUpdateContext.camera.distance
                    
                    if newDistance > 1000 && lastDistance <= 1000 {
                        isClustering = UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP")
                        mapViewModel.updateAnnotationList(makeCluster: isClustering)
                    }
                    else if newDistance < 1000 && lastDistance >= 1000 {
                        // 1000 이상 -> 1000 미만
                        isClustering = false
                        mapViewModel.updateAnnotationList(makeCluster: false)
                    }
                    
                    lastDistance = newDistance
                }
                
                // lastLatitude = mapCameraUpdateContext.camera.centerCoordinate.latitude
                // lastLongitude = mapCameraUpdateContext.camera.centerCoordinate.longitude
            }
            
            
            HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .trailing) {
                    Spacer()
                        .frame(height: 140)
                    
                    Group {
                        MapPitchToggle(scope: mainMap)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.defaultWhite)
                            )
                            .mapControlVisibility(.automatic)
                            .controlSize(.mini)
                        MapUserLocationButton(scope: mainMap)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.defaultWhite)
                            )
                            .mapControlVisibility(.automatic)
                            .controlSize(.mini)
                        
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
        .mapScope(mainMap)
        .onAppear() {
            lastDistance = 3000
            mapViewModel.requestLocationAuthorization()
            mapViewModel.locationManager?.startUpdatingLocation()
            
            // 초기
            isClustering = UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP")
            mapViewModel.updateAnnotationList(makeCluster: isClustering)
        }
        .onDisappear() {
            mapViewModel.locationManager?.stopUpdatingLocation()
        }
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
        
        let filteredBooths = viewModel.boothModel.booths.filter({ $0.category == boothType.rawValue })
        
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
}

/* struct CustomMapView<AnnotationView: View>: UIViewRepresentable {
    @Binding var region: MKCoordinateRegion
    var annotationItems: [MapAnnotationData]
    var annotationContent: (MapAnnotationData) -> AnnotationView

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: CustomMapView

        init(parent: CustomMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            DispatchQueue.main.async {
                self.parent.region = mapView.region
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let customAnnotation = annotation as? CustomAnnotation else {
                return nil
            }
            let identifier = "customAnnotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: customAnnotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
            } else {
                annotationView?.annotation = customAnnotation
            }
            
            if let uiView = customAnnotation.view {
                annotationView?.addSubview(uiView)
                annotationView?.frame = uiView.frame
            }
            
            return annotationView
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if uiView.region.center.latitude != region.center.latitude || uiView.region.center.longitude != region.center.longitude || uiView.region.span.latitudeDelta != region.span.latitudeDelta || uiView.region.span.longitudeDelta != region.span.longitudeDelta {
            uiView.setRegion(region, animated: true)
        }

        // Remove existing annotations
        uiView.removeAnnotations(uiView.annotations)

        // Add new annotations
        let annotations = annotationItems.map { annotationItem -> CustomAnnotation in
            let annotation = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: annotationItem.latitude, longitude: annotationItem.longitude))
            annotation.view = UIHostingController(rootView: annotationContent(annotationItem)).view
            return annotation
        }
        uiView.addAnnotations(annotations)
    }
} */

@available(iOS 16, *)
struct MapViewiOS16: View {
    @Namespace private var mainMap
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    
    @Binding var searchText: String
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.542_634, longitude: 127.076_769), span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
    // @State private var coordinateSpan =
                                                             
    // distance
    @State private var lastDelta: CGFloat = 0.009
    
    @State private var isClustering: Bool = false
    
    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: mapViewModel.annotationList) { annotation in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: annotation.latitude, longitude: annotation.longitude)) {
                BoothAnnotation(mapViewModel: mapViewModel, annID: annotation.id, boothType: annotation.annType, number: annotation.boothIDList.count)
                    .onTapGesture {
                        handleAnnotationTap(annotation)
                    }
            }
        }
        .onChange(of: region.span.latitudeDelta) { newDelta in
            handleRegionDeltaChange(newDelta)
        }
        .onChange(of: searchText) { _ in
            handleSearchTextChange()
        }
        .onChange(of: mapViewModel.isTagSelected) { _ in
            handleTagSelectionChange()
        }
        .onAppear() {
            initializeMap()
        }
        .onDisappear() {
            mapViewModel.locationManager?.stopUpdatingLocation()
        }
    }
    
    private func initializeMap() {
        lastDelta = 0.009
        mapViewModel.requestLocationAuthorization()
        mapViewModel.locationManager?.startUpdatingLocation()
        
        isClustering = UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP")
        mapViewModel.updateAnnotationList(makeCluster: isClustering)
    }
    
    private func handleAnnotationTap(_ annotation: MapAnnotationData) {
        DispatchQueue.main.async {
            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_BOOTH_ANNOTATION, params: ["boothID": annotation.boothIDList[0]])
            mapViewModel.setSelectedAnnotationID(annotation.id)
            viewModel.boothModel.updateMapSelectedBoothList(annotation.boothIDList)
            withAnimation(.spring) {
                mapViewModel.isPopularBoothPresented = false
                mapViewModel.isBoothListPresented = true
            }
        }
    }
    
    private func handleRegionDeltaChange(_ newDelta: CGFloat) {
        DispatchQueue.main.async {
            if newDelta > 0.003 && lastDelta <= 0.003 {
                // isClustering = UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP")
                // mapViewModel.updateAnnotationList(makeCluster: isClustering)
                updateClusterAnnotation(true)
            } else if newDelta < 0.003 && lastDelta >= 0.003 {
                // isClustering = false
                // mapViewModel.updateAnnotationList(makeCluster: false)
                updateClusterAnnotation(false)
            }
            
            lastDelta = newDelta
        }
    }
    
    private func handleRegionChange(_ cameraRegion: MKCoordinateRegion) {
        let newDelta = cameraRegion.span.latitudeDelta
        if newDelta > 0.003 && lastDelta <= 0.003 {
            updateClusterAnnotation(true)
        } else if newDelta < 0.003 && lastDelta >= 0.003 {
            updateClusterAnnotation(false)
        }

        lastDelta = newDelta
        region = cameraRegion
    }
    
    private func handleSearchTextChange() {
        mapViewModel.updateAnnotationList(makeCluster: isClustering, searchText: searchText)
    }
    
    private func handleTagSelectionChange() {
        mapViewModel.updateAnnotationList(makeCluster: isClustering, searchText: searchText)
    }
    
    func updateClusterAnnotation(_ on: Bool) {
        if on {
            isClustering = UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP")
            mapViewModel.updateAnnotationList(makeCluster: isClustering)
        } else {
            isClustering = false
            mapViewModel.updateAnnotationList(makeCluster: false)
        }
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
            let annotationSize: CGFloat = (mapViewModel.selectedAnnotationID == self.annID ? 60 : 50)
            
            switch boothType {
            case .drink:
                Image(mapViewModel.selectedAnnotationID == self.annID ? .drinkBooth1 : .drinkBooth2)
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
                    .resizable()
                    .scaledToFit()
                    .frame(width: annotationSize, height: annotationSize)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            }
            
            if number > 1 {
                HStack {
                    Spacer()
                    VStack {
                        if #available(iOS 17, *) {
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
                        } else {
                            ZStack {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 16, height: 16)
                                Circle()
                                    .stroke(Color.white, lineWidth: 1)
                                    .frame(width: 16, height: 16)
                            }
                            .overlay {
                                Text("\(number)")
                                    .font(.system(size: 9))
                                    .foregroundStyle(.white)
                                    .bold()
                            }
                        }
                        Spacer()
                    }
                }
                .frame(width: 44, height: 49)
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
        return self.boothIDList
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

enum BoothType: String, CaseIterable {
    case drink = "BAR"
    case food = "FOOD"
    case event = "EVENT"
    case booth = "NORMAL"
    case hospital = "MEDICAL"
    case toilet = "TOILET"
}

#Preview {
    RootView(rootViewModel: RootViewModel())
}
