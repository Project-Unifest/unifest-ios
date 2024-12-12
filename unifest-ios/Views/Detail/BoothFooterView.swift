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
    @Binding var isNoshowDialogPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    @State private var isNotificationNotPermittedAlertPresented: Bool = false
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                
                HStack {
                    // 사용자가 좋아요 처리한 부스는 서버가 아니라 로컬(UserDefaults)에 저장함
                    // 좋아요를 누르거나 해제하면 UserDefaults에서 해당 부스를 추가하거나 해제하고, 좋아요 수를 +-시키는 api를 호출함
                    VStack {
                        Button {
                            if viewModel.boothModel.isBoothContain(viewModel.boothModel.selectedBoothID) {
                                // 이미 부스를 관심있음(좋아요) 체크한 경우 -> 버튼을 누르면 로컬의 관심있음 부스 삭제, 서버 좋아요 수 -1 api 호출
                                GATracking.sendLogEvent(GATracking.LogEventType.BoothDetailView.BOOTH_DETAIL_LIKE_CANCEL, params: ["boothID": viewModel.boothModel.selectedBoothID])
                                viewModel.boothModel.deleteLikeBoothListDB(viewModel.boothModel.selectedBoothID)
                                viewModel.boothModel.deleteLike(viewModel.boothModel.selectedBoothID)
                            } else {
                                // 부스를 관심있음 하지 않은 경우 -> 버튼을 누르면 로컬에 관심있음 부스 추가, 서버 좋아요 수 +1 api 호출
                                GATracking.sendLogEvent(GATracking.LogEventType.BoothDetailView.BOOTH_DETAIL_LIKE_ADD, params: ["boothID": viewModel.boothModel.selectedBoothID])
                                viewModel.boothModel.insertLikeBoothDB(viewModel.boothModel.selectedBoothID)
                                viewModel.boothModel.addLike(viewModel.boothModel.selectedBoothID)
                            }
                        } label: {
                            Image(viewModel.boothModel.isBoothContain(viewModel.boothModel.selectedBoothID) ? .pinkBookMark : .bookmark)
                        }
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
                    .frame(width: 30)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await waitingVM.fetchReservedWaiting(deviceId: DeviceUUIDManager.shared.getDeviceToken())
                            
                            print("ReservedWaitingCount: \(waitingVM.reservedWaitingCount)")
                            
                            if let reservedWaitingList = waitingVM.reservedWaitingList {
                                for list in reservedWaitingList {
                                    if list.boothId == viewModel.boothModel.selectedBoothID {
                                        if list.status == "NOSHOW" {
                                            isNoshowDialogPresented = true
                                        } else {
                                            waitingVM.alreadyReservedToast = Toast(style: .warning, message: "이미 웨이팅 대기열에 존재합니다", bottomPadding: 51)
                                        }
                                        return // Task 내에서의 return은 일반 함수에서의 return과 동일한 방식으로 작동함
                                    }
                                }
                            }
                            
                            if waitingVM.reservedWaitingCount >= 3 {
                                waitingVM.reservedWaitingCountExceededToast = Toast(style: .warning, message: "웨이팅 신청은 최대 3개까지 가능합니다", bottomPadding: 51)
                                return
                            }
                            
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
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(viewModel.boothModel.selectedBooth?.waitingEnabled ?? false ? .primary500 : .grey600)
                            .frame(width: screenWidth * 0.805, height: 45)
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
                    
                    //                Spacer()
                    //                    .frame(width: 20)
                }
                .padding(.horizontal)
                .padding(.top, 7)
            }
            .frame(height: 60)
        }
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Color.grey200 : Color.white)
        .shadow(color: .black.opacity(0.12), radius: 18.5, x: 0, y: -4)
        .alert("웨이팅 알림 안내", isPresented: $isNotificationNotPermittedAlertPresented) {
            Button("다음에 설정할게요", role: nil) {
                withAnimation {
                    isWaitingPinViewPresented = true
                }
            }
            
            // role을 cancel로 설정하면 버튼이 하단에 위치하게 됨
            // 사용자가 더 자주 선택하거나 중요하다고 생각되는 액션을 하단에 배치하는게 컨벤션
            Button("설정 화면으로 이동", role: .cancel) {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("웨이팅 입장 알림을 받으려면 알림 권한을 허용해야돼요. 앱 설정에서 알림 권한을 수정할 수 있어요.")
        }
    }
    
}

#Preview {
    BoothFooterView(viewModel: RootViewModel(), isReloadButtonPresent: .constant(true), isWaitingPinViewPresented: .constant(false), isNoshowDialogPresented: .constant(false))
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
}
