//
//  RootView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel = RootViewModel()
    @ObservedObject var mapViewModel = MapViewModel()
    @State private var viewState: ViewState = .intro
    @State private var tabViewSelection: Int = 0
    
    var body: some View {
        switch viewModel.viewState {
        case .intro:
            IntroView(viewModel: viewModel)
        case .home, .map, .waiting, .menu:
            TabView(selection: $tabViewSelection) {
                CalendarTabView(viewModel: viewModel)
                    .onAppear {
                        viewState = .home
                    }
                    .tabItem {
                        Image(viewState == .home ? .homeIcon : .homeGray)
                        Text("홈")
                    }
                
                MapPageView(mapViewModel: mapViewModel)
                    .onAppear {
                        viewState = .map
                        mapViewModel.startUpdatingLocation()
                    }
                    .onDisappear {
                        mapViewModel.stopUpdateLocation()
                    }
                    .tabItem {
                        Image(viewState == .map ? .mapIcon : .mapGray)
                        Text("지도")
                    }
                
                WaitingView(viewModel: viewModel)
                    .onAppear {
                        viewState = .waiting
                    }
                    .tabItem {
                        Image(viewState == .waiting ? .waitingIcon : .waitingGray)
                        Text("웨이팅")
                    }
                
                MenuView()
                    .onAppear {
                        viewState = .menu
                    }
                    .tabItem {
                        Image(viewState == .menu ? .menuIcon : .menuGray)
                        Text("메뉴")
                    }
            }
        }
    }
}

enum ViewState {
    case intro
    case home
    case map
    case waiting
    case menu
}

#Preview {
    RootView()
}
