//
//  WaitingCancelView.swift
//  unifest-ios
//
//  Created by 임지성 on 8/23/24.
//

import SwiftUI

struct WaitingCancelView: View {
    @EnvironmentObject var waitingVM: WaitingViewModel
    @EnvironmentObject var networkManager: NetworkManager
    @State private var isCancellingWaiting = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.66)
                .ignoresSafeArea()
            
            if isCancellingWaiting {
                VStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(Color.white)
                    Spacer()
                }
            } else {
                Color.ufWhite
                    .cornerRadius(10)
                    .frame(width: 301, height: 196)
                    .overlay {
                        VStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 20))
                                .foregroundStyle(.ufRed)
                                .padding(.top, 3)
                            
                            Text(waitingVM.waitingStatus == "NOSHOW" ? "부재 중인 웨이팅을 지울게요" : "웨이팅을 취소할게요")
                                .font(.pretendard(weight: .p6, size: 18))
                                .foregroundStyle(.grey900)
                                .padding(.top, 15)
                            
                            Text(waitingVM.waitingStatus == "NOSHOW" ? "문제가 있는 경우 해당 부스 운영자에게 문의해주세요" : "정말로 취소하시겠어요?")
                                .font(.pretendard(weight: .p5, size: 13))
                                .foregroundStyle(.grey600)
                                .padding(.top, -5)
                            
                            HStack {
                                Button {
                                    Task {
                                        isCancellingWaiting = true
                                        await waitingVM.cancelWaiting(
                                            waitingId: waitingVM.waitingIdToCancel,
                                            deviceId: DeviceUUIDManager.shared.getDeviceToken()
                                        )
                                        waitingVM.cancelWaiting = false
                                        isCancellingWaiting = false
                                        
                                        if networkManager.isServerError == false { // true일 때는 RootView에서 NetworkErrorView 띄움
                                            await waitingVM.fetchReservedWaiting(deviceId: DeviceUUIDManager.shared.getDeviceToken())
                                            waitingVM.waitingIdToCancel = -1
                                            waitingVM.waitingStatus = ""
                                            waitingVM.waitingCancelToast = Toast(style: .success, message: "웨이팅을 취소했습니다")
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
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WaitingCancelView()
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
}
