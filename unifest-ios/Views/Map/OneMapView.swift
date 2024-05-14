//
//  OneMapView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/26/24.
//

import SwiftUI
import CoreLocation
import MapKit

struct OneMapView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @Environment(\.dismiss) private var dismiss
    let booth: BoothDetailItem?
    
    // let boothName: String
    // let boothLocation: String
    
    // 건국대학교 중심: 북 37.54263°, 동 127.07687°
    @State var mapCameraPosition = MapCameraPosition.camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 37.542_630, longitude: 127.076_870), distance: 4000, heading: 0.0, pitch: 0))
    
    // let mapCameraBounds: MapCameraBounds = MapCameraBounds(minimumDistance: 0, maximumDistance: 4000)
    let mapCameraBounds: MapCameraBounds = MapCameraBounds(centerCoordinateBounds: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.542_630, longitude: 127.076_870), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.01)), minimumDistance: 0, maximumDistance: 4000)
    
    let polygonKonkuk: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.54472, longitude: 127.07665),
        CLLocationCoordinate2D(latitude: 37.54458, longitude: 127.07498),
        CLLocationCoordinate2D(latitude: 37.54468, longitude: 127.07382),
        CLLocationCoordinate2D(latitude: 37.54444, longitude: 127.07287),
        CLLocationCoordinate2D(latitude: 37.54199, longitude: 127.07175),
        CLLocationCoordinate2D(latitude: 37.54176, longitude: 127.07246),
        CLLocationCoordinate2D(latitude: 37.54104, longitude: 127.07296),
        CLLocationCoordinate2D(latitude: 37.53956, longitude: 127.07225),
        CLLocationCoordinate2D(latitude: 37.53901, longitude: 127.07409),
        CLLocationCoordinate2D(latitude: 37.53884, longitude: 127.07443),
        CLLocationCoordinate2D(latitude: 37.53872, longitude: 127.07497),
        CLLocationCoordinate2D(latitude: 37.53933, longitude: 127.07514),
        CLLocationCoordinate2D(latitude: 37.53921, longitude: 127.07690),
        CLLocationCoordinate2D(latitude: 37.53999, longitude: 127.07722),
        CLLocationCoordinate2D(latitude: 37.54094, longitude: 127.07787),
        CLLocationCoordinate2D(latitude: 37.54108, longitude: 127.07827),
        CLLocationCoordinate2D(latitude: 37.54075, longitude: 127.07930),
        CLLocationCoordinate2D(latitude: 37.54075, longitude: 127.08073),
        CLLocationCoordinate2D(latitude: 37.54124, longitude: 127.08119),
        CLLocationCoordinate2D(latitude: 37.54198, longitude: 127.08133),
        CLLocationCoordinate2D(latitude: 37.54306, longitude: 127.08132),
        CLLocationCoordinate2D(latitude: 37.54320, longitude: 127.07944),
        CLLocationCoordinate2D(latitude: 37.54392, longitude: 127.07964),
        CLLocationCoordinate2D(latitude: 37.54428, longitude: 127.08001),
        CLLocationCoordinate2D(latitude: 37.54499, longitude: 127.07988),
        CLLocationCoordinate2D(latitude: 37.54484, longitude: 127.07782),
        CLLocationCoordinate2D(latitude: 37.54493, longitude: 127.07689),
        CLLocationCoordinate2D(latitude: 37.54490, longitude: 127.07661)
    ]
    
    // distance
    @State private var lastDistance: Double = 4000
    
    // last center
    @State private var lastLatitude: CLLocationDegrees = 37.542_630
    @State private var lastLongitude: CLLocationDegrees = 127.076_870
    
    @State private var isBoothSelected: [Bool] = [false, false, false]
    
    var body: some View {
        ZStack {
            Map(initialPosition: mapCameraPosition, bounds: mapCameraBounds) {
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
                                Text(booth.name)
                                    .font(.system(size: 20))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.black)
                                Text(booth.location)
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
        }
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

struct OneBoothAnnotation: View {
    let boothType: BoothType
    
    var body: some View {
        ZStack {
            switch boothType {
            case .drink:
                Image(.drinkBooth1)
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
                Image(.generalBooth1)
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
                Image(.eventBooth1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 1)
            }
        }
    }
}
