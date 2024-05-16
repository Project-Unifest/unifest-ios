//
//  LikedBoothBoxView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/14/24.
//

import Foundation
import SwiftUI

struct LikedBoothBoxView: View {
    @ObservedObject var boothModel: BoothModel
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
                HStack {
                    Text(name)
                        .font(.system(size: 18))
                        .fontWeight(.semibold)
                        .foregroundStyle(.darkGray)
                    
                    Spacer()
                    
                    Button {
                        GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_BOOTH_LIKE_CANCEL, params: ["boothID": boothID])
                        boothModel.deleteLikeBoothListDB(boothID)
                    } label: {
                        Image(.pinkBookMark)
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
        .frame(height: 90)
        .padding(.horizontal)
    }
}
