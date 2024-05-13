//
//  LikeBoothListView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 4/5/24.
//

import SwiftUI

struct LikeBoothListView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            ScrollView {
                Spacer()
                    .frame(height: 32)
                
                boothBox(image: .tempBack, name: "부스명", description: "부스 설명", location: "부스 위치", isFavor: false)
                    .padding(.vertical, 10)
                Divider()
                boothBox(image: .tempBack, name: "부스명", description: "부스 설명", location: "부스 위치", isFavor: true)
                    .padding(.vertical, 10)
                boothBox(image: .tempBack, name: "부스명", description: "부스 설명", location: "부스 위치", isFavor: true)
                    .padding(.vertical, 10)
                boothBox(image: .tempBack, name: "부스명", description: "부스 설명", location: "부스 위치", isFavor: false)
                    .padding(.vertical, 10)
                boothBox(image: .tempBack, name: "부스명", description: "부스 설명", location: "부스 위치", isFavor: false)
                    .padding(.vertical, 10)
                boothBox(image: .tempBack, name: "부스명", description: "부스 설명", location: "부스 위치", isFavor: true)
                    .padding(.vertical, 10)
                boothBox(image: .tempBack, name: "부스명", description: "부스 설명", location: "부스 위치", isFavor: false)
                    .padding(.vertical, 10)
            }
            .padding(.top, 32)
            
            VStack {
                HStack(alignment: .bottom) {
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(.background)
                .frame(height: 32)
                .overlay {
                    Image(.navBottom)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .offset(y: 32)
                }
                .overlay {
                    HStack(alignment: .bottom) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.darkGray)
                        }
                        .frame(width: 20)
                        Spacer()
                        Text("관심 부스")
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundStyle(.black)
                        Spacer()
                        Spacer()
                            .frame(width: 20)
                    }
                    .offset(y: 4)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
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
    }
}

#Preview {
    LikeBoothListView()
}
