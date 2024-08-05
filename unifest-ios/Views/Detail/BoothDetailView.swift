//
//  DetailView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/26/24.
//

import SwiftUI

// DetailView가 호출되는 뷰는 총 세 개가 있음
// 1. MapPageHeaderView의 '인기 부스'를 눌러서 인기 부스 리스트가 나와 그 중 하나를 탭했을 때
// 2. 탭뷰의 '메뉴'탭의 '관심 부스'에서
//    viewModel.boothModel.likedBoothList.isEmpty || randomLikeList.isEmpty 조건의 else문 뷰가 나타나
//    그 리스트의 항목을 탭했을 때
// 3. 탭뷰의 '메뉴'탭의 '관심 부스'에서, '관심 부스' 리스트에 element가 있다면 '관심부스          더보기 >' 버튼을 보여줌
//    그 버튼을 탭하면 LikeBoothListView로 이동하는데, 거기서 관심 부스 리스트의 항목을 탭했을 때

// BoothDeatilView는 BoothInfoView, BoothMenuView, BoothFooterView로 구성됨
// BoothMenuView(리스트)의 각 항목은 MenuBarView이며 MenuBarView의 사진을 탭하면 MenuImageView가 나타남


struct SelectedMenuInfo {
    var selectedMenuURL = ""
    var selectedMenuName = ""
    var selectedMenuPrice = ""
}

struct BoothDetailView: View {
    @ObservedObject var viewModel: RootViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    let currentBoothId: Int
    @State private var isReloadButtonPresent: Bool = false
    @State private var isMenuImagePresented: Bool = false
    @State private var menu = SelectedMenuInfo() // MenuBarView에서 음식 사진을 탭했을 때 MenuImageView로 음식 정보를 전달하기 위해 선언한 변수
    @State private var selectedBoothHours = 0 // 주간부스(0), 야간부스(1)
    @State private var isWaitingPinViewPresented: Bool = false
    @State private var isWaitingRequestViewPresented: Bool = false
    @State private var isWaitingCompleteViewPresented: Bool = false
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    ScrollView {
                        BoothInfoView(viewModel: viewModel, selectedBoothHours: $selectedBoothHours, isReloadButtonPresent: $isReloadButtonPresent)
                        
                        BoothMenuView(viewModel: viewModel, isReloadButtonPresent: $isReloadButtonPresent, isMenuImagePresented: $isMenuImagePresented, selectedMenu: $menu)
                    }
                    .ignoresSafeArea(edges: .top)
                    .background(colorScheme == .dark ? Color.grey100 : Color.white)
                    
                    BoothFooterView(viewModel: viewModel, isReloadButtonPresent: $isReloadButtonPresent, isWaitingPinViewPresented: $isWaitingPinViewPresented)
                }
                
                if isMenuImagePresented {
                    MenuImageView(isPresented: $isMenuImagePresented, menu: menu)
                        .onDisappear {
                            menu.selectedMenuURL = ""
                            menu.selectedMenuName = ""
                            menu.selectedMenuPrice = ""
                        }
                }
                
                if isWaitingPinViewPresented {
                    WaitingPinView(boothId: currentBoothId, isWaitingPinViewPresented: $isWaitingPinViewPresented, isWaitingRequestViewPresented: $isWaitingRequestViewPresented)
                }
                
                if isWaitingRequestViewPresented {
                    WaitingRequestView(isWaitingRequestViewPresented: $isWaitingRequestViewPresented, isWaitingCompleteViewPresented: $isWaitingCompleteViewPresented, boothId: currentBoothId)
                }
                
                if isWaitingCompleteViewPresented {
                    WaitingCompleteView(isWaitingCompleteViewPresented: $isWaitingCompleteViewPresented)
                }
            }
        }
        .onAppear {
            print("Current Booth ID: \(currentBoothId)")
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
    
    return Group {
        //        Text("")
        //            .sheet(isPresented: .constant(true)) {
        BoothDetailView(viewModel: viewModel, currentBoothId: 0)
            .onAppear {
                viewModel.boothModel.selectedBoothID = 119
                viewModel.boothModel.loadBoothDetail(119)
            }
            .environmentObject(WaitingViewModel())
        //            }
    }
}
