//
//  DetailView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/26/24.
//

import SwiftUI

// BoothDeatilView는 BoothInfoView, BoothMenuView, BoothFooterView로 구성됨
// BoothMenuView(리스트)의 각 항목은 MenuBarView이며 MenuBarView의 사진을 탭하면 MenuImageView가 나타남

struct SelectedMenuInfo {
    var selectedMenuURL = ""
    var selectedMenuName = ""
    var selectedMenuPrice = ""
}

struct BoothDetailView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var waitingVM: WaitingViewModel
    let currentBoothId: Int
    @State private var pin: String = ""
    @State private var isReloadButtonPresent: Bool = false
    @State private var isMenuImagePresented: Bool = false
    @State private var menu = SelectedMenuInfo() // MenuBarView에서 음식 사진을 탭했을 때 MenuImageView로 음식 정보를 전달하기 위해 선언한 변수
    @State private var isNoshowDialogPresented: Bool = false // 예약 후 노쇼 처리된 부스에 웨이팅하기 버튼을 탭하면, 웨이팅 탭으로 이동해서 노쇼 부스를 지우도록 유도하는 다이얼로그 띄움
    @State private var isWaitingPinViewPresented: Bool = false
    @State private var isWaitingRequestViewPresented: Bool = false
    @State private var isWaitingCompleteViewPresented: Bool = false
    @State private var isNetworkErrorViewPresented: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    ScrollView {
                        BoothInfoView(
                            viewModel: viewModel,
                            mapViewModel: mapViewModel,
                            isReloadButtonPresent: $isReloadButtonPresent,
                            isBoothThumbnailPresented: $isMenuImagePresented,
                            boothThumbnail: $menu
                        )
                        
                        BoothMenuView(
                            viewModel: viewModel,
                            isReloadButtonPresent: $isReloadButtonPresent,
                            isMenuImagePresented: $isMenuImagePresented,
                            selectedMenu: $menu
                        )
                    }
                    .ignoresSafeArea(edges: .top)
                    .background(colorScheme == .dark ? Color.grey100 : Color.white)
                    
                    BoothFooterView(
                        viewModel: viewModel,
                        isReloadButtonPresent: $isReloadButtonPresent,
                        isWaitingPinViewPresented: $isWaitingPinViewPresented,
                        isNoshowDialogPresented: $isNoshowDialogPresented
                    )
                }
                
                if isMenuImagePresented {
                    MenuImageView(
                        isPresented: $isMenuImagePresented,
                        menu: menu
                    )
                    .onDisappear {
                        menu.selectedMenuURL = ""
                        menu.selectedMenuName = ""
                        menu.selectedMenuPrice = ""
                    }
                }
                
                if isNoshowDialogPresented {
                    BoothNoshowDialogView(isNoshowDialogPresented: $isNoshowDialogPresented)
                }
                
                if isWaitingPinViewPresented {
                    WaitingPinView(
                        viewModel: viewModel,
                        boothId: currentBoothId,
                        pin: $pin,
                        isWaitingPinViewPresented: $isWaitingPinViewPresented,
                        isWaitingRequestViewPresented: $isWaitingRequestViewPresented
                    )
                }
                
                if isWaitingRequestViewPresented {
                    WaitingRequestView(
                        viewModel: viewModel,
                        boothId: currentBoothId,
                        pin: $pin,
                        isWaitingRequestViewPresented: $isWaitingRequestViewPresented,
                        isWaitingCompleteViewPresented: $isWaitingCompleteViewPresented
                    )
                }
                
                if isWaitingCompleteViewPresented {
                    WaitingCompleteView(
                        isWaitingCompleteViewPresented: $isWaitingCompleteViewPresented
                    )
                }
                
                if networkManager.isNetworkConnected == false {
                    NetworkErrorView(errorType: .network)
                        .onAppear {
                            GATracking.eventScreenView(GATracking.ScreenNames.networkErrorView)
                        }
                }
                
                if networkManager.isServerError == true {
                    NetworkErrorView(errorType: .server)
                        .onAppear {
                            GATracking.eventScreenView(GATracking.ScreenNames.networkErrorView)
                        }
                }
            }
        }
        .dynamicTypeSize(.large)
        .toastView(toast: $waitingVM.reservedWaitingCountExceededToast)
        .toastView(toast: $waitingVM.alreadyReservedToast)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isReloadButtonPresent = true
            }
            GATracking.eventScreenView(GATracking.ScreenNames.boothDetailView)
        }
        .onDisappear {
            viewModel.boothModel.selectedBooth = nil
            viewModel.boothModel.selectedBoothID = 0
        }
    }
}

#Preview {
    @ObservedObject var viewModel = RootViewModel()
    @ObservedObject var mapViewModel = MapViewModel(viewModel: RootViewModel())
    
    return Group {
        Text("")
            .sheet(isPresented: .constant(true)) {
                BoothDetailView(viewModel: viewModel, mapViewModel: mapViewModel, currentBoothId: 0)
                    .onAppear {
                        viewModel.boothModel.selectedBoothID = 156
                        viewModel.boothModel.loadBoothDetail(156)
                    }
                    .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
                    .environmentObject(NetworkManager())
            }
    }
}
