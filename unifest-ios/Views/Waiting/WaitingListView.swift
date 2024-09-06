//
//  WaitingListView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/5/24.
//

import SwiftUI

struct WaitingListView: View {
    @ObservedObject var viewModel: RootViewModel
    @EnvironmentObject var waitingVM: WaitingViewModel
    @EnvironmentObject var tabSelect: TabSelect
    @Binding var cancelWaiting: Bool
    @Binding var waitingIdToCancel: Int
    @Binding var waitingCancelToast: Toast?
    
    var body: some View {
        if let reservedWaitingList = waitingVM.reservedWaitingList {
            HStack {
                Text("총 \(reservedWaitingList.count)건")
                    .font(.pretendard(weight: .p6, size: 11))
                    .foregroundStyle(.gray545454)
                    .padding(.leading, 10)
                
                Spacer()
                
//                HStack {
//                    Button {
//                        
//                    } label: {
//                        Image(systemName: "chevron.down")
//                            .resizable()
//                            .frame(width: 7, height: 7)
//                            .foregroundStyle(.gray545454)
//                        Text("정렬")
//                            .font(.pretendard(weight: .p6, size: 11))
//                            .foregroundStyle(.gray545454)
//                            .padding(.leading, -3)
//                    }
//                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            ScrollView {
                ForEach(reservedWaitingList.indices, id: \.self) { i in
                    WaitingInfoView(
                        viewModel: viewModel,
                        reservedWaitingListItem: reservedWaitingList[i],
                        cancelWaiting: $cancelWaiting,
                        waitingIdToCancel: $waitingIdToCancel,
                        waitingCancelToast: $waitingCancelToast
                    )
                        .padding(.horizontal, 20) // WaitingInfoView에 적용한 shadow가 ForEach문에서 잘리는 문제 해결
                }
                .padding(.top, 8)
            }
        } else {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        Text(StringLiterals.Waiting.noWaitingTitle)
                            .font(.pretendard(weight: .p6, size: 18))
                            .foregroundStyle(.grey900)
                            .padding(.bottom, 4)
                        
                        Button {
                            tabSelect.selectedTab = 1
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
                    .frame(minHeight: geometry.size.height)
                    // VStack의 최소 높이를 부모 뷰의 높이로 설정해서 ScrollView내에 중앙 정렬 가능(VStack은 기본적으로 content를 중앙에 정렬함)
                }
            }
        }
    }
}

#Preview {
    WaitingListView(viewModel: RootViewModel(), cancelWaiting: .constant(false), waitingIdToCancel: .constant(-1), waitingCancelToast: .constant(nil))
        .environmentObject(WaitingViewModel())
}
