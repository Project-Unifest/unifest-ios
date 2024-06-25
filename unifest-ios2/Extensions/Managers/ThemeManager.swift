//
//  ThemeManager.swift
//  unifest-ios2
//
//  Created by Hoeun Lee on 6/25/24.
//

import SwiftUI

enum AppColorScheme: String {
    case light = "라이트"
    case dark = "다크"
    case system = "시스템"
}

class ThemeManager: ObservableObject {
    @Published var colorScheme: AppColorScheme = .system
    static let shared = ThemeManager()
    
    func getCurrentColorScheme() -> ColorScheme? {
        switch self.colorScheme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }
}
