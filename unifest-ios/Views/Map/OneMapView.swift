//
//  OneMapView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/26/24.
//

import SwiftUI
import CoreLocation
import MapKit

// BoothDetailView에서 '위치 확인하기' 버튼을 누르면 fullscreencover로 뜨는 뷰

@available(iOS 17, *)
struct OneMapViewiOS17: View {
    @Namespace private var oneMap
    @Environment(\.colorScheme) var colorScheme
    
    @ObservedObject var viewModel: RootViewModel
    @Environment(\.dismiss) private var dismiss
    let booth: BoothDetailItem?
    
    // let boothName: String
    // let boothLocation: String
    
    // 건국대학교 중심: 북 37.54263°, 동 127.07687°
    @State var mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 37.012_100, longitude: 127.263_500), distance: 1500, heading: 0.0, pitch: 0))
    
    // let mapCameraBounds: MapCameraBounds = MapCameraBounds(minimumDistance: 0, maximumDistance: 4000)
    let mapCameraBoundsHankyong: MapCameraBounds = MapCameraBounds(centerCoordinateBounds: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.012_500, longitude: 127.263_000), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.01)), minimumDistance: 0, maximumDistance: 4000)
    
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
    
    let polygonHankyong: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.0125281, longitude: 127.2598307),
        CLLocationCoordinate2D(latitude: 37.0101251, longitude: 127.2631513),
        CLLocationCoordinate2D(latitude: 37.0095553, longitude: 127.2639023),
        CLLocationCoordinate2D(latitude: 37.0094097, longitude: 127.2642242),
        CLLocationCoordinate2D(latitude: 37.0096453, longitude: 127.264546),
        CLLocationCoordinate2D(latitude: 37.0098295, longitude: 127.2649537),
        CLLocationCoordinate2D(latitude: 37.0100737, longitude: 127.2654687),
        CLLocationCoordinate2D(latitude: 37.0102578, longitude: 127.2656458),
        CLLocationCoordinate2D(latitude: 37.010502, longitude: 127.2659032),
        CLLocationCoordinate2D(latitude: 37.0112431, longitude: 127.2661661),
        CLLocationCoordinate2D(latitude: 37.0113802, longitude: 127.2661862),
        CLLocationCoordinate2D(latitude: 37.0114947, longitude: 127.2661782),
        CLLocationCoordinate2D(latitude: 37.0122818, longitude: 127.2659301),
        CLLocationCoordinate2D(latitude: 37.0125174, longitude: 127.2658979),
        CLLocationCoordinate2D(latitude: 37.0127305, longitude: 127.2659019),
        CLLocationCoordinate2D(latitude: 37.0130015, longitude: 127.2659703),
        CLLocationCoordinate2D(latitude: 37.0130464, longitude: 127.2657544),
        CLLocationCoordinate2D(latitude: 37.0131846, longitude: 127.2654915),
        CLLocationCoordinate2D(latitude: 37.0132178, longitude: 127.2654245),
        CLLocationCoordinate2D(latitude: 37.0133816, longitude: 127.2649189),
        CLLocationCoordinate2D(latitude: 37.0135626, longitude: 127.2649269),
        CLLocationCoordinate2D(latitude: 37.0136301, longitude: 127.2645246),
        CLLocationCoordinate2D(latitude: 37.013629, longitude: 127.2643958),
        CLLocationCoordinate2D(latitude: 37.0134652, longitude: 127.2634343),
        CLLocationCoordinate2D(latitude: 37.0141269, longitude: 127.2632143),
        CLLocationCoordinate2D(latitude: 37.0140359, longitude: 127.262694),
        CLLocationCoordinate2D(latitude: 37.0139781, longitude: 127.2626028),
        CLLocationCoordinate2D(latitude: 37.013266, longitude: 127.2617921),
        CLLocationCoordinate2D(latitude: 37.0133602, longitude: 127.2616184),
        CLLocationCoordinate2D(latitude: 37.0133709, longitude: 127.2615789),
        CLLocationCoordinate2D(latitude: 37.0128826, longitude: 127.2611242),
        CLLocationCoordinate2D(latitude: 37.0128044, longitude: 127.2610478),
        CLLocationCoordinate2D(latitude: 37.0131423, longitude: 127.2604087),
        CLLocationCoordinate2D(latitude: 37.0125265, longitude: 127.2598301)
    ]
    
    var body: some View {
        ZStack {
            Map(initialPosition: mapCameraPosition, bounds: mapCameraBoundsHankyong, scope: oneMap) {
                UserAnnotation()
                
                if colorScheme == .dark {
                    MapPolygon(coordinates: polygonHankyong)
                        .foregroundStyle(.background.opacity(0.0))
                        .stroke(.white.opacity(0.8), lineWidth: 1.0)
                    
                    if let boxPolygon = makeBoundaries(coordinates: polygonHankyong) {
                        MapPolygon(coordinates: boxPolygon)
                            .foregroundStyle(.black.opacity(0.6))
                    }
                } else {
                    MapPolygon(coordinates: polygonHankyong)
                        .foregroundStyle(.background.opacity(0.0))
                        .stroke(.black.opacity(0.8), lineWidth: 1.0)
                    
                    if let boxPolygon = makeBoundaries(coordinates: polygonHankyong) {
                        MapPolygon(coordinates: boxPolygon)
                            .foregroundStyle(.gray.opacity(0.2))
                    }
                }
                
                if let booth = booth {
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude)) {
                        OneBoothAnnotation(boothType: stringToBoothType(booth.category))
                    }
                }
            }
            .controlSize(.mini)
            .mapStyle(.standard)
            .mapControls {
                //
            }
            .safeAreaPadding()
            .padding(.top, 30)
            
            VStack {
                HStack(alignment: .bottom) {
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(.background)
                .frame(height: 32)
                .overlay {
                    Image(.navBottom)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .offset(y: 32)
                }
                .overlay {
                    HStack(alignment: .bottom) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.darkGray)
                        }
                        .frame(width: 20, height: 32)
                        Spacer()
                        VStack(spacing: 0) {
                            if let booth = booth {
                                // MarqueeText(text: booth.name, font: .systemFont(ofSize: 20, weight: .semibold), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .center)
                                Text(booth.name)
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                                    .foregroundStyle(.defaultBlack)
                                Text(booth.location ?? "")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                                    .lineLimit(1)
                            }
                        }
                        .frame(height: 32)
                        Spacer()
                        Spacer()
                            .frame(width: 20)
                    }
                    .offset(y: 4)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            
            HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .trailing) {
                    Spacer()
                        .frame(height: 60)
                    
                    Group {
                        MapPitchToggle(scope: oneMap)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.defaultWhite)
                            )
                            .mapControlVisibility(.automatic)
                            .controlSize(.mini)
                        MapUserLocationButton(scope: oneMap)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.defaultWhite)
                            )
                            .mapControlVisibility(.automatic)
                            .controlSize(.mini)
                        
                        MapCompass(scope: oneMap)
                            .mapControlVisibility(.automatic)
                            .controlSize(.mini)
                    }
                    Spacer()
                }
                .frame(width: 60)
                .padding(.horizontal, 5)
            }
        }
        .dynamicTypeSize(.large)
        .mapScope(oneMap)
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

/* #Preview {
    @ObservedObject var mapViewModel = MapViewModel()
    
    return Group {
        OneMapView(mapViewModel: mapViewModel, booth:)
    }
}*/

@available(iOS 16, *)
struct OneMapViewiOS16: View {
    @Namespace private var oneMap
    @ObservedObject var viewModel: RootViewModel
    @Environment(\.dismiss) private var dismiss
    let booth: BoothDetailItem?
    
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
    
    let polygonHankyong: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.0125281, longitude: 127.2598307),
        CLLocationCoordinate2D(latitude: 37.0101251, longitude: 127.2631513),
        CLLocationCoordinate2D(latitude: 37.0095553, longitude: 127.2639023),
        CLLocationCoordinate2D(latitude: 37.0094097, longitude: 127.2642242),
        CLLocationCoordinate2D(latitude: 37.0096453, longitude: 127.264546),
        CLLocationCoordinate2D(latitude: 37.0098295, longitude: 127.2649537),
        CLLocationCoordinate2D(latitude: 37.0100737, longitude: 127.2654687),
        CLLocationCoordinate2D(latitude: 37.0102578, longitude: 127.2656458),
        CLLocationCoordinate2D(latitude: 37.010502, longitude: 127.2659032),
        CLLocationCoordinate2D(latitude: 37.0112431, longitude: 127.2661661),
        CLLocationCoordinate2D(latitude: 37.0113802, longitude: 127.2661862),
        CLLocationCoordinate2D(latitude: 37.0114947, longitude: 127.2661782),
        CLLocationCoordinate2D(latitude: 37.0122818, longitude: 127.2659301),
        CLLocationCoordinate2D(latitude: 37.0125174, longitude: 127.2658979),
        CLLocationCoordinate2D(latitude: 37.0127305, longitude: 127.2659019),
        CLLocationCoordinate2D(latitude: 37.0130015, longitude: 127.2659703),
        CLLocationCoordinate2D(latitude: 37.0130464, longitude: 127.2657544),
        CLLocationCoordinate2D(latitude: 37.0131846, longitude: 127.2654915),
        CLLocationCoordinate2D(latitude: 37.0132178, longitude: 127.2654245),
        CLLocationCoordinate2D(latitude: 37.0133816, longitude: 127.2649189),
        CLLocationCoordinate2D(latitude: 37.0135626, longitude: 127.2649269),
        CLLocationCoordinate2D(latitude: 37.0136301, longitude: 127.2645246),
        CLLocationCoordinate2D(latitude: 37.013629, longitude: 127.2643958),
        CLLocationCoordinate2D(latitude: 37.0134652, longitude: 127.2634343),
        CLLocationCoordinate2D(latitude: 37.0141269, longitude: 127.2632143),
        CLLocationCoordinate2D(latitude: 37.0140359, longitude: 127.262694),
        CLLocationCoordinate2D(latitude: 37.0139781, longitude: 127.2626028),
        CLLocationCoordinate2D(latitude: 37.013266, longitude: 127.2617921),
        CLLocationCoordinate2D(latitude: 37.0133602, longitude: 127.2616184),
        CLLocationCoordinate2D(latitude: 37.0133709, longitude: 127.2615789),
        CLLocationCoordinate2D(latitude: 37.0128826, longitude: 127.2611242),
        CLLocationCoordinate2D(latitude: 37.0128044, longitude: 127.2610478),
        CLLocationCoordinate2D(latitude: 37.0131423, longitude: 127.2604087),
        CLLocationCoordinate2D(latitude: 37.0125265, longitude: 127.2598301)
    ]
    
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.012_100, longitude: 127.263_500), span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
    
    var body: some View {
        ZStack {
            /* Map(initialPosition: mapCameraPosition, bounds: mapCameraBounds, scope: oneMap) {
                UserAnnotation()
                
                MapPolygon(coordinates: polygonKonkuk)
                    .foregroundStyle(.background.opacity(0.0))
                    .stroke(.black.opacity(0.8), lineWidth: 1.0)
                
                if let boxPolygon = makeBoundaries(coordinates: polygonKonkuk) {
                    MapPolygon(coordinates: boxPolygon)
                        .foregroundStyle(.gray.opacity(0.5))
                }
                
                if let booth = booth {
                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude)) {
                        OneBoothAnnotation(boothType: stringToBoothType(booth.category))
                    }
                }
            }
            .controlSize(.mini)
            .mapStyle(.standard)
            .mapControls {
                //
            }
            .safeAreaPadding()
            .padding(.top, 30) */
            
            if let booth = booth {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [booth]) { booth in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude)) {
                        OneBoothAnnotation(boothType: stringToBoothType(booth.category))
                    }
                }
                .padding(.top, 30)
            } else {
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .padding(.top, 30)
            }
            
            VStack {
                HStack(alignment: .bottom) {
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(.background)
                .frame(height: 32)
                .overlay {
                    Image(.navBottom)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .offset(y: 32)
                }
                .overlay {
                    HStack(alignment: .bottom) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.darkGray)
                        }
                        .frame(width: 20, height: 32)
                        Spacer()
                        VStack(spacing: 0) {
                            if let booth = booth {
                                Text(booth.name)
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.defaultBlack)
                                Text(booth.location ?? "")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                        }
                        .frame(height: 32)
                        Spacer()
                        Spacer()
                            .frame(width: 20)
                    }
                    .offset(y: 4)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            
            /* HStack(alignment: .center) {
                Spacer()
                VStack(alignment: .trailing) {
                    Spacer()
                        .frame(height: 60)
                    
                    Group {
                        MapPitchToggle(scope: oneMap)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white)
                            )
                            .mapControlVisibility(.automatic)
                            .controlSize(.mini)
                        MapUserLocationButton(scope: oneMap)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(.white)
                            )
                            .mapControlVisibility(.automatic)
                            .controlSize(.mini)
                        
                        MapCompass(scope: oneMap)
                            .mapControlVisibility(.automatic)
                            .controlSize(.mini)
                    }
                    Spacer()
                }
                .frame(width: 60)
                .padding(.horizontal, 5)
            }*/
        }
        .dynamicTypeSize(.large)
        // .mapScope(oneMap)
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

struct OneBoothAnnotation: View {
    let boothType: BoothType
    
    var body: some View {
        ZStack {
            switch boothType {
            case .drink:
//                Image(.drinkBooth1)
                Image(.activity1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .toilet:
                Image(.toiletBooth1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .booth:
//                Image(.generalBooth1)
                Image(.outsideSchool1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .hospital:
                Image(.hospitalBooth1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .food:
                Image(.foodBooth1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .event:
//                Image(.eventBooth1)
                Image(.insideSchool1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            }
        }
        .dynamicTypeSize(.large)
    }
}

#Preview {
    Group {
        RootView(rootViewModel: RootViewModel(), networkManager: NetworkManager())
        OneBoothAnnotation(boothType: .booth)
    }
}

