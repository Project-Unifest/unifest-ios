//
//  RootViewModel.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import Foundation
import SwiftUI

class RootViewModel: ObservableObject {
    @Published var viewState: ViewState = .home
    @Published var isLoading: Bool = false
    
    func transtion(to: ViewState) {
        withAnimation(.spring(duration: 0.2, bounce: 0.3)) {
            viewState = to
        }
    }
    
    func checkFirstLaunch() {
        let isFirstLaunch = UserDefaults.standard.bool(forKey: "isFirstLaunch")
        if isFirstLaunch {
            self.transtion(to: .intro)
        } else {
            self.transtion(to: .home)
        }
    }
}
