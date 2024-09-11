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
            .fill(Color.ufBackground)
            .frame(minWidth: 0, maxWidth: width, minHeight: 38, maxHeight: 50)
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style.themeColor, lineWidth: 2.5)
            }
            .overlay {
                HStack(alignment: .center, spacing: 12) {
//                    Image(systemName: style.iconFileName)
//                        .foregroundColor(style.themeColor)
                    
                    Spacer()
                    
                    Text(message)
                        .font(.pretendard(weight: .p4, size: 13))
                        .foregroundStyle(.grey900)
                        .fixedSize(horizontal: false, vertical: true)
                        .lineLimit(3)
                    
                    // Spacer(minLength: 10)
                    
                    Spacer()
                    
//                    Button {
//                        onCancelTapped()
//                    } label: {
//                        Image(systemName: "xmark")
//                            .foregroundColor(style.themeColor)
//                    }
                }
                .padding()
            }
            .dynamicTypeSize(.large)
            .padding()
            // .shadow(color: Color.grey300, radius: 7)
    }
}


#Preview {
    ToastView(style: .success, message: "웨이팅을 취소했습니다", onCancelTapped: {})
}
