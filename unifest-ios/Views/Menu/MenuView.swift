//
//  MenuView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import SwiftUI

struct MenuView: View {
    @State private var isListViewPresented: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                Spacer()
                    .frame(height: 56)
                
                HStack {
                    Text("나의 관심학교")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        HStack(spacing: 0) {
                            Text("추가하기")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                                .underline()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                // LazyHGrid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 5), spacing: 25) {
                    circleSchoolView(image: .konkukLogo, name: "건국대")
                    circleSchoolView(image: .chungangLogo, name: "중앙대")
                    circleSchoolView(image: .uosLogo, name: "한국외대")
                    circleSchoolView(image: .konkukLogo, name: "건국대")
                    circleSchoolView(image: .chungangLogo, name: "중앙대")
                    circleSchoolView(image: .uosLogo, name: "한국외대")
                    circleSchoolView(image: .konkukLogo, name: "건국대")
                    circleSchoolView(image: .chungangLogo, name: "중앙대")
                    circleSchoolView(image: .uosLogo, name: "한국외대")
                }
                .padding(.horizontal)
                
                Image(.boldLine)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                
                HStack {
                    Text("관심 부스")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    Button {
                        isListViewPresented.toggle()
                    } label: {
                        HStack(spacing: 0) {
                            Text("더보기")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                                .underline()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
                
                VStack {
                    boothBox(image: .tempBack, name: "부스명", description: "부스 설명", location: "부스 위치", isFavor: false)
                        .padding(.vertical, 10)
                    Divider()
                    boothBox(image: .tempBack, name: "부스명", description: "부스 설명", location: "부스 위치", isFavor: true)
                        .padding(.vertical, 10)
                }
                
                Image(.boldLine)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 0)
                
                Button {
                    
                } label: {
                    HStack {
                        Image(systemName: "headphones.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 8)
                        
                        Text("이용문의")
                            .font(.system(size: 15))
                            .foregroundStyle(.darkGray)
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Divider()
                
                Button {
                    if let url = URL(string: "https://naver.com") {
                            UIApplication.shared.open(url, options: [:])
                        }
                } label: {
                    HStack {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 8)
                        
                        Text("운영자 모드")
                            .font(.system(size: 15))
                            .foregroundStyle(.darkGray)
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Divider()
                
                Spacer()
            }
            .padding(.top, 32)
            
            VStack {
                NavigationHeaderView(text: "메뉴")
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func circleSchoolView(image: ImageResource, name: String) -> some View {
        VStack(spacing: 8) {
            Circle()
                .fill(.background)
                .frame(width: 58, height: 58)
                .shadow(color: .black.opacity(0.1), radius: 6.67, x: 0, y: 1)
                .overlay {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46, height: 46)
                }
            
            Text(name)
                .font(.system(size: 12))
                .fontWeight(.medium)
                .foregroundStyle(.darkGray)
        }
    }
    
    @ViewBuilder
    func boothBox(image: ImageResource, name: String, description: String, location: String, isFavor: Bool) -> some View {
        HStack {
            Image(image)
                .resizable()
                .scaledToFill()
                .frame(width: 86, height: 86)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.trailing, 4)
                
            VStack(alignment: .leading) {
                HStack {
                    Text(name)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(.darkGray)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(isFavor ? .pinkBookMark : .bookmark)
                    }
                }
                
                Text(description)
                    .font(.system(size: 13))
                    .fontWeight(.semibold)
                    .foregroundStyle(.darkGray)
                
                Spacer()
                
                HStack(spacing: 2) {
                    Image(.marker)
                    Text(location)
                        .font(.system(size: 13))
                        .fontWeight(.semibold)
                        .foregroundStyle(.darkGray)
                    Spacer()
                }
                
            }
        }
        .padding(.horizontal)
        .fullScreenCover(isPresented: $isListViewPresented, content: {
            LikeBoothListView()
        })
    }
}

#Preview {
    MenuView()
}
