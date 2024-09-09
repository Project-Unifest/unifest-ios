//
//  ToastView.swift
//  unifest-ios
//
//  Created by 임지성 on 8/24/24.
//

import SwiftUI

struct ToastView: View {
    var style: ToastStyle
    var message: String
    var width = CGFloat.infinity
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color.grey800)
            .frame(minWidth: 0, maxWidth: width, minHeight: 38, maxHeight: 38)
            .overlay {
                HStack(alignment: .center, spacing: 12) {
//                    Image(systemName: style.iconFileName)
//                        .foregroundColor(style.themeColor)
                    
                    Spacer()
                    
                    Text(message)
                        .font(.pretendard(weight: .p4, size: 13))
                        // .foregroundStyle(.grey900)
                        .foregroundStyle(.white)
                    
//                    Spacer(minLength: 10)
//                    
//                    Button {
//                        onCancelTapped()
//                    } label: {
//                        Image(systemName: "xmark")
//                            .foregroundColor(style.themeColor)
//                    }
                    
                    Spacer()
                }
                .padding()
            }
            .padding()
            // .shadow(color: Color.grey300, radius: 7)
    }
}


#Preview {
    ToastView(style: .success, message: "웨이팅을 취소했습니다", onCancelTapped: {})
}
