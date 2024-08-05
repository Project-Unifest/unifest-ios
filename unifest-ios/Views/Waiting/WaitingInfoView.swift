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
            .fill(Color.ufWhite)
            .shadow(color: Color.black.opacity(0.12), radius: 7, y: 3)
            .frame(width: 355, height: 160)
            .overlay {
                VStack(spacing: 10) {
                    HStack {
                        Text("현재 내 순서")
                            .font(.pretendard(weight: .p4, size: 14))
                            .foregroundStyle(.grey900)
                        
                        Spacer()
                        
                        Image(.marker)
                            .resizable()
                            .frame(width: 10.66, height: 14.38)
                        Text("컴공 주점")
                            .font(.pretendard(weight: .p6, size: 15))
                            .foregroundStyle(.grey900)
                    }
                    
                    HStack(alignment: .bottom) {
                        HStack(alignment: .bottom, spacing: 2) {
                                Text("20")
                                    .font(.pretendard(weight: .p6, size: 45))
                                    .foregroundStyle(.primary500)
                            
                                Text("번째")
                                    .font(.pretendard(weight: .p5, size: 16))
                                    .foregroundStyle(.grey900)
                                    .baselineOffset(9)
                            
//                            Text("입장해주세요")
//                                .font(.pretendard(weight: .p7, size: 30))
//                                .foregroundStyle(.defaultPink)
//                                .baselineOffset(4)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Spacer()
                            HStack(spacing: 5) {
                                Text("웨이팅 번호")
                                    .font(.pretendard(weight: .p4, size: 14))
                                Text("112")
                                    .font(.pretendard(weight: .p7, size: 14))
                                
                                Divider()
                                    .foregroundStyle(.grey400)
                                    .padding(.horizontal, 7)
                                    .frame(height: 14)
                                
                                Text("인원")
                                    .font(.pretendard(weight: .p4, size: 14))
                                Text("3")
                                    .font(.pretendard(weight: .p7, size: 14))
                            }
                            .foregroundStyle(.grey900)
                            .baselineOffset(9)
                        }
                    }
                    
                    HStack {
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.grey100)
                                .frame(width: 158, height: 44)
                                .overlay {
                                    Text("웨이팅 취소")
                                        .font(.pretendard(weight: .p7, size: 14))
                                        .foregroundStyle(.primary500)
                                }
                        }
                        
                        Button {
                            
                        } label: {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.grey100)
                                .frame(width: 158, height: 44)
                                .overlay {
                                    Text("부스 확인하기")
                                        .font(.pretendard(weight: .p7, size: 14))
                                        .foregroundStyle(.grey700)
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
