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
    
    // 건국대학교 중심: 북 37.54263°, 동 127.07687°
    @State var mapCameraPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.542_630, longitude: 127.076_870), span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)))
    
    let polygonKonkuk = PolygonCoordinateList(data: [
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
    ])
    
    var body: some View {
        ZStack {
            Map(initialPosition: mapCameraPosition) {
                UserAnnotation()
                
                // Add School Boundaries
                if let boxCoordinate = makeBoundaries(coordinates: polygonKonkuk.data) {
                    MapPolygon(coordinates: boxCoordinate)
                        .foregroundStyle(.gray.opacity(0.5))
                }
                
                MapPolygon(coordinates: polygonKonkuk.data)
                    .foregroundStyle(.black.opacity(0.0))
                    .stroke(.black.opacity(0.8), lineWidth: 0.5)
            }
            // .ignoresSafeArea()
            .mapControls {
                MapCompass()
                MapPitchToggle()
                MapUserLocationButton()
            }
            .mapStyle(.standard)
        }
        .onAppear() {
            mapViewModel.checkLocationServiceEnabled()
            mapViewModel.locationManager?.startUpdatingLocation()
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
}

extension Array {
    mutating func rotateLeft(amount: Int) {
        let amount = amount % count
        self = Array(self[amount ..< count] + self[0 ..< amount])
    }
}

struct PolygonCoordinateList {
    var data: [CLLocationCoordinate2D]
}

struct MapPolygonAnnotation {
    var coordinates: [CLLocationCoordinate2D]
}

#Preview {
    @ObservedObject var mapViewModel = MapViewModel()
    
    return Group {
        MapView(mapViewModel: mapViewModel)
    }
}
