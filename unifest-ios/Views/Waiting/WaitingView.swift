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
    @State private var waitingCancelToast: Toast? = nil
    
    var body: some View {
        GeometryReader { geometry in
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
                    
                    if waitingVM.isFetchingReservedWaitingCompleted {
                        WaitingListView(viewModel: viewModel)
                    } else {
                        VStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
                
                if waitingVM.cancelWaiting == true {
                    WaitingCancelView(waitingCancelToast: $waitingCancelToast)
                }
            }
            .background(.ufBackground)
            .task {
                await waitingVM.fetchReservedWaiting(deviceId: UIDevice.current.deviceToken)
            }
            .refreshable {
                await waitingVM.fetchReservedWaiting(deviceId: UIDevice.current.deviceToken)
            }
            .toastView(toast: $waitingCancelToast)
        }
    }
}

#Preview {
    WaitingView(viewModel: RootViewModel())
        .environmentObject(WaitingViewModel())
}
