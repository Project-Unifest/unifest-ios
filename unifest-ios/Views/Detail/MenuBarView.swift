//
//  MenuBarView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/2/24.
//

import SwiftUI

// DetailView에서 메뉴를 보여주는 뷰가 MenuBarView임

struct MenuBarView: View {
    let imageURL: String
    let name: String
    let price: Int
    @Binding var isMenuImagePresented: Bool
    @Binding var selectedMenu: SelectedMenuInfo
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 86, height: 86)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .onTapGesture {
                        selectedMenu.selectedMenuURL = imageURL
                        selectedMenu.selectedMenuName = name
                        selectedMenu.selectedMenuPrice = formattedPrice(price) + StringLiterals.Detail.won
                        withAnimation(.spring(duration: 0.1)) {
                            isMenuImagePresented = true
                        }
                    }
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
            }
            .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.pretendard(weight: .p6, size: 14))
                    .foregroundStyle(.grey600)
                    .padding(.bottom, 1)
                
                if price == 0 {
                    Text("무료")
                        .font(.pretendard(weight: .p6, size: 16))
                        .foregroundStyle(.grey900)
                } else {
                    Text(formattedPrice(price) + StringLiterals.Detail.won)
                        .font(.pretendard(weight: .p6, size: 16))
                        .foregroundStyle(.grey900)
                }
            }
            
            Spacer()
        }
        .background(colorScheme == .dark ? Color.grey100 : Color.white)
    }
    
    func formattedPrice(_ price: Int) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
                return "\(formattedPrice)"
            } else {
                return "\(price)"
            }
        }
}
