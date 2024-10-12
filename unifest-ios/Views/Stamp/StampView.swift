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
    @EnvironmentObject var stampVM: StampViewModel
    @EnvironmentObject var networkManager: NetworkManager
    @State private var rotationAmount = 0.0
    @State private var isStampBoothViewPresented = false
    @State private var isStampQRScanViewPresented = false
    @State private var addStampToast: Toast? = nil
    @State private var isCameraPermissionAlertPresented = false
    @State private var isCameraAuthorized = false
    @State private var isFetchingStampInfo = false
    
    var body: some View {
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
            } else {
                GeometryReader { geometry in
                    let screenWidth = geometry.size.width
                    
                    VStack { // ScrollView로 바꾸려면 RoundedRectangle의 height를 설정해야 함
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.ufBoxBackground)
                            .frame(width: screenWidth * 0.9)
                            .overlay {
                                VStack {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text("한국교통대학교")
                                                .font(.pretendard(weight: .p6, size: 20))
                                                .foregroundStyle(.grey900)
                                                .padding(.bottom, 3)
                                            
                                            Text("지금까지 모은 스탬프")
                                                .font(.pretendard(weight: .p4, size: 14))
                                                .foregroundStyle(.grey500)
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
                                    
                                    HStack {
                                        HStack {
                                            Text("\(stampVM.stampCount)")
                                                .foregroundStyle(.grey900)
                                            Text("/ \(stampVM.stampEnabledBoothsCount)개")
                                                .foregroundStyle(.grey500)
                                        }
                                        .font(.pretendard(weight: .p7, size: 24))
                                        
                                        Spacer()
                                        
                                        Button {
                                            Task {
                                                isFetchingStampInfo = true
                                                // await stampVM.stampCount(token: UIDevice.current.deviceToken)
                                                await stampVM.stampCount(token: "ios-test-token-1")
                                                await stampVM.getStampEnabledBooths(festivalId: 2)
                                                isFetchingStampInfo = false
                                            }
                                        } label: {
                                            Label("새로고침", systemImage: "arrow.triangle.2.circlepath")
                                                .font(.system(size: 14))
                                                .foregroundStyle(.grey600)
                                        }
                                        .padding(.trailing, 8)
                                    }
                                    .padding(.bottom, 20)
                                    
                                    StampGrid(
                                        totalStampCount: stampVM.stampEnabledBoothsCount,
                                        currentStampCount: stampVM.stampCount,
                                        screenWidth: screenWidth
                                    )
//                                                                        StampGrid(totalStampCount: 14, currentStampCount: 9, screenWidth: screenWidth)
                                    
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
                        
                        Spacer()
                    }
                    .refreshable {
                        isFetchingStampInfo = true
                        await stampVM.stampCount(token: UIDevice.current.deviceToken)
                        await stampVM.getStampEnabledBooths(festivalId: 2)
                        isFetchingStampInfo = false
                    }
                    .padding()
                    .background(.ufBackground)
                    .sheet(isPresented: $isStampBoothViewPresented) {
                        StampBoothListView(viewModel: viewModel)
                            .presentationDragIndicator(.visible)
                    }
                    .fullScreenCover(isPresented: $isStampQRScanViewPresented) {
                        StampQRScanView()
                    }
                    .toastView(toast: $stampVM.qrScanToastMsg)
                    .dynamicTypeSize(.large)
                    .alert("QR코드를 스캔하려면 카메라 권한 허가가 필요해요", isPresented: $isCameraPermissionAlertPresented) {
                        Button("설정 앱으로 이동할래요") {
                            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                            
                            if UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        }
                        
                        Button("취소", role: .cancel) { }
                    } message: {
                        Text("카메라 권한 허가는 iPhone 설정 - 유니페스 에서 가능해요.")
                    }
                }
            }
        }
        .task {
            isFetchingStampInfo = true
            // await stampVM.stampCount(token: UIDevice.current.deviceToken)
            await stampVM.stampCount(token: "ios-test-token-1")
            await stampVM.getStampEnabledBooths(festivalId: 2)
            isFetchingStampInfo = false
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
    
    var body: some View {
        let gridHeight: Int = totalStampCount > 0 ? (totalStampCount / 4) + 1 : 0
        
        Grid {
            ForEach(0 ..< gridHeight) { i in
                GridRow {
                    ForEach(0 ..< 4) { j in
                        let count = i * 4 + j + 1
                        
                        if count > totalStampCount {
                            Color.clear
                                .frame(width: 62, height: 62)
                                .clipShape(Circle())
                                .padding(.horizontal, screenWidth * 0.0215)
                                .padding(.vertical, 8)
                        } else {
                            if currentStampCount >= count {
                                Image(.appLogo)
                                    .resizable()
                                    .frame(width: 62, height: 62)
                                    .clipShape(Circle())
                                    .padding(.horizontal, screenWidth * 0.0215)
                                    .padding(.vertical, 8)
                            } else {
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
                    }
                }
            }
        }
        .frame(width: screenWidth * 0.85)
        .padding(.horizontal, 9)
    }
}


#Preview {
    StampView(viewModel: RootViewModel())
        .environmentObject(StampViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
}

