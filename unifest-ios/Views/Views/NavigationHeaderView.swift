//
//  NavigationHeaderView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 4/5/24.
//

import SwiftUI

struct NavigationHeaderView: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .bottom) {
            Text(text)
                .font(.system(size: 20))
                .fontWeight(.semibold)
                .foregroundStyle(.defaultBlack)
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
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        NavigationHeaderView(text: "메뉴")
    }
}
