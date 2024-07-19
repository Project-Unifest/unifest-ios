//
//  WaitingCompleteView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/1/24.
//

import SwiftUI

struct WaitingCompleteView: View {
    @State private var number: Int = 2
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.66)
                .ignoresSafeArea()
            
            Image(.waitingBackground)
                .resizable()
                .frame(width: 301, height: 290)
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                                .frame(width: 15, height: 15)
                            
                            Spacer()
                            
                            Image(.marker)
                            Text("컴공 주점")
                                .font(.system(size: 15))
                                .fontWeight(.semibold)
                            
                            Spacer()
                            
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                        
                        Text("웨이팅 등록 완료!")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .padding(.bottom, 1)
                        
                        Text("입장 순서가 되면 안내 해드릴게요.")
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                        
                        Divider()
                            .padding(.horizontal)
                            .padding(.bottom, 4)
                        
                        HStack {
                            Spacer()
                            VStack(spacing: 8) {
                                Text("웨이팅 번호")
                                    .font(.system(size: 13))
                                    .fontWeight(.medium)
                                Text("112번")
                                    .font(.system(size: 20))
                                    .bold()
                            }
                            
                            Spacer()
                            Text("∙")
                                .font(.system(size: 13))
                                .foregroundStyle(.gray)
                            Spacer()
                            
                            VStack(spacing: 8) {
                                Text("인원 수")
                                    .font(.system(size: 13))
                                    .fontWeight(.medium)
                                Text("3명")
                                    .font(.system(size: 20))
                                    .bold()
                            }
                            
                            Spacer()
                            Text("∙")
                                .font(.system(size: 13))
                                .foregroundStyle(.gray)
                            Spacer()
                            
                            VStack(spacing: 8) {
                                Text("내 앞 웨이팅")
                                    .font(.system(size: 13))
                                    .fontWeight(.medium)
                                Text("35팀")
                                    .font(.system(size: 20))
                                    .bold()
                            }
                            Spacer()
                        }
                        .padding()
                        
                        HStack {
                            Button {
                                
                            } label: {
                                Image(.shortGrayButton)
                                    .overlay {
                                        Text("웨이팅 취소")
                                            .font(.system(size: 13))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.darkGray)
                                    }
                            }
                            
                            Button {
                                
                            } label: {
                                Image(.shortPinkButton)
                                    .overlay {
                                        Text("순서 확인하기")
                                            .font(.system(size: 13))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.white)
                                    }
                            }
                        }
                    }
                }
        }
    }
}

#Preview {
    WaitingCompleteView()
}
