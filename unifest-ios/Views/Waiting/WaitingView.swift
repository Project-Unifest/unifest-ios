//
//  WaitingView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import SwiftUI

struct WaitingView: View {
    @ObservedObject var viewModel: RootViewModel
    @EnvironmentObject var waitingVM: WaitingViewModel
    @EnvironmentObject var networkManager: NetworkManager
    @State private var isFetchingWaitingList = false
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(StringLiterals.Waiting.title)
                        .font(.pretendard(weight: .p6, size: 20))
                        .foregroundStyle(.grey900)
                    
                    Spacer()
                }
                .padding()
                
                Text("")
                    .roundedButton(background: .primary50, strokeColor: .accent, height: 34, cornerRadius: 30)
                    .padding(.horizontal)
                    .overlay {
                        HStack {
                            Text(StringLiterals.Waiting.myWaiting)
                                .font(.pretendard(weight: .p7, size: 13))
                                .foregroundStyle(.primary500)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                    }
                
                if isFetchingWaitingList {
                    VStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                } else {
                    WaitingListView(viewModel: viewModel)
                }
            }
        }
        .background(.ufBackground)
        .task {
            isFetchingWaitingList = true
            await waitingVM.fetchReservedWaiting(deviceId: UIDevice.current.deviceToken)
            isFetchingWaitingList = false
        }
        .refreshable {
            await waitingVM.fetchReservedWaiting(deviceId: UIDevice.current.deviceToken)
        }
        .toastView(toast: $waitingVM.waitingCancelToast)
        .dynamicTypeSize(.large)
    }
}

#Preview {
    WaitingView(viewModel: RootViewModel())
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
}
