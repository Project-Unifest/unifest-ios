//
//  WaitingCancelView.swift
//  unifest-ios
//
//  Created by 임지성 on 8/23/24.
//

import SwiftUI

struct WaitingCancelView: View {
    @Binding var waitingCancelToast: Toast?
    @EnvironmentObject var waitingVM: WaitingViewModel
    @EnvironmentObject var networkManager: NetworkManager
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.66)
                .ignoresSafeArea()
            
            Color.ufWhite
                .cornerRadius(10)
                .frame(width: 301, height: 196)
                .overlay {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.ufRed)
                            .padding(.top, 10)
                        
                        Text("웨이팅을 취소합니다")
                            .font(.pretendard(weight: .p6, size: 18))
                            .foregroundStyle(.grey900)
                            .padding(.top, 15)
                        
                        Text("정말 취소하시겠습니까?")
                            .font(.pretendard(weight: .p5, size: 13))
                            .foregroundStyle(.grey600)
                            .padding(.top, -5)
                        
                        HStack {
                            Button {
                                Task {
                                    waitingVM.cancelWaiting = false
                                    
                                    await waitingVM.cancelWaiting(
                                        waitingId: waitingVM.waitingIdToCancel,
                                        deviceId: UIDevice.current.deviceToken
                                    )
                                    
                                    if waitingVM.isCancelWaitingRequestCompleted {
                                        if networkManager.isServerError == false { // true일 때는 RootView에서 NetworkErrorView 띄움
                                            Task {
                                                await waitingVM.fetchReservedWaiting(deviceId: UIDevice.current.deviceToken)
                                                waitingVM.waitingIdToCancel = -1
                                                waitingVM.isCancelWaitingRequestCompleted = false
                                                waitingCancelToast = Toast(style: .success, message: "웨이팅을 취소했습니다")
                                            }
                                        }
                                    }
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.primary500)
                                    .frame(width: 133, height: 45)
                                    .overlay {
                                        Text("확인")
                                            .font(.pretendard(weight: .p6, size: 14))
                                            .foregroundStyle(.ufWhite)
                                    }
                            }
                            
                            Button {
                                waitingVM.cancelWaiting = false
                                waitingVM.waitingIdToCancel = -1
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.grey100)
                                    .frame(width: 133, height: 45)
                                    .overlay {
                                        Text("취소")
                                            .font(.pretendard(weight: .p6, size: 14))
                                            .foregroundStyle(.grey700)
                                    }
                            }
                        }
                        .padding(.top, 21)
                    }
                }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WaitingCancelView(waitingCancelToast: .constant(nil))
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
}
