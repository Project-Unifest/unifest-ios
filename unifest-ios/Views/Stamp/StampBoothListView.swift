//
//  StampBoothView.swift
//  unifest-ios
//
//  Created by 임지성 on 8/30/24.
//

import SwiftUI

struct StampBoothListView: View {
    @ObservedObject var viewModel: RootViewModel
    @EnvironmentObject var stampVM: StampViewModel
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("한국교통대학교")
                            .font(.pretendard(weight: .p4, size: 14))
                            .foregroundStyle(.grey500)
                            .padding(.bottom, -1)
                        
                        Text("스탬프 가능 부스")
                            .font(.pretendard(weight: .p6, size: 20))
                            .foregroundStyle(.grey900)
                            .padding(.bottom, 8)
                        
                        Text("총 \(stampVM.stampEnabledBoothsCount)개")
                            .font(.pretendard(weight: .p6, size: 13))
                            .foregroundStyle(.grey600)
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 30)
                    
                    Spacer()
                }
                
                if stampVM.stampEnabledBoothsCount == 0 {
                    VStack(alignment: .center) {
                        Spacer()
                        Text("스탬프를 받을 수 있는 부스가 없습니다")
                            .font(.pretendard(weight: .p6, size: 18))
                            .foregroundStyle(.grey900)
                            .padding(.bottom, 1)
                        
                        Text("")
                            .font(.pretendard(weight: .p5, size: 13))
                            .foregroundStyle(.grey600)
                        Spacer()
                    }
                } else {
                    List {
                        if let stampEnabledBooths = stampVM.stampEnabledBooths {
                            ForEach(stampEnabledBooths, id: \.id) { booth in
                                StampBoothListItemView(
                                    viewModel: viewModel,
                                    boothID: booth.id,
                                    image: booth.thumbnail ?? "",
                                    name: booth.name,
                                    description: booth.description ?? "",
                                    location: booth.location ?? ""
                                )
                                .listRowBackground(Color.ufBackground)
                                .listRowSeparator(.hidden)
                            }
                        }
                    }
                    .background(.ufBackground)
                    .listStyle(.plain)
                }
            }
            .background(.ufBackground)
            
            if networkManager.isNetworkConnected == false {
                NetworkErrorView(errorType: .network)
                    .onAppear {
                        GATracking.eventScreenView(GATracking.ScreenNames.networkErrorView)
                    }
            }
            
//            if networkManager.isServerError == true {
//                NetworkErrorView(errorType: .server)
//                    .onAppear {
//                        GATracking.eventScreenView(GATracking.ScreenNames.networkErrorView)
//                    }
//            }
        }
        .dynamicTypeSize(.large)
    }
}

#Preview {
    StampBoothListView(viewModel: RootViewModel())
        .environmentObject(StampViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
}
