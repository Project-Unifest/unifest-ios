//
//  StampView.swift
//  unifest-ios
//
//  Created by 임지성 on 8/30/24.
//

import SwiftUI

struct StampView: View {
    @ObservedObject var viewModel: RootViewModel
    @State private var rotationAmount = 0.0
    @State private var isStampBoothViewPresented = false
    
    var body: some View {
        VStack {
            HStack {
                Text("스탬프")
                    .font(.pretendard(weight: .p6, size: 21))
                    .foregroundStyle(.grey900)
                
                Spacer()
            }
            .padding(.bottom, 20)
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.ufBoxBackground)
                .frame(width: 353, height: 530)
                .overlay {
                    VStack {
                        HStack {
                            VStack {
                                Text("한국교통대학교")
                                    .font(.pretendard(weight: .p6, size: 20))
                                    .foregroundStyle(.grey900)
                                    .padding(.bottom, 3)
                                
                                Text("지금까지 모은 스탬프")
                                    .font(.pretendard(weight: .p4, size: 14))
                                    .foregroundStyle(.grey500)
                                    .padding(.trailing, 2)
                            }
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: Color(red: 1.0, green: 0.525, blue: 0.6), location: 0.0),
                                                .init(color: Color(red: 1.0, green: 0.258, blue: 0.392), location: 1.0),
                                                .init(color: Color(red: 0.937, green: 0.224, blue: 1.0), location: 1.0)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 140, height: 52)
                                    .overlay {
                                        Text("스탬프 받기")
                                            .font(.pretendard(weight: .p6, size: 18))
                                            .foregroundStyle(.ufWhite)
                                    }
                            }
                        }
                        .padding(.top, 18)
                        .padding(.bottom, 20)
                        
                        HStack {
                            HStack {
                                Text("1")
                                    .foregroundStyle(.grey900)
                                Text("/ 12개")
                                    .foregroundStyle(.grey500)
                            }
                            .font(.pretendard(weight: .p7, size: 24))
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Label("새로고침", systemImage: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.grey600)
                            }
                            .padding(.trailing, 8)
                        }
                        .padding(.bottom, 20)
                        
                        Grid {
                            ForEach(0 ..< 3) { row in
                                GridRow {
                                    ForEach(0 ..< 4) { _ in
                                        // 스탬프 개수에 따라
                                        // let emptyCircle = Circle() 생성하고
                                        // 현재 스탬프 개수 if문으로 emptyCircle 대신 Image(.appLogo) 띄우는 식?
                                        
                                        Circle()
                                            .fill(Color.grey200)
                                            .frame(width: 62, height: 62)
                                            .overlay {
                                                Image(.appLogo)
                                                    .resizable()
                                                    .frame(width: 62, height: 62)
                                                    .clipShape(Circle())
                                            }
                                            .onTapGesture {
                                                HapticManager.shared.hapticImpact(style: .light)
//                                                withAnimation(.spring(duration: 1, bounce: 0.7)) {
//                                                    rotationAmount += 360
//                                                }
                                            }
//                                            .rotation3DEffect(
//                                                .degrees(rotationAmount),
//                                                axis: (x: 1, y: 1, z: 1)
//                                            )
                                            .padding(.horizontal, 7)
                                            .padding(.vertical, 8)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 7)
                            .fill(Color.ufBackground)
                            .frame(width: 305, height: 50)
                            .overlay {
                                Button {
                                    isStampBoothViewPresented = true
                                } label: {
                                    HStack {
                                        Text("스탬프 부스 찾아보기")
                                            .font(.pretendard(weight: .p6, size: 15))
                                            .foregroundStyle(.grey700)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "chevron.right")
                                            .foregroundStyle(.grey700)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                            .padding(.bottom, 5)
                    }
                    .padding()
                }
            
            Spacer()
        }
        .padding()
        .background(.ufBackground)
        .sheet(isPresented: $isStampBoothViewPresented) {
            StampBoothListView(viewModel: viewModel)
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    StampView(viewModel: RootViewModel())
}
