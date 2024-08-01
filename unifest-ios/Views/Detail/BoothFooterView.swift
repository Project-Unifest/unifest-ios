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
    @Binding var isWaitingRequestViewPresented: Bool
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 10)
            
            HStack {
                Spacer()
                    .frame(width: 10)
                
                VStack {
                    Button {
                        if viewModel.boothModel.isBoothContain(viewModel.boothModel.selectedBoothID) {
                            // delete
                            GATracking.sendLogEvent(GATracking.LogEventType.BoothDetailView.BOOTH_DETAIL_LIKE_CANCEL, params: ["boothID": viewModel.boothModel.selectedBoothID])
                            viewModel.boothModel.deleteLikeBoothListDB(viewModel.boothModel.selectedBoothID)
                            viewModel.boothModel.deleteLike(viewModel.boothModel.selectedBoothID)
                        } else {
                            // add
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
                    isWaitingRequestViewPresented = true
                } label: {
                    Text("")
//                        .roundedButton(background: .defaultDarkGray, strokeColor: .clear, height: 45, cornerRadius: 10)
                        .roundedButton(background: .defaultPink, strokeColor: .clear, height: 45, cornerRadius: 10)
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
        .background(.background)
        .shadow(color: .black.opacity(0.12), radius: 18.5, x: 0, y: -4)
    }
    
}

#Preview {
    BoothFooterView(viewModel: RootViewModel(), isReloadButtonPresent: .constant(true), isWaitingRequestViewPresented: .constant(false))
}
