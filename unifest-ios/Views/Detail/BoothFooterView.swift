//
//  BoothFooterView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/21/24.
//

import SwiftUI

struct BoothFooterView: View {
    @ObservedObject var viewModel: RootViewModel
    @Binding var isReloadButtonPresent: Bool
    @Binding var isWaitingPinViewPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    
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
                            .font(.system(size: 10))
                            .foregroundStyle(.darkGray)
                    } else {
                        Text("\(viewModel.boothModel.selectedBoothNumLike > 0 ? viewModel.boothModel.selectedBoothNumLike : 0)")
                            .font(.system(size: 10))
                            .foregroundStyle(.darkGray)
                    }
                }
                .padding(.top, 8)
                
                Button {
                    withAnimation {
                        isWaitingPinViewPresented = true
                    }
                } label: {
                    Text("")
//                        .roundedButton(background: .defaultDarkGray, strokeColor: .clear, height: 45, cornerRadius: 10)
                        .roundedButton(background: .primary500, strokeColor: .clear, height: 45, cornerRadius: 10)
                        .overlay {
//                            if viewModel.boothModel.selectedBooth == nil {
//                                if !isReloadButtonPresent {
//                                    ProgressView()
//                                } else {
//                                    Text(StringLiterals.Detail.noWaitingBooth)
//                                        .foregroundStyle(.white)
//                                        .font(.system(size: 14))
//                                        .bold()
//                                }
//                            } else {
//                                Text(StringLiterals.Detail.noWaitingBooth)
                            Text("웨이팅 신청")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 14))
                                    .bold()
                            //}
                        }
                }
                // .disabled(true)
                
                Spacer()
                    .frame(width: 20)
            }
        }
        .frame(maxWidth: .infinity)
        .background(colorScheme == .dark ? Color.grey200 : Color.white)
        .shadow(color: .black.opacity(0.12), radius: 18.5, x: 0, y: -4)
    }
    
}

#Preview {
    BoothFooterView(viewModel: RootViewModel(), isReloadButtonPresent: .constant(true), isWaitingPinViewPresented: .constant(false))
}
