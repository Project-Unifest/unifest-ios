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
                    
                    HStack(alignment: .bottom) {
                        Text("\(text)")
                            .font(.pretendard(weight: .p6, size: 20))
                            .foregroundStyle(.grey900)
                        Spacer()
                    }
                }
                .padding()
            }
    }
}

#Preview {
    NavigationHeaderView(text: "메뉴")
}
