//
//  FontExtension.swift
//  unifest-ios
//
//  Created by 임지성 on 7/19/24.
//

import SwiftUI

extension Font {
    enum PretendardFont {
        case p1, p2, p3, p4, p5, p6, p7, p8, p9
        
        var weight: String {
            switch self {
            case .p1:
                return "Pretendard-Thin"
            case .p2:
                return "Pretendard-ExtraLight"
            case .p3:
                return "Pretendard-Light"
            case .p4:
                return "Pretendard-Regular"
            case .p5:
                return "Pretendard-Medium"
            case .p6:
                return "Pretendard-SemiBold"
            case .p7:
                return "Pretendard-Bold"
            case .p8:
                return "Pretendard-ExtraBold"
            case .p9:
                return "Pretendard-Black"
            }
        }
    }
    
    static func pretendard(weight: PretendardFont, size: CGFloat) -> Font {
        return Font.custom(weight.weight, size: size)
    }
}
