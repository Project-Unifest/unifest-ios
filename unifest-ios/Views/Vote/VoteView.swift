//
//  VoteView.swift
//  unifest-ios
//
//  Created by 임지성 on 10/9/24.
//

import SwiftUI

struct VoteView: View {
    @Environment(\.dismiss) var dismiss
    let major = ["컴퓨터공학부", "전기전자공학부", "기계공학과", "화학공학과", "생명공학과", "경영학과", "경제학과", "글로벌경영학과", "미디어커뮤니케이션학과", "동물자원학과", "물리학과", "수학과"]
    
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            
            ZStack {
                VStack {
                    HStack {
                        Text("투표할 과를 선택해주세요")
                            .font(.pretendard(weight: .p6, size: 30))
                            .foregroundStyle(.grey900)
                        
                        Spacer()
                    }
                    .padding(.top, 20)
                    
                    // 리스트 생성
                    List {
                        ForEach(major.indices, id: \.self) { index in
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.grey100)
                                .frame(width: screenWidth * 0.9, height: 60)
                                .listRowSeparator(.hidden)
                                .overlay {
                                    HStack {
                                        Text("\(index + 1)")
                                        Text(major[index])
                                            .padding(.leading)
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                    .font(.pretendard(weight: .p5, size: 27))
                                }
                            // 리스트를 탭했을 때
                            // 색 바꾸기, 크기 살짝 키우기, 햅틱 효과
                            // 다시 탭하면 원래대로 되돌리기
                            // 투표 완료 탭하면 마지막으로 확인시키는 다이얼로그 띄우기
                        }
                    }
                    .background(.ufBackground)
                    .listStyle(.plain)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.primary500)
                            .frame(width: 359, height: 51)
                            .overlay {
                                Text("투표하기")
                                    .font(.pretendard(weight: .p7, size: 14))
                                    .foregroundStyle(.white)
                            }
                    }
                    .padding(.bottom, 20)
                }
                .padding()
                .padding(.top, 100)
                
                VStack {
                    Rectangle()
                        .fill(Color.ufNetworkErrorBackground)
                        .frame(height: 115)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 23,
                                bottomTrailingRadius: 23,
                                topTrailingRadius: 0
                            )
                        )
                        .shadow(color: Color.black.opacity(0.1), radius: 10, y: 8)
                        .overlay {
                            VStack {
                                Spacer()
                                
                                HStack {
                                    Button {
                                        dismiss()
                                    } label: {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.darkGray)
                                    }
                                    .frame(width: 20)
                                    
                                    Spacer()
                                    
                                    Text("투표")
                                        .font(.pretendard(weight: .p6, size: 20))
                                        .foregroundStyle(.grey900)
                                    
                                    Spacer()
                                    Spacer()
                                        .frame(width: 20)
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 13)
                            }
                        }
                    
                    Spacer()
                }
            }
            .dynamicTypeSize(.large)
            .background(.ufBackground)
        .ignoresSafeArea()
        }
    }
}

#Preview {
    VoteView()
}
