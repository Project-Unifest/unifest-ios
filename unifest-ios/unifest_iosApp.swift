//
//  unifest_iosApp.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/13/24.
//

import SwiftUI

@main
struct unifest_iosApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var mapViewModel = MapViewModel()
    
    var body: some Scene {
        WindowGroup {
            // ContentView()
            // MapView(mapViewModel: mapViewModel)
            IntroView()
        }
    }
}
