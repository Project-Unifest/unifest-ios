//
//  NumExtensions.swift
//  unifest-ios
//
//  Created by 임지성 on 11/30/24.
//

import Foundation

extension Int {
    func formatterStyle(_ numberStyle: NumberFormatter.Style) -> String? {
        let numberFommater: NumberFormatter = NumberFormatter()
        numberFommater.numberStyle = numberStyle
        return numberFommater.string(for: self)
    }
}
