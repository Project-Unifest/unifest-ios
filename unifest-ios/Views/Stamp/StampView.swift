//
//  StampView.swift
//  unifest-ios
//
//  Created by 임지성 on 8/30/24.
//

import AVFoundation
import CodeScanner
import SwiftUI

struct StampView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @EnvironmentObject var stampVM: StampViewModel
    @EnvironmentObject var networkManager: NetworkManager
    @State private var rotationAmount = 0.0
    @State private var isStampDropdownPresented = false
    @State private var isStampBoothViewPresented = false
    @State private var isStampQRScanViewPresented = false
    @State private var addStampToast: Toast? = nil
    @State private var isCameraPermissionAlertPresented = false
    @State private var isCameraAuthorized = false
    @State private var isFetchingStampInfo = false // 처음 스탬프 화면이 로딩될 때 progressview
    @State private var isUpdatingStampInfo = false // '새로고침'을 누르거나 드롭다운에서 축제를 탭했을 때 progressview
    @State private var throttleManager = ThrottleManager(throttleInterval: 1.5)
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("스탬프")
                        .font(.pretendard(weight: .p6, size: 21))
                        .foregroundStyle(.grey900)
                    
                    Spacer()
                }
                .padding()
                
                if isFetchingStampInfo {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else if stampVM.stampEnabledFestivals == nil || stampVM.stampEnabledFestivals?.isEmpty == true {
                    VStack {
                        GeometryReader { geometry in
                            let screenWidth = geometry.size.width
                            
                            HStack {
                                Spacer()
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.ufBoxBackground)
                                    .frame(width: screenWidth * 0.9)
                                    .overlay {
                                        VStack {
                                            Image(.stamp)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 93)
                                            
                                            Text("스탬프 지원 축제가 없습니다")
                                                .padding(.top, 30)
                                                .font(.pretendard(weight: .p6, size: 22))
                                                .foregroundStyle(.grey400)
                                        }
                                        .padding(.vertical, 80)
                                    }
                                Spacer()
                            }
                        }
                    }
                    .padding(.bottom)
                } else {
                    GeometryReader { geometry in
                        let screenWidth = geometry.size.width
                        
                        ZStack(alignment: .top) {
                            VStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.ufBoxBackground)
                                    .frame(width: screenWidth * 0.9, height: 56)
                                    .overlay {
                                        Button {
                                            withAnimation {
                                                isStampDropdownPresented.toggle()
                                            }
                                        } label: {
                                            HStack {
                                                if let stampEnabledFestivals = stampVM.stampEnabledFestivals,
                                                   !stampEnabledFestivals.isEmpty {
                                                    let stampFestivalId = FestivalIdManager.stampFestivalId
                                                    if let matchedFestival = stampEnabledFestivals.first(where: { $0.festivalId == stampFestivalId }) {
                                                        Text(matchedFestival.schoolName)
                                                            .font(.pretendard(weight: .p6, size: 18))
                                                            .foregroundStyle(.grey900)
                                                        Spacer()
                                                        
                                                        if let count = stampVM.stampEnabledFestivals?.count, count >= 2 {
                                                            Image(systemName: "chevron.down")
                                                                .resizable()
                                                                .frame(width: 10, height: 6)
                                                                .foregroundStyle(.grey600)
                                                                .padding(.leading, -1)
                                                                .rotationEffect(isStampDropdownPresented ? .degrees(180) : .zero)
                                                        }
                                                    } else {
                                                        Text("스탬프 지원 축제가 없습니다")
                                                            .font(.pretendard(weight: .p6, size: 18))
                                                            .foregroundStyle(.grey900)
                                                    }
                                                } else {
                                                    Text("스탬프 지원 축제가 없습니다")
                                                        .font(.pretendard(weight: .p6, size: 18))
                                                        .foregroundStyle(.grey900)
                                                }
                                            }
                                        }
                                        .disabled(stampVM.stampEnabledFestivals?.count == nil || stampVM.stampEnabledFestivals?.count ?? 0 <= 1)
                                        .padding(.horizontal)
                                        .padding(.horizontal, 8)
                                    }
                                    .padding(.bottom, 5)
                                    .zIndex(1)
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.ufBoxBackground)
                                    .frame(width: screenWidth * 0.9)
                                    .overlay {
                                        VStack {
                                            HStack {
                                                VStack {
                                                    HStack {
                                                        Text("\(stampVM.stampCount)")
                                                            .foregroundStyle(.grey900)
                                                        Text("/ \(stampVM.stampEnabledBoothsCount)개")
                                                            .foregroundStyle(.grey500)
                                                    }
                                                    .font(.pretendard(weight: .p7, size: 24))
                                                    .padding(.bottom, 3)
                                                    
                                                    Button {
                                                        Task {
                                                            isUpdatingStampInfo = true
                                                            let stampFestivalId = FestivalIdManager.stampFestivalId
                                                            await throttleManager.throttle {
                                                                await stampVM.fetchStampRecord(deviceId: DeviceUUIDManager.shared.getDeviceToken(), festivalId: stampFestivalId)
                                                                await stampVM.fetchStampEnabledBooths(festivalId: stampFestivalId)
                                                            }
                                                            isUpdatingStampInfo = false
                                                        }
                                                    } label: {
                                                        Label("새로고침", systemImage: "arrow.triangle.2.circlepath")
                                                            .font(.system(size: 14))
                                                            .foregroundStyle(.grey600)
                                                    }
                                                }
                                                
                                                Spacer()
                                                
                                                Button {
                                                    checkCameraAuthorizationStatus()
                                                } label: {
                                                    Capsule()
                                                        .fill(
                                                            LinearGradient(
                                                                gradient: Gradient(stops: [
                                                                    .init(color: Color(red: 1.0, green: 0.525, blue: 0.6), location: 0.0),
                                                                    .init(color: Color(red: 1.0, green: 0.258, blue: 0.392), location: 1.0),
                                                                    .init(color: Color(red: 0.937, green: 0.224, blue: 1.0), location: 1.0)
                                                                ]),
                                                                startPoint: .topLeading,
                                                                endPoint: .bottom
                                                            )
                                                        )
                                                        .frame(width: 140, height: 52)
                                                        .overlay {
                                                            Text("스탬프 받기")
                                                                .font(.pretendard(weight: .p6, size: 18))
                                                                .foregroundStyle(.ufWhite)
                                                        }
                                                }
                                            }
                                            .padding(.top, 13)
                                            .padding(.bottom, 20)
                                            
                                            
                                            ScrollView {
                                                StampGrid(
                                                    totalStampCount: stampVM.stampEnabledBoothsCount,
                                                    currentStampCount: stampVM.stampCount,
                                                    screenWidth: screenWidth
                                                )
                                            }
                                            
                                            Spacer()
                                            
                                            RoundedRectangle(cornerRadius: 7)
                                                .fill(Color.ufBackground)
                                                .frame(width: 305, height: 50)
                                                .overlay {
                                                    Button {
                                                        isStampBoothViewPresented = true
                                                    } label: {
                                                        HStack {
                                                            Text("스탬프 부스 찾아보기")
                                                                .font(.pretendard(weight: .p6, size: 15))
                                                                .foregroundStyle(.grey700)
                                                            
                                                            Spacer()
                                                            
                                                            Image(systemName: "chevron.right")
                                                                .foregroundStyle(.grey700)
                                                        }
                                                        .padding(.horizontal)
                                                    }
                                                }
                                                .padding(.bottom, 5)
                                        }
                                        .padding()
                                        .padding(.horizontal, 8)
                                    }
                                    .zIndex(1)
                                
                                Spacer()
                            }
                            .padding()
                            // .background(.ufBackground)
                            .sheet(isPresented: $isStampBoothViewPresented) {
                                StampBoothListView(viewModel: viewModel, mapViewModel: mapViewModel)
                                    .presentationDragIndicator(.visible)
                            }
                            .fullScreenCover(isPresented: $isStampQRScanViewPresented) {
                                StampQRScanView()
                            }
                            .toastView(toast: $stampVM.qrScanToastMsg)
                            .dynamicTypeSize(.large)
                            .alert("카메라 권한 안내", isPresented: $isCameraPermissionAlertPresented) {
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
                                Text("스탬프를 받으려면 QR코드를 스캔해야 하며, 이를 위해 카메라 권한 허가가 필요해요. 앱 설정에서 카메라 권한을 수정할 수 있어요.")
                            }
                            
                            if isStampDropdownPresented {
                                let calculatedHeight = min(CGFloat(stampVM.stampEnabledFestivals?.count ?? 0) * 56, 240)
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.ufBoxBackground)
                                    .frame(width: screenWidth * 0.9, height: calculatedHeight)
                                    .overlay {
                                        ScrollView {
                                            VStack {
                                                if let stampEnabledFestivals = stampVM.stampEnabledFestivals {
                                                    ForEach(stampEnabledFestivals.indices, id: \.self) { index in
                                                        let festival = stampEnabledFestivals[index]
                                                        
                                                        Button {
                                                            Task {
                                                                isUpdatingStampInfo = true
                                                                FestivalIdManager.stampFestivalId = festival.festivalId
                                                                let stampFestivalId = FestivalIdManager.stampFestivalId
                                                                await stampVM.fetchStampRecord(deviceId: DeviceUUIDManager.shared.getDeviceToken(), festivalId: stampFestivalId)
                                                                await stampVM.fetchStampEnabledBooths(festivalId: stampFestivalId)
                                                                if let matchedFestival = stampVM.stampEnabledFestivals?.first(where: { $0.festivalId == stampFestivalId }) {
                                                                    stampVM.defaultImgUrl = matchedFestival.defaultImgUrl
                                                                    stampVM.usedImgUrl = matchedFestival.usedImgUrl
                                                                }
                                                                isStampDropdownPresented = false
                                                                isUpdatingStampInfo = false
                                                            }
                                                        } label: {
                                                            HStack {
                                                                Text(stampEnabledFestivals[index].schoolName)
                                                                    .font(.pretendard(weight: .p5, size: 16))
                                                                    .foregroundStyle(.grey800)
                                                                Spacer()
                                                            }
                                                        }
                                                        .padding(.bottom, 20)
                                                    }
                                                }
                                            }
                                            
                                        }
                                        .padding(25)
                                    }
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, y: 8)
                                    .padding(.top, 85)
                                    .zIndex(2)
                                //                                .transition(.move(edge: .top)) // 위에서 아래로 나타나고 아래에서 위로 사라지게 설정
                            }
                        }
                    }
                }
            }
            .task {
                isFetchingStampInfo = true
                let stampFestivalId = FestivalIdManager.stampFestivalId
                print("stampFestivalId: \(stampFestivalId)")
                await throttleManager.throttle {
                    await stampVM.fetchStampEnabledFestivals()
                    await stampVM.fetchStampRecord(deviceId: DeviceUUIDManager.shared.getDeviceToken(), festivalId: stampFestivalId)
                    await stampVM.fetchStampEnabledBooths(festivalId: stampFestivalId)
                }
                if let matchedFestival = stampVM.stampEnabledFestivals?.first(where: { $0.festivalId == stampFestivalId }) {
                    stampVM.defaultImgUrl = matchedFestival.defaultImgUrl
                    stampVM.usedImgUrl = matchedFestival.usedImgUrl
                }
                isFetchingStampInfo = false
            }
            
            if isUpdatingStampInfo {
                ZStack {
                    Color.black.opacity(0.66).ignoresSafeArea()
                    ProgressView()
                        .tint(Color.white)
                }
            }
        }
    }
    
    func checkCameraAuthorizationStatus() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isStampQRScanViewPresented = true
        case .denied, .restricted:
            isCameraPermissionAlertPresented = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        isStampQRScanViewPresented = true
                    } else {
                        isCameraPermissionAlertPresented = true
                    }
                }
            }
        default:
            break
        }
    }
}

struct StampGrid: View {
    let totalStampCount: Int
    let currentStampCount: Int
    let screenWidth: CGFloat
    @EnvironmentObject var stampVM: StampViewModel
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
        let gridHeight: Int = totalStampCount > 0 ? (totalStampCount / 4) + 1 : 0
        
        Grid {
            ForEach(Array(0 ..< gridHeight), id: \.self) { i in
                GridRow {
                    ForEach(Array(0 ..< 4), id: \.self) { j in
                        let count = i * 4 + j + 1
                        
                        if count > totalStampCount {
                            Color.clear
                                .frame(width: 62, height: 62)
                                .clipShape(Circle())
                                .padding(.horizontal, screenWidth * 0.0215)
                                .padding(.vertical, 8)
                        } else {
                            if currentStampCount >= count {
                                if stampVM.usedImgUrl == "" {
                                    // 스탬프에 기본 유니페스 이미지 적용
                                    Image(.appLogo)
                                        .resizable()
                                        .frame(width: 62, height: 62)
                                        .clipShape(Circle())
                                        .padding(.horizontal, screenWidth * 0.0215)
                                        .padding(.vertical, 8)
                                } else {
                                    // 스탬프에 해당 축제 커스텀 이미지 적용
                                    usedStampImage(for: stampVM.usedImgUrl)
                                }
                            } else {
                                if stampVM.defaultImgUrl == "" {
                                    // 스탬프에 기본 유니페스 이미지 적용
                                    ZStack {
                                        Circle()
                                            .fill(Color.grey300)
                                            .frame(width: 62, height: 62)
                                        
                                        Image(.noImagePlaceholder)
                                            .resizable()
                                            .frame(width: 42, height: 42)
                                            .offset(x: 2, y: -2)
                                    }
                                    .padding(.horizontal, screenWidth * 0.0215)
                                    .padding(.vertical, 8)
                                } else {
                                    // 스탬프에 해당 축제 커스텀 이미지 적용
                                    defaultStampImage(for: stampVM.defaultImgUrl)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(width: screenWidth * 0.85)
        .padding(.horizontal, 9)
    }
    
    @ViewBuilder
    func usedStampImage(for url: String) -> some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 62, height: 62)
            case .success(let image):
                image
                    .resizable()
                    .frame(width: 62, height: 62)
                    .clipShape(Circle())
                    .padding(.horizontal, screenWidth * 0.0215)
                    .padding(.vertical, 8)
            case .failure(_):
                Image(.appLogo)
                    .resizable()
                    .frame(width: 62, height: 62)
                    .clipShape(Circle())
                    .padding(.horizontal, screenWidth * 0.0215)
                    .padding(.vertical, 8)
            @unknown default:
                Image(.appLogo)
                    .resizable()
                    .frame(width: 62, height: 62)
                    .clipShape(Circle())
                    .padding(.horizontal, screenWidth * 0.0215)
                    .padding(.vertical, 8)
            }
        }
        .frame(width: 62, height: 62)
        .clipShape(Circle())
    }
    
    @ViewBuilder
    func defaultStampImage(for url: String) -> some View {
        AsyncImage(url: URL(string: url)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: 62, height: 62)
            case .success(let image):
                image
                    .resizable()
                    .frame(width: 62, height: 62)
                    .clipShape(Circle())
                    .padding(.horizontal, screenWidth * 0.0215)
                    .padding(.vertical, 8)
            case .failure(_):
                ZStack {
                    Circle()
                        .fill(Color.grey300)
                        .frame(width: 62, height: 62)
                    
                    Image(.noImagePlaceholder)
                        .resizable()
                        .frame(width: 42, height: 42)
                        .offset(x: 2, y: -2)
                }
                .padding(.horizontal, screenWidth * 0.0215)
                .padding(.vertical, 8)
            @unknown default:
                ZStack {
                    Circle()
                        .fill(Color.grey300)
                        .frame(width: 62, height: 62)
                    
                    Image(.noImagePlaceholder)
                        .resizable()
                        .frame(width: 42, height: 42)
                        .offset(x: 2, y: -2)
                }
                .padding(.horizontal, screenWidth * 0.0215)
                .padding(.vertical, 8)
            }
        }
        .frame(width: 62, height: 62)
        .clipShape(Circle())
    }
}

#Preview {
    StampView(viewModel: RootViewModel(), mapViewModel: MapViewModel(viewModel: RootViewModel()))
        .environmentObject(StampViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
}
