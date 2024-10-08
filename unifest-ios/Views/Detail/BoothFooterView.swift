//
//  BoothFooterView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/21/24.
//

import SwiftUI

struct BoothFooterView: View {
    @ObservedObject var viewModel: RootViewModel
    @EnvironmentObject var waitingVM: WaitingViewModel
    @Binding var isReloadButtonPresent: Bool
    @Binding var isWaitingPinViewPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    @State private var isNotificationNotPermittedAlertPresented: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            
            HStack {
                Spacer()
                    .frame(width: 10)
                
                // 사용자가 좋아요 처리한 부스는 서버가 아니라 로컬(UserDefaults)에 저장함
                // 좋아요를 누르거나 해제하면 UserDefaults에서 해당 부스를 추가하거나 해제하고, 좋아요 수를 +-시키는 api를 호출함
                VStack {
                    Button {
                        if viewModel.boothModel.isBoothContain(viewModel.boothModel.selectedBoothID) {
                            // 이미 부스를 관심있음(좋아요) 체크한 경우 -> 버튼을 누르면 관심있음 해제, 서버 좋아요 수 -1 api 호출
                            GATracking.sendLogEvent(GATracking.LogEventType.BoothDetailView.BOOTH_DETAIL_LIKE_CANCEL, params: ["boothID": viewModel.boothModel.selectedBoothID])
                            viewModel.boothModel.deleteLikeBoothListDB(viewModel.boothModel.selectedBoothID)
                            viewModel.boothModel.deleteLike(viewModel.boothModel.selectedBoothID)
                        } else {
                            // 부스를 관심있음 하지 않은 경우 -> 버튼을 누르면 관심있음 추가, 서버 좋아요 수 +1 api 호출
                            GATracking.sendLogEvent(GATracking.LogEventType.BoothDetailView.BOOTH_DETAIL_LIKE_ADD, params: ["boothID": viewModel.boothModel.selectedBoothID])
                            viewModel.boothModel.insertLikeBoothDB(viewModel.boothModel.selectedBoothID)
                            viewModel.boothModel.addLike(viewModel.boothModel.selectedBoothID)
                        }
                    } label: {
                        Image(viewModel.boothModel.isBoothContain(viewModel.boothModel.selectedBoothID) ? .pinkBookMark : .bookmark)
                    }
                    .padding(.horizontal, 10)
                    .disabled(viewModel.boothModel.selectedBooth == nil)
                    
                    if viewModel.boothModel.selectedBooth == nil {
                        Text("-")
                            .font(.system(size: 11))
                            .foregroundStyle(.darkGray)
                    } else {
                        Text("\(viewModel.boothModel.selectedBoothNumLike > 0 ? viewModel.boothModel.selectedBoothNumLike : 0)")
                            .font(.system(size: 11))
                            .foregroundStyle(.darkGray)
                    }
                }
                .padding(.top, 8)
                
                Button {
                    Task {
                        await waitingVM.fetchReservedWaiting(deviceId: UIDevice.current.deviceToken)
                        
                        print("ReservedWaitingCount: \(waitingVM.reservedWaitingCount)")
                        
                        if waitingVM.reservedWaitingCount > 3 {
                            waitingVM.reservedWaitingCountExceededToast = Toast(style: .warning, message: "웨이팅은 최대 3개까지 가능합니다", bottomPadding: 51)
                        } else {
                            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                            UNUserNotificationCenter.current().requestAuthorization(
                                options: authOptions) { granted, error in
                                    if granted { // 알림 권한이 설정 되어있음
                                        withAnimation {
                                            isWaitingPinViewPresented = true
                                        }
                                    } else { // 알림 권한이 설정 되어있지 않음
                                        isNotificationNotPermittedAlertPresented = true
                                    }
                                }
                        }
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(viewModel.boothModel.selectedBooth?.waitingEnabled ?? false ? .primary500 : .grey600)
                        .frame(width: 316, height: 45)
                        .overlay {
                            if let selectedBooth = viewModel.boothModel.selectedBooth {
                                if selectedBooth.waitingEnabled {
                                    Text("웨이팅 하기")
                                        .font(.pretendard(weight: .p7, size: 14))
                                        .foregroundStyle(.white)
                                } else {
                                    Text(StringLiterals.Detail.noWaitingBooth)
                                        .font(.pretendard(weight: .p7, size: 14))
                                        .foregroundStyle(.white)
                                }
                            } else {
                                if !isReloadButtonPresent {
                                    ProgressView()
                                } else {
                                    Text(StringLiterals.Detail.noWaitingBooth)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 14))
                                        .bold()
                                }
                            }
                        }
                }
                .disabled(viewModel.boothModel.selectedBooth?.waitingEnabled == false || viewModel.boothModel.selectedBooth?.waitingEnabled == nil)
                
                Spacer()
                    .frame(width: 20)
            }
        }
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Color.grey200 : Color.white)
        .shadow(color: .black.opacity(0.12), radius: 18.5, x: 0, y: -4)
        .alert("웨이팅 알림 안내", isPresented: $isNotificationNotPermittedAlertPresented) {
            Button("설정 앱으로 이동할래요", role: .cancel) {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
            
            Button("다음에 할게요", role: nil) {
                withAnimation {
                    isWaitingPinViewPresented = true
                }
            }
        } message: {
            Text("웨이팅 입장 안내를 받으려면 알림 권한을 허용해야돼요. 알림 권한 설정은 iPhone 설정 - 유니페스 에서 가능해요.")
        }
    }
    
}

#Preview {
    BoothFooterView(viewModel: RootViewModel(), isReloadButtonPresent: .constant(true), isWaitingPinViewPresented: .constant(false))
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
}
