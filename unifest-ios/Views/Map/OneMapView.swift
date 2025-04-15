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

//@available(iOS 17, *)
struct OneMapViewiOS17: View {
    @Namespace private var oneMap
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @Environment(\.dismiss) private var dismiss
    let booth: BoothDetailItem?
    
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition, bounds: festivalMapDataList[mapViewModel.festivalMapDataIndex].mapCameraBounds, scope: oneMap) {
                UserAnnotation()
                
                let polygon = festivalMapDataList[mapViewModel.festivalMapDataIndex].polygonCoordinates
                
                if colorScheme == .dark {
                    MapPolygon(coordinates: polygon)
                        .foregroundStyle(.background.opacity(0.0))
                        .stroke(.white.opacity(0.8), lineWidth: 1.0)
                    
                    if let boxPolygon = makeBoundaries(coordinates: polygon) {
                        MapPolygon(coordinates: boxPolygon)
                            .foregroundStyle(.black.opacity(0.6))
                    }
                } else {
                    MapPolygon(coordinates: polygon)
                        .foregroundStyle(.background.opacity(0.0))
                        .stroke(.black.opacity(0.8), lineWidth: 1.0)
                    
                    if let boxPolygon = makeBoundaries(coordinates: polygon) {
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
            .onAppear {
                cameraPosition = festivalMapDataList[mapViewModel.festivalMapDataIndex].mapCameraPosition
            }
            .onChange(of: mapViewModel.festivalMapDataIndex) { newIndex in
                cameraPosition = festivalMapDataList[newIndex].mapCameraPosition
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

//@available(iOS 16, *)
//struct OneMapViewiOS16: View {
//    @Namespace private var oneMap
//    @ObservedObject var viewModel: RootViewModel
//    @Environment(\.dismiss) private var dismiss
//    let booth: BoothDetailItem?
//    
//    // 건국대학교 중심
//    @State private var regionCenterKonkuk = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.542_634, longitude: 127.076_769), span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
//    
//    // 한경대학교 중심
//    @State private var regionCenterHankyong = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.012_315, longitude: 127.263_380), span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006))
//    
//    // 한국교통대학교 중심
//    @State private var regionCenterUOT = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 36.969_868, longitude: 127.871_726), span: MKCoordinateSpan(latitudeDelta: 0.006, longitudeDelta: 0.006))
//    
//    
//    var body: some View {
//        ZStack {
//            /* Map(initialPosition: mapCameraPosition, bounds: mapCameraBounds, scope: oneMap) {
//                UserAnnotation()
//                
//                MapPolygon(coordinates: polygonKonkuk)
//                    .foregroundStyle(.background.opacity(0.0))
//                    .stroke(.black.opacity(0.8), lineWidth: 1.0)
//                
//                if let boxPolygon = makeBoundaries(coordinates: polygonKonkuk) {
//                    MapPolygon(coordinates: boxPolygon)
//                        .foregroundStyle(.gray.opacity(0.5))
//                }
//                
//                if let booth = booth {
//                    Annotation("", coordinate: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude)) {
//                        OneBoothAnnotation(boothType: stringToBoothType(booth.category))
//                    }
//                }
//            }
//            .controlSize(.mini)
//            .mapStyle(.standard)
//            .mapControls {
//                //
//            }
//            .safeAreaPadding()
//            .padding(.top, 30) */
//            
//            if let booth = booth {
//                Map(coordinateRegion: $regionCenterKonkuk, showsUserLocation: true, annotationItems: [booth]) { booth in
//                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: booth.latitude, longitude: booth.longitude)) {
//                        OneBoothAnnotation(boothType: stringToBoothType(booth.category))
//                    }
//                }
//                .padding(.top, 30)
//            } else {
//                Map(coordinateRegion: $regionCenterKonkuk, showsUserLocation: true)
//                    .padding(.top, 30)
//            }
//            
//            VStack {
//                HStack(alignment: .bottom) {
//                    Spacer()
//                }
//                .padding(.horizontal)
//                .frame(maxWidth: .infinity)
//                .background(.background)
//                .frame(height: 32)
//                .overlay {
//                    Image(.navBottom)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(maxWidth: .infinity)
//                        .offset(y: 32)
//                }
//                .overlay {
//                    HStack(alignment: .bottom) {
//                        Button {
//                            dismiss()
//                        } label: {
//                            Image(systemName: "chevron.left")
//                                .foregroundColor(.darkGray)
//                        }
//                        .frame(width: 20, height: 32)
//                        Spacer()
//                        VStack(spacing: 0) {
//                            if let booth = booth {
//                                Text(booth.name)
//                                    .font(.system(size: 20))
//                                    .fontWeight(.semibold)
//                                    .foregroundStyle(.defaultBlack)
//                                Text(booth.location ?? "")
//                                    .font(.system(size: 12))
//                                    .foregroundStyle(.gray)
//                            }
//                        }
//                        .frame(height: 32)
//                        Spacer()
//                        Spacer()
//                            .frame(width: 20)
//                    }
//                    .offset(y: 4)
//                    .padding(.horizontal)
//                }
//                
//                Spacer()
//            }
//            
//            /* HStack(alignment: .center) {
//                Spacer()
//                VStack(alignment: .trailing) {
//                    Spacer()
//                        .frame(height: 60)
//                    
//                    Group {
//                        MapPitchToggle(scope: oneMap)
//                            .background(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .foregroundColor(.white)
//                            )
//                            .mapControlVisibility(.automatic)
//                            .controlSize(.mini)
//                        MapUserLocationButton(scope: oneMap)
//                            .background(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .foregroundColor(.white)
//                            )
//                            .mapControlVisibility(.automatic)
//                            .controlSize(.mini)
//                        
//                        MapCompass(scope: oneMap)
//                            .mapControlVisibility(.automatic)
//                            .controlSize(.mini)
//                    }
//                    Spacer()
//                }
//                .frame(width: 60)
//                .padding(.horizontal, 5)
//            }*/
//        }
//        .dynamicTypeSize(.large)
//        // .mapScope(oneMap)
//    }
//    
//    func stringToBoothType(_ typeString: String) -> BoothType {
//        switch typeString {
//        case BoothType.drink.rawValue:
//            return .drink
//        case BoothType.food.rawValue:
//            return .food
//        case BoothType.event.rawValue:
//            return .event
//        case BoothType.booth.rawValue:
//            return .booth
//        case BoothType.hospital.rawValue:
//            return .hospital
//        case BoothType.toilet.rawValue:
//            return .toilet
//        default:
//            return .booth
//        }
//    }
//    
//    func makeBoundaries(coordinates: [CLLocationCoordinate2D]) -> [CLLocationCoordinate2D]? {
//        // 위도 기준 정렬
//        let sortedLatitudes = coordinates.sorted(by: { $0.latitude > $1.latitude })
//        let padding: Double = 10
//        
//        // 위도가 가장 큰 값
//        let maxItem: CLLocationCoordinate2D = sortedLatitudes[0]
//        let maxLatitude = maxItem.latitude
//        let maxLongitude = maxItem.longitude
//        
//        // maxLatitude가 첫 번째 값이 되도록 리스트를 조정
//        var rearrangedCoordinate = coordinates
//        if let maxIndex = rearrangedCoordinate.firstIndex(where: { $0.latitude == maxLatitude && $0.longitude == maxLongitude }) {
//            rearrangedCoordinate.rotateLeft(amount: maxIndex)
//            
//            // 박스를 감싸는 5개의 점 추가
//            let topCenterPoint = CLLocationCoordinate2D(latitude: maxLatitude + padding, longitude: maxLongitude)
//            let topLeftPoint = CLLocationCoordinate2D(latitude: maxLatitude + padding, longitude: maxLongitude - padding)
//            let bottomLeftPoint = CLLocationCoordinate2D(latitude: maxLatitude - padding, longitude: maxLongitude - padding)
//            let bottomRightPoint = CLLocationCoordinate2D(latitude: maxLatitude - padding, longitude: maxLongitude + padding)
//            let topRightPoint = CLLocationCoordinate2D(latitude: maxLatitude + padding, longitude: maxLongitude + padding)
//            
//            let boxCoordinates: [CLLocationCoordinate2D] = [maxItem, topCenterPoint, topRightPoint, bottomRightPoint, bottomLeftPoint, topLeftPoint, topCenterPoint]
//            
//            return boxCoordinates + rearrangedCoordinate
//        } else {
//            print("unknown error")
//            return nil
//        }
//    }
//}

struct OneBoothAnnotation: View {
    let boothType: BoothType
    
    var body: some View {
        ZStack {
            switch boothType {
            case .drink:
                Image(.drinkBooth1)
//                Image(.activity1)
                    .resizable()
                    .scaledToFit()
//                    .frame(width: 70, height: 70)
                    .frame(width: 55, height: 55)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .toilet:
                Image(.toiletBooth1)
                    .resizable()
                    .scaledToFit()
//                    .frame(width: 70, height: 70)
                    .frame(width: 55, height: 55)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .booth:
                Image(.generalBooth1)
//                Image(.outsideSchool1)
                    .resizable()
                    .scaledToFit()
//                    .frame(width: 70, height: 70)
                    .frame(width: 55, height: 55)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .hospital:
                Image(.hospitalBooth1)
                    .resizable()
                    .scaledToFit()
//                    .frame(width: 70, height: 70)
                    .frame(width: 55, height: 55)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .food:
                Image(.foodBooth1)
                    .resizable()
                    .scaledToFit()
//                    .frame(width: 70, height: 70)
                    .frame(width: 55, height: 55)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            case .event:
                Image(.eventBooth1)
//                Image(.insideSchool1)
                    .resizable()
                    .scaledToFit()
//                    .frame(width: 70, height: 70)
                    .frame(width: 55, height: 55)
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

