//
//  Extensions.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/14/24.
//

import Foundation
import CoreLocation

struct Coordinate {
    var latitude: Double
    var longitude: Double
}

extension Coordinate {
    // 두 좌표 간의 거리 (킬로미터) 계산
    func distance(to coordinate: Coordinate) -> Double {
        let earthRadiusKm: Double = 6371.0
        let lat1Rad = self.latitude * .pi / 180.0
        let lon1Rad = self.longitude * .pi / 180.0
        let lat2Rad = coordinate.latitude * .pi / 180.0
        let lon2Rad = coordinate.longitude * .pi / 180.0

        let dLat = lat2Rad - lat1Rad
        let dLon = lon2Rad - lon1Rad

        let a = sin(dLat / 2.0) * sin(dLat / 2.0) + cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2.0) * sin(dLon / 2.0)
        let c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))
        let distance = earthRadiusKm * c

        return distance
    }
}

func calculateDistance(itemCoord: CLLocationCoordinate2D, mvCoord: CLLocationCoordinate2D) -> Double {
    let coordinate1 = Coordinate(latitude: itemCoord.latitude, longitude: itemCoord.longitude)
    let coordinate2 = Coordinate(latitude: mvCoord.latitude, longitude: mvCoord.longitude)
    let distanceKm = coordinate1.distance(to: coordinate2)
    return distanceKm
}

extension CLLocationCoordinate2D {
    func distance(to coordinate: CLLocationCoordinate2D) -> Double {
        let earthRadiusKm: Double = 6371.0
        let lat1Rad = self.latitude * .pi / 180.0
        let lon1Rad = self.longitude * .pi / 180.0
        let lat2Rad = coordinate.latitude * .pi / 180.0
        let lon2Rad = coordinate.longitude * .pi / 180.0

        let dLat = lat2Rad - lat1Rad
        let dLon = lon2Rad - lon1Rad

        let a = sin(dLat / 2.0) * sin(dLat / 2.0) + cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2.0) * sin(dLon / 2.0)
        let c = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))
        let distance = earthRadiusKm * c * 1000

        return distance
    }
}

//class Cluster: Identifiable {
//    var id: UUID
//    var center: CLLocationCoordinate2D
//    var points: [CLLocationCoordinate2D]
//    
//    init(center: CLLocationCoordinate2D, points: [CLLocationCoordinate2D]) {
//        self.id = UUID()
//        self.center = center
//        self.points = points
//    }
//    
//    func updateCenter() {
//        var latMean: CLLocationDegrees = 0
//        var longMean: CLLocationDegrees = 0
//        
//        for point in points {
//            latMean += point.latitude
//            longMean += point.longitude
//        }
//        
//        var newCenter = CLLocationCoordinate2D(latitude: latMean / Double(points.count), longitude: longMean / Double(points.count))
//        print("center updated from: \(center) \nto: \(newCenter)")
//        center = newCenter
//    }
//}
