//
//  LikedBoothBoxView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/14/24.
//

import Foundation
import SwiftUI

struct LikedBoothBoxView: View {
    @ObservedObject var viewModel: RootViewModel
    let boothID: Int
    let image: String
    let name: String
    let description: String
    let location: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: image)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 86, height: 86)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.lightGray)
                        .frame(width: 86, height: 86)
                    
                    Image(.noImagePlaceholder)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                }
                .frame(width: 86, height: 86)
            }
            .padding(.trailing, 4)
            
            /* Image(image)
             .resizable()
             .scaledToFill()
             .frame(width: 86, height: 86)
             .clipShape(RoundedRectangle(cornerRadius: 10))
             .padding(.trailing, 4)*/
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.pretendard(weight: .p6, size: 18))
                    .foregroundStyle(.grey900)
                    .lineLimit(1)
                    .padding(.top, 5)
                
                /* Button {
                 GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_BOOTH_LIKE_CANCEL, params: ["boothID": boothID])
                 viewModel.boothModel.deleteLikeBoothListDB(boothID)
                 } label: {
                 Image(.pinkBookMark)
                 }*/
                
                Text(description)
                    .font(.pretendard(weight: .p6, size: 13))
                    .foregroundStyle(.grey600)
                    .lineLimit(2)
                    .padding(.top, -7)
                
                Spacer()
                
                HStack(spacing: 2) {
                    Image(.marker)
                        .padding(.trailing, 5)
                    Text(location)
                        .font(.pretendard(weight: .p6, size: 13))
                        .foregroundStyle(.grey700)
                        .lineLimit(1)
                    Spacer()
                }
                .padding(.bottom, 6)
            }
        }
        .background(.ufBackground)
        .frame(height: 90)
        // .padding(.horizontal)
    }
}

#Preview {
    LikedBoothBoxView(viewModel: RootViewModel(), boothID: 1, image: "", name: "Example Booth", description: "Example Description", location: "Example Location")
}

