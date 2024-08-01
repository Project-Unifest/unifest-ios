//
//  unifest_iosApp.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/13/24.
//

import SwiftUI
import Firebase

@main
struct unifest_iosApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            RootView(rootViewModel: RootViewModel())
            // WaitingView(viewModel: RootViewModel(), tabViewSelection: .constant(2))
            // WaitingRequestView()
        }
    }
}
