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
                    
                    if waitingVM.isReservedWaitingRequestCompleted {
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
                
                if waitingVM.isCancelWaitingConfirmed && !waitingVM.isCancelWaitingRequestCompleted {
                    // 사용자가 WaitingCancelView의 '확인'버튼을 누른 시점 ~ 웨이팅 취소 요청에 대한 응답이 도착하는 시점까지 뜨는 뷰
                    ZStack {
                        Color.black.opacity(0.66)
                            .ignoresSafeArea()
                        
                        VStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .tint(Color.white)
                            Spacer()
                        }
                    }
                }
            }
            .background(.ufBackground)
            .task {
                await waitingVM.fetchReservedWaiting(deviceId: UIDevice.current.deviceToken)
            }
            .onAppear {
                print("WaitingView isServerError: \(networkManager.isServerError)")
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
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
}
