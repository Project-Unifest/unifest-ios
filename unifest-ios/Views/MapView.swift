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
    
    let polygonCoordinates: [CLLocationCoordinate2D] = [
        CLLocationCoordinate2D(latitude: 37.542_630, longitude: 127.076_870),
        CLLocationCoordinate2D(latitude: 37.542_630, longitude: 127.076_970),
        CLLocationCoordinate2D(latitude: 37.542_680, longitude: 127.077_020),
        CLLocationCoordinate2D(latitude: 37.542_730, longitude: 127.076_970),
        CLLocationCoordinate2D(latitude: 37.542_730, longitude: 127.076_870)
    ]
    
    var body: some View {
        ZStack {
            Map(initialPosition: mapCameraPosition) {
                UserAnnotation()
                
                MapPolygon(coordinates: polygonCoordinates)
                    .foregroundStyle(.red.opacity(0.1))
                    .stroke(.red, lineWidth: 1)
                
                // Add School Boundaries
                MapPolygon(coordinates: polygonKonkuk)
                    .foregroundStyle(.gray.opacity(0.0))
                    .stroke(.blue.opacity(0.5), lineWidth: 3)
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
