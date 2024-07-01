//
//  WaitingInfoView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/4/24.
//

import SwiftUI

struct WaitingInfoView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(.gray)
            .frame(width: 355, height: 160)
            .overlay {
                VStack(spacing: 10) {
                    HStack {
                        Text("현재 내 순서")
                            .font(.system(size: 14))
                        
                        Spacer()
                        
                        Image(.blackMarker)
                            .resizable()
                            .frame(width: 10.66, height: 14.38)
                        Text("컴공 주점")
                            .font(.system(size: 15))
                            .bold()
                    }
                    
                    HStack {
                        HStack(spacing: 2) {
                            VStack {
                                Spacer()
                                Text("35")
                                    .font(.system(size: 40))
                                    .bold()
                                    .foregroundStyle(.defaultPink)
                            }
                            
                            VStack {
                                Spacer()
                                Text("번째")
                            }
                        }
                        
                        Spacer()
                        
                        VStack {
                            Spacer()
                            HStack(spacing: 5) {
                                Text("웨이팅 번호")
                                    .font(.system(size: 14))
                                Text("112")
                                    .font(.system(size: 14))
                                    .bold()
                                
                                Divider()
                                    .padding(.horizontal, 7)
                                    .frame(height: 14)
                                
                                Text("인원")
                                    .font(.system(size: 14))
                                Text("3")
                                    .font(.system(size: 14))
                                    .bold()
                            }
                        }
                    }
                    
                    HStack {
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightGray)
                                .frame(width: 158, height: 44)
                                .overlay {
                                    Text("웨이팅 취소")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                }
                        }
                        
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.lightGray)
                                .frame(width: 158, height: 44)
                                .overlay {
                                    Text("부스 확인하기")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                }
                        }
                    }
                }
                .padding()
            }
    }
}

#Preview {
    WaitingInfoView()
}
