//
//  AdminMainView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/26/24.
//

import SwiftUI

struct AdminMainView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                Text("운영중인 부스 없음")
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .padding(.bottom, 4)
                
                Text("부스를 추가하고 대기 손님들을 관리하세요")
                    .font(.system(size: 12))
                    .foregroundStyle(.darkGray)
                    .padding(.bottom)
                
                Button {
                    
                } label: {
                    Image(.smallWhiteButton)
                        .overlay {
                            Text("부스/주점 등록하기")
                                .font(.system(size: 13))
                                .foregroundStyle(.defaultBlack)
                        }
                }
                
                Spacer()
            }
            
            VStack {
                HStack {
                    Spacer()
                        .frame(width: 48, height: 30)
                    
                    Spacer()
                    
                    Text("컴공주점")
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.darkGray)
                    }
                    .padding(.trailing, 3)
                    .frame(width: 48, height: 30)
                }
                .padding(.horizontal)
                .padding(.bottom)
                .frame(maxWidth: .infinity)
                .background(.background)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 23,
                        bottomTrailingRadius: 23,
                        topTrailingRadius: 0
                    )
                )
                .shadow(color: .black.opacity(0.12), radius: 18.5, x: 0, y: -4)
                
                Spacer()
            }
            
            VStack {
                Text("")
            }
        }
    }
}

#Preview {
    AdminMainView()
}
