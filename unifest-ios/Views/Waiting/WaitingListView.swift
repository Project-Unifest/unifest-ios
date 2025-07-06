//
//  WaitingListView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/5/24.
//

import SwiftUI

struct WaitingListView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @EnvironmentObject var waitingVM: WaitingViewModel
    @EnvironmentObject var tabSelect: TabSelect
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
        if let reservedWaitingList = waitingVM.reservedWaitingList, reservedWaitingList.isEmpty == false {
            VStack {
                HStack {
                    Text("총 \(reservedWaitingList.count)건")
                        .font(.pretendard(weight: .p6, size: 11))
                        .foregroundStyle(.grey900)
                        .padding(.leading, 10)
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                ScrollView {
                    ForEach(reservedWaitingList.indices, id: \.self) { i in
                        WaitingInfoView(
                            viewModel: viewModel,
                            mapViewModel: mapViewModel,
                            reservedWaitingListItem: reservedWaitingList[i]
                        )
                    }
                    .padding(.top, 8) // '총 O건'과 첫번째 WaitingInfoView 사이의 간격
                    .padding(.bottom, 13) // 마지막 WaitingInfoView와 탭바 사이의 간격
                }
            }
        } else { // reservedWaitingList가 nil이거나 빈 배열일 때
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Text(StringLiterals.Waiting.noWaitingTitle)
                            .font(.pretendard(weight: .p6, size: 18))
                            .foregroundStyle(.grey900)
                            .padding(.bottom, 4)
                        
                        Button {
                            tabSelect.selectedTab = 2
                        } label: {
                            HStack(spacing: 0) {
                                Text(StringLiterals.Waiting.gotoMapView)
                                Image(systemName: "chevron.right")
                            }
                            .font(.pretendard(weight: .p5, size: 13))
                            .foregroundStyle(.grey600)
                            .underline()
                        }
                    }
                    .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)                }
            }
        }
    }
}

#Preview {
    WaitingListView(viewModel: RootViewModel(), mapViewModel: MapViewModel(viewModel: RootViewModel()))
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
}
