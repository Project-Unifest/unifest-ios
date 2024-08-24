//
//  WaitingCancelConfirmView.swift
//  unifest-ios
//
//  Created by 임지성 on 8/23/24.
//

import SwiftUI

struct WaitingCancelView: View {
    @Binding var cancelWaiting: Bool
    @Binding var waitingIdToCancel: Int
    @Binding var waitingCancelToast: Toast?
    @EnvironmentObject var waitingVM: WaitingViewModel
    
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
                                    await waitingVM.cancelWaiting(waitingId: waitingIdToCancel, deviceId: UIDevice.current.deviceToken)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                        Task {
                                            await waitingVM.fetchReservedWaiting(deviceId: UIDevice.current.deviceToken)
                                            cancelWaiting = false
                                            waitingCancelToast = Toast(style: .success, message: "웨이팅을 취소했습니다")
                                        }
                                    }
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.primary500)
                                    .frame(width: 133, height: 45)
                                    .overlay {
                                        Text("확인")
                                            .font(.pretendard(weight: .p6, size: 13))
                                            .foregroundStyle(.ufWhite)
                                    }
                            }
                            
                            Button {
                                cancelWaiting = false
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.grey200)
                                    .frame(width: 133, height: 45)
                                    .overlay {
                                        Text("취소")
                                            .font(.pretendard(weight: .p6, size: 13))
                                            .foregroundStyle(.ufBlack)
                                    }
                            }
                        }
                        .padding(.top, 21)
                    }
                }
        }
    }
}

#Preview {
    WaitingCancelView(cancelWaiting: .constant(false), waitingIdToCancel: .constant(-1), waitingCancelToast: .constant(nil))
        .environmentObject(WaitingViewModel())
}