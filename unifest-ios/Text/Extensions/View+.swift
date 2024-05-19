//
//  View+.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/19/24.
//

import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func onReadSize(_ perform: @escaping (CGSize) -> Void) -> some View {
        self.customBackground {
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        }
        .onPreferenceChange(SizePreferenceKey.self, perform: perform)
    }

    @ViewBuilder
    func customBackground<V: View>(alignment: Alignment = .center, @ViewBuilder content: () -> V) -> some View {
        self.background(alignment: alignment, content: content)
    }
    
    @ViewBuilder
    func roundedButton(background: Color, strokeColor: Color, height: CGFloat, cornerRadius: CGFloat) -> some View {
        if #available(iOS 17, *) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(background)
                .stroke(strokeColor)
                .frame(height: height)
        } else {
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(background)
                    .frame(height: height)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor)
                    .frame(height: height)
            }
        }
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { }
}

#Preview {
    VStack {
        Text("")
            .roundedButton(background: .white, strokeColor: .accent, height: 30, cornerRadius: 15)
            .padding()
    }
}
