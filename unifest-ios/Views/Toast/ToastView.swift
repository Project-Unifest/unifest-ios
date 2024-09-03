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
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.black)
            .frame(minWidth: 0, maxWidth: width, minHeight: 65, maxHeight: 65)
            .overlay {
                HStack(alignment: .center, spacing: 12) {
                    Image(systemName: style.iconFileName)
                        .foregroundColor(style.themeColor)
                    
                    Text(message)
                        .font(.pretendard(weight: .p4, size: 13))
                        // .foregroundStyle(.grey900)
                        .foregroundStyle(.white)
                    
                    Spacer(minLength: 10)
                    
                    Button {
                        onCancelTapped()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(style.themeColor)
                    }
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
