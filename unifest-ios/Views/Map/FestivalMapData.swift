//
//  SchoolCoordinates.swift
//  unifest-ios
//
//  Created by 임지성 on 4/14/25.
//

import Foundation
import CoreLocation
import MapKit
import _MapKit_SwiftUI // MapCameraBounds

struct FestivalMapData: Identifiable {
    var id = UUID()
    let festivalId: Int // festivalId
    let schoolName: String
    let mapCameraBounds: MapCameraBounds // 지도가 이동하거나 확대,축소할 수 있는 경계영역 지정(지도의 특정 범위 넘어서 이동하지 못하도록 제한)
    // span의 latitudeDelta, longitudeDelta의 비율이 적절해야 확대했을 때도 지도 상에서 원하는 위치로 이동 가능(비율이 맞지 않으면 확대한 상태에서 스크롤해도 원하는 위치로 이동하지 않는 문제가 발생할 수 있음)
    let mapCameraPosition: MapCameraPosition // 학교의 중심좌표
    let polygonCoordinates: [CLLocationCoordinate2D]
}

let festivalMapDataList: [FestivalMapData] = [
    FestivalMapData(
        festivalId: 1,
        schoolName: "건국대학교",
        mapCameraBounds: MapCameraBounds(
            centerCoordinateBounds: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.542_634, longitude: 127.076_769),
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.01)
            ),
            minimumDistance: 0,
            maximumDistance: 4000
        ),
        mapCameraPosition: MapCameraPosition.camera(MapCamera(
            centerCoordinate: CLLocationCoordinate2D(
                latitude: 37.542_634, longitude: 127.076_769
            ),
            distance: 3000,
            heading: 0.0,
            pitch: 0)
        ),
        polygonCoordinates: polygonKonkuk
    ),
//    FestivalMapData(
//        festivalId: 3,
//        schoolName: "한경대학교",
//        mapCameraBounds: MapCameraBounds(
//            centerCoordinateBounds: MKCoordinateRegion(
//                center: CLLocationCoordinate2D(latitude: 37.012_500, longitude: 127.263_000),
//                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.01)
//            ),
//            minimumDistance: 0,
//            maximumDistance: 4000
//        ),
//        mapCameraPosition: MapCameraPosition.camera(
//            MapCamera(
//                centerCoordinate: CLLocationCoordinate2D(
//                    latitude: 37.012_315, longitude: 127.263_380
//                ),
//                distance: 2000,
//                heading: 0.0,
//                pitch: 0
//            )
//        ),
//        polygonCoordinates: polygonHankyong
//    ),
    FestivalMapData(
        festivalId: 2,
        schoolName: "한국교통대학교",
        mapCameraBounds: MapCameraBounds(
            centerCoordinateBounds: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 36.969_868, longitude: 127.871_726),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            ),
            minimumDistance: 0,
            maximumDistance: 4000
        ),
        mapCameraPosition: MapCameraPosition.camera(
            MapCamera(
                centerCoordinate: CLLocationCoordinate2D(
                    latitude: 36.970_368, longitude: 127.871_726
                ),
                distance: 2500, // 클수록 축소
                heading: 0.0,
                pitch: 0
            )
        ),
        polygonCoordinates: polygonUOT
    ),
    FestivalMapData(
        festivalId: 13,
        schoolName: "고려대학교",
        mapCameraBounds: MapCameraBounds(
            centerCoordinateBounds: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.5886222, longitude: 127.0287418),
                span: MKCoordinateSpan(latitudeDelta: 0.012, longitudeDelta: 0.012)
            ),
            minimumDistance: 0,
            maximumDistance: 6000
        ),
        mapCameraPosition: MapCameraPosition.camera(
            MapCamera(
                centerCoordinate: CLLocationCoordinate2D(
                    latitude: 37.5892827, longitude: 127.0299920
                ),
                distance: 4200, // 클수록 축소
                heading: 0.0,
                pitch: 0
            )
        ),
        polygonCoordinates: polygonKorea
    ),
    FestivalMapData(
        festivalId: 14,
        schoolName: "상명대학교",
        mapCameraBounds: MapCameraBounds(
            centerCoordinateBounds: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.60280, longitude: 126.95527),
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            ),
            minimumDistance: 0,
            maximumDistance: 2500
        ),
        mapCameraPosition: MapCameraPosition.camera(
            MapCamera(
                centerCoordinate: CLLocationCoordinate2D(
                    latitude: 37.60280, longitude: 126.95527
                ),
                distance: 1600, // 클수록 축소
                heading: 0.0,
                pitch: 0
            )
        ),
        polygonCoordinates: polygonSangMyung
    ),
    FestivalMapData(
        festivalId: 15,
        schoolName: "가천대학교",
        mapCameraBounds: MapCameraBounds(
            centerCoordinateBounds: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 37.453094641743334, longitude: 127.13249210002502),
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            ),
            minimumDistance: 0,
            maximumDistance: 5000
        ),
        mapCameraPosition: MapCameraPosition.camera(
            MapCamera(
                centerCoordinate: CLLocationCoordinate2D(
                    latitude: 37.453094641743334, longitude: 127.13249210002502
                ),
                distance: 5000, // 클수록 축소
                heading: 0.0,
                pitch: 0
            )
        ),
        polygonCoordinates: polygonGachon
    )
]

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

let polygonUOT: [CLLocationCoordinate2D] = [
    CLLocationCoordinate2D(latitude: 36.9665013, longitude: 127.8746701),
    CLLocationCoordinate2D(latitude: 36.9697908, longitude: 127.8750296),
    CLLocationCoordinate2D(latitude: 36.970273, longitude: 127.8755821),
    CLLocationCoordinate2D(latitude: 36.9710187, longitude: 127.8758047),
    CLLocationCoordinate2D(latitude: 36.9712394, longitude: 127.8763143),
    CLLocationCoordinate2D(latitude: 36.9718673, longitude: 127.8762848),
    CLLocationCoordinate2D(latitude: 36.9723623, longitude: 127.8760488),
    CLLocationCoordinate2D(latitude: 36.9730073, longitude: 127.8750725),
    CLLocationCoordinate2D(latitude: 36.9735752, longitude: 127.8749035),
    CLLocationCoordinate2D(latitude: 36.9745373, longitude: 127.8718216),
    CLLocationCoordinate2D(latitude: 36.9749209, longitude: 127.8718511),
    CLLocationCoordinate2D(latitude: 36.9749573, longitude: 127.871717),
    CLLocationCoordinate2D(latitude: 36.9749423, longitude: 127.8714327),
    CLLocationCoordinate2D(latitude: 36.9748866, longitude: 127.8712932),
    CLLocationCoordinate2D(latitude: 36.9748759, longitude: 127.8710518),
    CLLocationCoordinate2D(latitude: 36.9748266, longitude: 127.8709875),
    CLLocationCoordinate2D(latitude: 36.9747516, longitude: 127.8709794),
    CLLocationCoordinate2D(latitude: 36.974503, longitude: 127.871202),
    CLLocationCoordinate2D(latitude: 36.9744816, longitude: 127.8713871),
    CLLocationCoordinate2D(latitude: 36.9742309, longitude: 127.871481),
    CLLocationCoordinate2D(latitude: 36.9738688, longitude: 127.8714676),
    CLLocationCoordinate2D(latitude: 36.9734873, longitude: 127.8712637),
    CLLocationCoordinate2D(latitude: 36.9734595, longitude: 127.8712047),
    CLLocationCoordinate2D(latitude: 36.9732323, longitude: 127.8709392),
    CLLocationCoordinate2D(latitude: 36.9727823, longitude: 127.870899),
    CLLocationCoordinate2D(latitude: 36.9726773, longitude: 127.8708185),
    CLLocationCoordinate2D(latitude: 36.9709823, longitude: 127.8689517),
    CLLocationCoordinate2D(latitude: 36.9708559, longitude: 127.8688551),
    CLLocationCoordinate2D(latitude: 36.9696494, longitude: 127.8683455),
    CLLocationCoordinate2D(latitude: 36.9691351, longitude: 127.8682275),
    CLLocationCoordinate2D(latitude: 36.9687129, longitude: 127.8682677),
    CLLocationCoordinate2D(latitude: 36.9678493, longitude: 127.867742),
    CLLocationCoordinate2D(latitude: 36.9675857, longitude: 127.8676401),
    CLLocationCoordinate2D(latitude: 36.9674914, longitude: 127.8676428),
    CLLocationCoordinate2D(latitude: 36.9667563, longitude: 127.8711806),
    CLLocationCoordinate2D(latitude: 36.9664756, longitude: 127.87246),
    CLLocationCoordinate2D(latitude: 36.9664906, longitude: 127.8746728)
]
let polygonKorea: [CLLocationCoordinate2D] = [
    CLLocationCoordinate2D(latitude: 37.5864637, longitude: 127.0306317),
    CLLocationCoordinate2D(latitude: 37.5865445, longitude: 127.0326487),
    CLLocationCoordinate2D(latitude: 37.5895158, longitude: 127.0356742),
    CLLocationCoordinate2D(latitude: 37.5904935, longitude: 127.0361141),
    CLLocationCoordinate2D(latitude: 37.592402, longitude: 127.0361785),
    CLLocationCoordinate2D(latitude: 37.59247, longitude: 127.0357171),
    CLLocationCoordinate2D(latitude: 37.5924573, longitude: 127.0355455),
    CLLocationCoordinate2D(latitude: 37.5915774, longitude: 127.034022),
    CLLocationCoordinate2D(latitude: 37.5911268, longitude: 127.0325253),
    CLLocationCoordinate2D(latitude: 37.5909568, longitude: 127.0316563),
    CLLocationCoordinate2D(latitude: 37.5912204, longitude: 127.0309482),
    CLLocationCoordinate2D(latitude: 37.5911523, longitude: 127.0305619),
    CLLocationCoordinate2D(latitude: 37.5912119, longitude: 127.0301435),
    CLLocationCoordinate2D(latitude: 37.5917644, longitude: 127.0293067),
    CLLocationCoordinate2D(latitude: 37.5921895, longitude: 127.0290599),
    CLLocationCoordinate2D(latitude: 37.592351, longitude: 127.0285449),
    CLLocationCoordinate2D(latitude: 37.5929036, longitude: 127.0282445),
    CLLocationCoordinate2D(latitude: 37.5929971, longitude: 127.027633),
    CLLocationCoordinate2D(latitude: 37.5930226, longitude: 127.0272896),
    CLLocationCoordinate2D(latitude: 37.5932266, longitude: 127.0270536),
    CLLocationCoordinate2D(latitude: 37.5937367, longitude: 127.0268283),
    CLLocationCoordinate2D(latitude: 37.5942553, longitude: 127.0266674),
    CLLocationCoordinate2D(latitude: 37.5945188, longitude: 127.0263562),
    CLLocationCoordinate2D(latitude: 37.5945528, longitude: 127.026088),
    CLLocationCoordinate2D(latitude: 37.5941958, longitude: 127.0253477),
    CLLocationCoordinate2D(latitude: 37.594013, longitude: 127.0252941),
    CLLocationCoordinate2D(latitude: 37.5935497, longitude: 127.0247791),
    CLLocationCoordinate2D(latitude: 37.5933202, longitude: 127.0245216),
    CLLocationCoordinate2D(latitude: 37.5928526, longitude: 127.0241461),
    CLLocationCoordinate2D(latitude: 37.5924785, longitude: 127.0239154),
    CLLocationCoordinate2D(latitude: 37.5921555, longitude: 127.0238189),
    CLLocationCoordinate2D(latitude: 37.5917772, longitude: 127.0238189),
    CLLocationCoordinate2D(latitude: 37.591367, longitude: 127.023784),
    CLLocationCoordinate2D(latitude: 37.591146, longitude: 127.0237679),
    CLLocationCoordinate2D(latitude: 37.5909951, longitude: 127.0237947),
    CLLocationCoordinate2D(latitude: 37.5907995, longitude: 127.0238484),
    CLLocationCoordinate2D(latitude: 37.5906401, longitude: 127.0239557),
    CLLocationCoordinate2D(latitude: 37.5905424, longitude: 127.0240978),
    CLLocationCoordinate2D(latitude: 37.5904637, longitude: 127.0243687),
    CLLocationCoordinate2D(latitude: 37.5904149, longitude: 127.0245136),
    CLLocationCoordinate2D(latitude: 37.5903107, longitude: 127.0246047),
    CLLocationCoordinate2D(latitude: 37.5902342, longitude: 127.0245913),
    CLLocationCoordinate2D(latitude: 37.5900737, longitude: 127.0245109),
    CLLocationCoordinate2D(latitude: 37.5899558, longitude: 127.0244961),
    CLLocationCoordinate2D(latitude: 37.589943, longitude: 127.0244941),
    CLLocationCoordinate2D(latitude: 37.5898899, longitude: 127.0245156),
    CLLocationCoordinate2D(latitude: 37.5897836, longitude: 127.0245806),
    CLLocationCoordinate2D(latitude: 37.5895137, longitude: 127.0248502),
    CLLocationCoordinate2D(latitude: 37.5892714, longitude: 127.0251157),
    CLLocationCoordinate2D(latitude: 37.5890525, longitude: 127.0251828),
    CLLocationCoordinate2D(latitude: 37.5889685, longitude: 127.0252257),
    CLLocationCoordinate2D(latitude: 37.5889281, longitude: 127.0252632),
    CLLocationCoordinate2D(latitude: 37.588925, longitude: 127.0252793),
    CLLocationCoordinate2D(latitude: 37.5889058, longitude: 127.0253638),
    CLLocationCoordinate2D(latitude: 37.5888729, longitude: 127.0254926),
    CLLocationCoordinate2D(latitude: 37.5888484, longitude: 127.0255784),
    CLLocationCoordinate2D(latitude: 37.5887974, longitude: 127.0256696),
    CLLocationCoordinate2D(latitude: 37.5887411, longitude: 127.0257393),
    CLLocationCoordinate2D(latitude: 37.5886497, longitude: 127.0257956),
    CLLocationCoordinate2D(latitude: 37.5883256, longitude: 127.0259351),
    CLLocationCoordinate2D(latitude: 37.5881194, longitude: 127.0260102),
    CLLocationCoordinate2D(latitude: 37.5878304, longitude: 127.025852),
    CLLocationCoordinate2D(latitude: 37.5874117, longitude: 127.0255784),
    CLLocationCoordinate2D(latitude: 37.5870716, longitude: 127.0254577),
    CLLocationCoordinate2D(latitude: 37.5869143, longitude: 127.0254175),
    CLLocationCoordinate2D(latitude: 37.586553, longitude: 127.0253504),
    CLLocationCoordinate2D(latitude: 37.5862193, longitude: 127.024712),
    CLLocationCoordinate2D(latitude: 37.5858962, longitude: 127.0244224),
    CLLocationCoordinate2D(latitude: 37.5854116, longitude: 127.0244063),
    CLLocationCoordinate2D(latitude: 37.585029, longitude: 127.0238966),
    CLLocationCoordinate2D(latitude: 37.5846336, longitude: 127.0238376),
    CLLocationCoordinate2D(latitude: 37.5841363, longitude: 127.024138),
    CLLocationCoordinate2D(latitude: 37.5837324, longitude: 127.0242185),
    CLLocationCoordinate2D(latitude: 37.5835071, longitude: 127.0243633),
    CLLocationCoordinate2D(latitude: 37.5835624, longitude: 127.0246638),
    CLLocationCoordinate2D(latitude: 37.5831585, longitude: 127.0248354),
    CLLocationCoordinate2D(latitude: 37.5830352, longitude: 127.0251948),
    CLLocationCoordinate2D(latitude: 37.5826101, longitude: 127.0258386),
    CLLocationCoordinate2D(latitude: 37.5824443, longitude: 127.0260853),
    CLLocationCoordinate2D(latitude: 37.5821978, longitude: 127.026257),
    CLLocationCoordinate2D(latitude: 37.5819384, longitude: 127.0261229),
    CLLocationCoordinate2D(latitude: 37.5817301, longitude: 127.0261497),
    CLLocationCoordinate2D(latitude: 37.5816536, longitude: 127.0263643),
    CLLocationCoordinate2D(latitude: 37.5816876, longitude: 127.0265145),
    CLLocationCoordinate2D(latitude: 37.5817939, longitude: 127.0266647),
    CLLocationCoordinate2D(latitude: 37.5821552, longitude: 127.0267237),
    CLLocationCoordinate2D(latitude: 37.5822743, longitude: 127.0269383),
    CLLocationCoordinate2D(latitude: 37.5823763, longitude: 127.0276517),
    CLLocationCoordinate2D(latitude: 37.5826186, longitude: 127.0278502),
    CLLocationCoordinate2D(latitude: 37.5825208, longitude: 127.0281721),
    CLLocationCoordinate2D(latitude: 37.5825804, longitude: 127.0282526),
    CLLocationCoordinate2D(latitude: 37.5827462, longitude: 127.0280433),
    CLLocationCoordinate2D(latitude: 37.5833498, longitude: 127.0281184),
    CLLocationCoordinate2D(latitude: 37.5833923, longitude: 127.0285208),
    CLLocationCoordinate2D(latitude: 37.5836091, longitude: 127.0288507),
    CLLocationCoordinate2D(latitude: 37.5853946, longitude: 127.02884),
    CLLocationCoordinate2D(latitude: 37.5854371, longitude: 127.0285315),
    CLLocationCoordinate2D(latitude: 37.5854626, longitude: 127.0284913),
    CLLocationCoordinate2D(latitude: 37.5858282, longitude: 127.0285261),
    CLLocationCoordinate2D(latitude: 37.5860003, longitude: 127.027979),
    CLLocationCoordinate2D(latitude: 37.5861491, longitude: 127.0279334),
    CLLocationCoordinate2D(latitude: 37.5864127, longitude: 127.0283464),
    CLLocationCoordinate2D(latitude: 37.5866465, longitude: 127.0286951),
    CLLocationCoordinate2D(latitude: 37.5873862, longitude: 127.0286576),
    CLLocationCoordinate2D(latitude: 37.5882278, longitude: 127.0287058),
    CLLocationCoordinate2D(latitude: 37.5886954, longitude: 127.0278314),
    CLLocationCoordinate2D(latitude: 37.5898134, longitude: 127.027354),
    CLLocationCoordinate2D(latitude: 37.5905402, longitude: 127.0274774),
    CLLocationCoordinate2D(latitude: 37.5908505, longitude: 127.0276705),
    CLLocationCoordinate2D(latitude: 37.5908973, longitude: 127.0280192),
    CLLocationCoordinate2D(latitude: 37.5907825, longitude: 127.0282767),
    CLLocationCoordinate2D(latitude: 37.590519, longitude: 127.0301596),
    CLLocationCoordinate2D(latitude: 37.59035, longitude: 127.030393),
    CLLocationCoordinate2D(latitude: 37.5904191, longitude: 127.0304332),
    CLLocationCoordinate2D(latitude: 37.5905275, longitude: 127.0305525),
    CLLocationCoordinate2D(latitude: 37.5908176, longitude: 127.0308637),
    CLLocationCoordinate2D(latitude: 37.590842, longitude: 127.0308704),
    CLLocationCoordinate2D(latitude: 37.5910912, longitude: 127.0307919),
    CLLocationCoordinate2D(latitude: 37.5911486, longitude: 127.0308241),
    CLLocationCoordinate2D(latitude: 37.5911794, longitude: 127.0308885),
    CLLocationCoordinate2D(latitude: 37.5911922, longitude: 127.0309502),
    CLLocationCoordinate2D(latitude: 37.5910392, longitude: 127.0313069),
    CLLocationCoordinate2D(latitude: 37.5909945, longitude: 127.0313565),
    CLLocationCoordinate2D(latitude: 37.5909212, longitude: 127.0313659),
    CLLocationCoordinate2D(latitude: 37.5908617, longitude: 127.0313391),
    CLLocationCoordinate2D(latitude: 37.5902677, longitude: 127.0309475),
    CLLocationCoordinate2D(latitude: 37.5900913, longitude: 127.0306095),
    CLLocationCoordinate2D(latitude: 37.5901423, longitude: 127.0304808),
    CLLocationCoordinate2D(latitude: 37.5898553, longitude: 127.0303091),
    CLLocationCoordinate2D(latitude: 37.5896556, longitude: 127.0304111),
    CLLocationCoordinate2D(latitude: 37.5895429, longitude: 127.030454),
    CLLocationCoordinate2D(latitude: 37.5892666, longitude: 127.0303172),
    CLLocationCoordinate2D(latitude: 37.5885344, longitude: 127.0303507),
    CLLocationCoordinate2D(latitude: 37.5883006, longitude: 127.0303802),
    CLLocationCoordinate2D(latitude: 37.5882028, longitude: 127.0305331),
    CLLocationCoordinate2D(latitude: 37.587952, longitude: 127.0305572),
    CLLocationCoordinate2D(latitude: 37.5878075, longitude: 127.0303936),
    CLLocationCoordinate2D(latitude: 37.5873824, longitude: 127.0304204),
    CLLocationCoordinate2D(latitude: 37.5868532, longitude: 127.0299162),
    CLLocationCoordinate2D(latitude: 37.586443, longitude: 127.030179),
    CLLocationCoordinate2D(latitude: 37.5864579, longitude: 127.0306216)
]
let polygonSangMyung: [CLLocationCoordinate2D] = [
    CLLocationCoordinate2D(latitude: 37.6013767, longitude: 126.9533132),
    CLLocationCoordinate2D(latitude: 37.6014298, longitude: 126.9534447),
    CLLocationCoordinate2D(latitude: 37.6016954, longitude: 126.9530584),
    CLLocationCoordinate2D(latitude: 37.6020864, longitude: 126.9526373),
    CLLocationCoordinate2D(latitude: 37.6024137, longitude: 126.9525864),
    CLLocationCoordinate2D(latitude: 37.6026687, longitude: 126.9528465),
    CLLocationCoordinate2D(latitude: 37.6028557, longitude: 126.9529753),
    CLLocationCoordinate2D(latitude: 37.6031, longitude: 126.9532757),
    CLLocationCoordinate2D(latitude: 37.603304, longitude: 126.9533535),
    CLLocationCoordinate2D(latitude: 37.6034783, longitude: 126.9534769),
    CLLocationCoordinate2D(latitude: 37.6036908, longitude: 126.9535627),
    CLLocationCoordinate2D(latitude: 37.6040903, longitude: 126.9536619),
    CLLocationCoordinate2D(latitude: 37.6041625, longitude: 126.9539033),
    CLLocationCoordinate2D(latitude: 37.6041753, longitude: 126.9540267),
    CLLocationCoordinate2D(latitude: 37.6041625, longitude: 126.9545176),
    CLLocationCoordinate2D(latitude: 37.6041285, longitude: 126.9548206),
    CLLocationCoordinate2D(latitude: 37.6041668, longitude: 126.9550084),
    CLLocationCoordinate2D(latitude: 37.6043793, longitude: 126.9551881),
    CLLocationCoordinate2D(latitude: 37.6042837, longitude: 126.9554027),
    CLLocationCoordinate2D(latitude: 37.6040435, longitude: 126.9556038),
    CLLocationCoordinate2D(latitude: 37.6039245, longitude: 126.9556119),
    CLLocationCoordinate2D(latitude: 37.6038937, longitude: 126.9557205),
    CLLocationCoordinate2D(latitude: 37.6041126, longitude: 126.9559485),
    CLLocationCoordinate2D(latitude: 37.6043899, longitude: 126.9566754),
    CLLocationCoordinate2D(latitude: 37.6045089, longitude: 126.9567693),
    CLLocationCoordinate2D(latitude: 37.6045429, longitude: 126.956831),
    CLLocationCoordinate2D(latitude: 37.6044664, longitude: 126.9569919),
    CLLocationCoordinate2D(latitude: 37.6044685, longitude: 126.9570455),
    CLLocationCoordinate2D(latitude: 37.6044738, longitude: 126.9570683),
    CLLocationCoordinate2D(latitude: 37.6044143, longitude: 126.9571609),
    CLLocationCoordinate2D(latitude: 37.6037928, longitude: 126.9575458),
    CLLocationCoordinate2D(latitude: 37.603491, longitude: 126.9575029),
    CLLocationCoordinate2D(latitude: 37.6033317, longitude: 126.9575672),
    CLLocationCoordinate2D(latitude: 37.6032594, longitude: 126.9572722),
    CLLocationCoordinate2D(latitude: 37.6031595, longitude: 126.9571998),
    CLLocationCoordinate2D(latitude: 37.6030735, longitude: 126.9570777),
    CLLocationCoordinate2D(latitude: 37.6029555, longitude: 126.9570013),
    CLLocationCoordinate2D(latitude: 37.6028408, longitude: 126.9569275),
    CLLocationCoordinate2D(latitude: 37.6027165, longitude: 126.9568819),
    CLLocationCoordinate2D(latitude: 37.6026538, longitude: 126.9568994),
    CLLocationCoordinate2D(latitude: 37.6025762, longitude: 126.956729),
    CLLocationCoordinate2D(latitude: 37.6025699, longitude: 126.956501),
    CLLocationCoordinate2D(latitude: 37.6026708, longitude: 126.9564125),
    CLLocationCoordinate2D(latitude: 37.6026017, longitude: 126.9562355),
    CLLocationCoordinate2D(latitude: 37.6022607, longitude: 126.9565212),
    CLLocationCoordinate2D(latitude: 37.601961, longitude: 126.9565547),
    CLLocationCoordinate2D(latitude: 37.6019408, longitude: 126.9565131),
    CLLocationCoordinate2D(latitude: 37.6019515, longitude: 126.9564756),
    CLLocationCoordinate2D(latitude: 37.6016965, longitude: 126.9563441),
    CLLocationCoordinate2D(latitude: 37.6017868, longitude: 126.9559512),
    CLLocationCoordinate2D(latitude: 37.6019865, longitude: 126.9554603),
    CLLocationCoordinate2D(latitude: 37.6019993, longitude: 126.9554067),
    CLLocationCoordinate2D(latitude: 37.6019918, longitude: 126.9553477),
    CLLocationCoordinate2D(latitude: 37.6019483, longitude: 126.9552297),
    CLLocationCoordinate2D(latitude: 37.6017942, longitude: 126.9549226),
    CLLocationCoordinate2D(latitude: 37.6014393, longitude: 126.9554483),
    CLLocationCoordinate2D(latitude: 37.6005192, longitude: 126.9545095),
    CLLocationCoordinate2D(latitude: 37.6004661, longitude: 126.9544854),
    CLLocationCoordinate2D(latitude: 37.6004299, longitude: 126.9544746),
    CLLocationCoordinate2D(latitude: 37.6004639, longitude: 126.954126),
    CLLocationCoordinate2D(latitude: 37.6006169, longitude: 126.9540079),
    CLLocationCoordinate2D(latitude: 37.6007211, longitude: 126.9535868),
    CLLocationCoordinate2D(latitude: 37.6009315, longitude: 126.9535037),
    CLLocationCoordinate2D(latitude: 37.6013735, longitude: 126.9533159)
]

let polygonGachon = [
    CLLocationCoordinate2D(latitude: 37.4529793, longitude: 127.1268656),
    CLLocationCoordinate2D(latitude: 37.4530049, longitude: 127.1275227),
    CLLocationCoordinate2D(latitude: 37.4530134, longitude: 127.1279438),
    CLLocationCoordinate2D(latitude: 37.4529368, longitude: 127.127968),
    CLLocationCoordinate2D(latitude: 37.4528622, longitude: 127.127917),
    CLLocationCoordinate2D(latitude: 37.4527302, longitude: 127.1277292),
    CLLocationCoordinate2D(latitude: 37.4526493, longitude: 127.1276783),
    CLLocationCoordinate2D(latitude: 37.4526174, longitude: 127.1276971),
    CLLocationCoordinate2D(latitude: 37.4527409, longitude: 127.1284829),
    CLLocationCoordinate2D(latitude: 37.4529943, longitude: 127.129006),
    CLLocationCoordinate2D(latitude: 37.4532817, longitude: 127.1294941),
    CLLocationCoordinate2D(latitude: 37.4532924, longitude: 127.1304088),
    CLLocationCoordinate2D(latitude: 37.4529559, longitude: 127.1312108),
    CLLocationCoordinate2D(latitude: 37.4529368, longitude: 127.132584),
    CLLocationCoordinate2D(latitude: 37.4534137, longitude: 127.1335657),
    CLLocationCoordinate2D(latitude: 37.4538907, longitude: 127.1330347),
    CLLocationCoordinate2D(latitude: 37.4541717, longitude: 127.1325197),
    CLLocationCoordinate2D(latitude: 37.45467, longitude: 127.1322085),
    CLLocationCoordinate2D(latitude: 37.4548999, longitude: 127.1321549),
    CLLocationCoordinate2D(latitude: 37.4549212, longitude: 127.1320154),
    CLLocationCoordinate2D(latitude: 37.4554322, longitude: 127.1320583),
    CLLocationCoordinate2D(latitude: 37.4557005, longitude: 127.1320101),
    CLLocationCoordinate2D(latitude: 37.4559177, longitude: 127.1321227),
    CLLocationCoordinate2D(latitude: 37.4560156, longitude: 127.1322622),
    CLLocationCoordinate2D(latitude: 37.4561051, longitude: 127.1330347),
    CLLocationCoordinate2D(latitude: 37.4562115, longitude: 127.1331473),
    CLLocationCoordinate2D(latitude: 37.4566672, longitude: 127.1354808),
    CLLocationCoordinate2D(latitude: 37.4565777, longitude: 127.1357169),
    CLLocationCoordinate2D(latitude: 37.4561093, longitude: 127.1358563),
    CLLocationCoordinate2D(latitude: 37.4560242, longitude: 127.1362318),
    CLLocationCoordinate2D(latitude: 37.4559858, longitude: 127.1363016),
    CLLocationCoordinate2D(latitude: 37.4559816, longitude: 127.1366986),
    CLLocationCoordinate2D(latitude: 37.4568588, longitude: 127.1379806),
    CLLocationCoordinate2D(latitude: 37.4562924, longitude: 127.1380879),
    CLLocationCoordinate2D(latitude: 37.4557942, longitude: 127.1382274),
    CLLocationCoordinate2D(latitude: 37.4552193, longitude: 127.138383),
    CLLocationCoordinate2D(latitude: 37.4546018, longitude: 127.1386619),
    CLLocationCoordinate2D(latitude: 37.4539673, longitude: 127.1367415),
    CLLocationCoordinate2D(latitude: 37.4532774, longitude: 127.1353467),
    CLLocationCoordinate2D(latitude: 37.4530943, longitude: 127.1349927),
    CLLocationCoordinate2D(latitude: 37.4529453, longitude: 127.134821),
    CLLocationCoordinate2D(latitude: 37.4525194, longitude: 127.1343865),
    CLLocationCoordinate2D(latitude: 37.4517231, longitude: 127.1330078),
    CLLocationCoordinate2D(latitude: 37.4516123, longitude: 127.1320798),
    CLLocationCoordinate2D(latitude: 37.4508841, longitude: 127.1313878),
    CLLocationCoordinate2D(latitude: 37.4504668, longitude: 127.1310874),
    CLLocationCoordinate2D(latitude: 37.4500771, longitude: 127.1308084),
    CLLocationCoordinate2D(latitude: 37.4495362, longitude: 127.1303739),
    CLLocationCoordinate2D(latitude: 37.4492828, longitude: 127.1301271),
    CLLocationCoordinate2D(latitude: 37.4491955, longitude: 127.1299448),
    CLLocationCoordinate2D(latitude: 37.4485823, longitude: 127.130154),
    CLLocationCoordinate2D(latitude: 37.4481649, longitude: 127.1287485),
    CLLocationCoordinate2D(latitude: 37.4489528, longitude: 127.1283944),
    CLLocationCoordinate2D(latitude: 37.4489741, longitude: 127.1273752),
    CLLocationCoordinate2D(latitude: 37.4490635, longitude: 127.1270962),
    CLLocationCoordinate2D(latitude: 37.4490976, longitude: 127.1269085),
    CLLocationCoordinate2D(latitude: 37.4493808, longitude: 127.1269112),
    CLLocationCoordinate2D(latitude: 37.4493744, longitude: 127.1269675),
    CLLocationCoordinate2D(latitude: 37.4504753, longitude: 127.1269621),
    CLLocationCoordinate2D(latitude: 37.4529767, longitude: 127.1268656)

]
