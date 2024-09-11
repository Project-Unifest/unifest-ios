//
//  OneImageView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/21/24.
//

import SwiftUI

// DetailView에서 MenuBarView의 사진 클릭 시
// DetailView에서 메뉴의 사진과 정보를 sheet로 보여주는 뷰

struct MenuImageView: View {
    @Binding var isPresented: Bool
    let menu: SelectedMenuInfo
    
    var body: some View {
        /* AsyncImage(url: URL(string: imageURL)) { image in
            image
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10.0))
        } placeholder: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.defaultLightGray)
                    .frame(width: 86, height: 86)
                
                Image(.noImagePlaceholder)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
        }*/
        
        ZStack {
            Color.black.opacity(0.8)
            
            VStack {
                Spacer()
                
                AsyncImage(url: URL(string: menu.selectedMenuURL)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            .frame(maxWidth: 353, maxHeight: 250)
                            .onTapGesture {
                                // touch 방지
                            }
                    case .failure:
                        VStack {
                            Image(.noImagePlaceholder)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .padding(.bottom, 10)
                            
                            Text("이미지를 불러올 수 없습니다")
                                .font(.system(size: 15))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    @unknown default:
                        VStack {
                            Image(.noImagePlaceholder)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            
                            Text("이미지를 불러올 수 없습니다")
                                .font(.system(size: 15))
                                .foregroundStyle(.white.opacity(0.5))
                        }
                    }
                }
                .padding()
                
                Text(menu.selectedMenuName)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .padding(.bottom, 2)
                    .multilineTextAlignment(.center)
                
                Text(menu.selectedMenuPrice)
                    .font(.system(size: 14))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
        }
        .onTapGesture {
            withAnimation(.spring(duration: 0.1)) {
                isPresented = false
            }
        }
        // .materialBackground()
        .ignoresSafeArea()
    }
}

#Preview {
    MenuImageView(isPresented: .constant(true), menu: SelectedMenuInfo(selectedMenuURL: "https://unifest-prod-bucket.s3.ap-northeast-2.amazonaws.com/622cbe51-ff51-4276-a605-e7f1cfa1e60d.png", selectedMenuName: "메뉴 이름", selectedMenuPrice: "10,000원"))
}
