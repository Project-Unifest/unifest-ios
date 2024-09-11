//
//  WaitingCompleteView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/1/24.
//

import SwiftUI

struct WaitingCompleteView: View {
    @State private var number: Int = 2
    @Binding var isWaitingCompleteViewPresented: Bool
    @EnvironmentObject var waitingVM: WaitingViewModel
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tabSelect: TabSelect
    
    var body: some View {
        if let waitingInfo = waitingVM.requestedWaitingInfo {
            ZStack {
                Color.black.opacity(0.66)
                    .ignoresSafeArea()
                
                Color.ufWhite
                    .cornerRadius(10)
                    .frame(width: 301, height: 266)
                    .overlay {
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: 11, height: 11)
                                
                                Spacer()
                                
                                    Image(.marker)
                                        .resizable()
                                        .frame(width: 11, height: 15)
                                        .padding(.trailing, -1)
                                    
                                Text(waitingInfo.boothName)
                                        .font(.pretendard(weight: .p6, size: 15))
                                        .foregroundStyle(.grey900)
                                
                                Spacer()
                                
                                Button {
                                    isWaitingCompleteViewPresented = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 11, height: 11)
                                        .foregroundColor(.grey600)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                            
                            Text("웨이팅 등록 완료!")
                                .font(.pretendard(weight: .p7, size: 20))
                                .foregroundStyle(.grey900)
                                .padding(.bottom, 1)
                            
                            Text("입장 순서가 되면 안내 해드릴게요.")
                                .font(.pretendard(weight: .p4, size: 13))
                                .foregroundStyle(.grey600)
                            
                            Divider()
                                .foregroundStyle(.grey200)
                                .padding(.bottom, 4)
                            
                            HStack {
                                Spacer()
                                VStack(spacing: 8) {
                                    Text("웨이팅 번호")
                                        .font(.pretendard(weight: .p5, size: 13))
                                        .foregroundStyle(.grey900)
                                    Text(String(waitingInfo.waitingId) + "번")
                                        .font(.pretendard(weight: .p7, size: 20))
                                        .foregroundStyle(.grey900)
                                }
                                
                                Spacer()
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    Text("인원 수")
                                        .font(.pretendard(weight: .p5, size: 13))
                                        .foregroundStyle(.grey900)
                                    Text(String(waitingInfo.partySize) + "명")
                                        .font(.pretendard(weight: .p7, size: 20))
                                        .foregroundStyle(.grey900)
                                }
                                
                                Spacer()
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    Text("내 앞 웨이팅")
                                        .font(.pretendard(weight: .p5, size: 13))
                                        .foregroundStyle(.grey900)
                                    Text(String(waitingVM.waitingTeamCount) + "팀")
                                        .font(.pretendard(weight: .p7, size: 20))
                                        .foregroundStyle(.grey900)
                                }
                                Spacer()
                            }
                            .padding()
                            
//                            HStack {
//                                Button {
//                                    
//                                } label: {
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .strokeBorder(Color.grey400, lineWidth: 1)
//                                        .frame(width: 133, height: 45)
//                                        .overlay {
//                                            Text("웨이팅 취소")
//                                                .font(.pretendard(weight: .p6, size: 13))
//                                                .foregroundStyle(.grey500)
//                                        }
//                                }
//                                
//                                Button {
//                                    // isWaitingCompleteViewPresented = false
//                                    dismiss() // dismiss()하면 BoothDetailView도 같이 내려감 의도한 거긴 한데 왜 되지..?
//                                    tabSelect.selectedTab = 2
//                                } label: {
//                                    RoundedRectangle(cornerRadius: 5)
//                                        .fill(Color.primary500)
//                                        .frame(width: 133, height: 45)
//                                        .overlay {
//                                            Text("순서 확인하기")
//                                                .font(.pretendard(weight: .p6, size: 13))
//                                                .foregroundStyle(.white)
//                                        }
//                                }
//                            }
                            
                            Button {
                                isWaitingCompleteViewPresented = false
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.primary500)
                                    .frame(width: 275, height: 45)
                                    .overlay {
                                        Text("완료")
                                            .font(.pretendard(weight: .p6, size: 13))
                                            .foregroundStyle(.white)
                                    }
                            }
                        }
                    }
            }
        } else {
            // 신청한 웨이팅 정보 요청 실패 시
        }
    }
}

#Preview {
    WaitingCompleteView(isWaitingCompleteViewPresented: .constant(false))
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
}
