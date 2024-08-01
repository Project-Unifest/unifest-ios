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
                            .font(.pretendard(weight: .p4, size: 14))
                        
                        Spacer()
                        
                        Image(.blackMarker)
                            .resizable()
                            .frame(width: 10.66, height: 14.38)
                        Text("컴공 주점")
                            .font(.pretendard(weight: .p6, size: 15))
                    }
                    
                    HStack(alignment: .bottom) {
                        HStack(alignment: .bottom, spacing: 2) {
                                Text("20")
                                    .font(.pretendard(weight: .p7, size: 45))
                                    .foregroundStyle(.defaultPink)
                            
                                Text("번째")
                                    .font(.pretendard(weight: .p5, size: 16))
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
                                Text("112")
                                    .font(.pretendard(weight: .p7, size: 14))
                                
                                Divider()
                                    .padding(.horizontal, 7)
                                    .frame(height: 14)
                                
                                Text("인원")
                                Text("3")
                                    .font(.pretendard(weight: .p7, size: 14))
                            }
                            .font(.pretendard(weight: .p4, size: 14))
                            .baselineOffset(9)
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
                                        .font(.pretendard(weight: .p5, size: 14))
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
                                        .font(.pretendard(weight: .p5, size: 14))
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
