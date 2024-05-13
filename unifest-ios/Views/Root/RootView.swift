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
    @ObservedObject var festivalModel = FestivalModel()
    @ObservedObject var boothModel = BoothModel()
    @State private var viewState: ViewState = .home
    @State private var tabViewSelection: Int = 0
    @State private var isNetworkAlertPresented: Bool = false
    
    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .intro:
                IntroView(viewModel: viewModel, festivalModel: festivalModel)
            case .home, .map, .waiting, .menu:
                TabView(selection: $tabViewSelection) {
                    CalendarTabView(viewModel: viewModel, festivalModel: festivalModel)
                        .onAppear {
                            viewState = .home
                        }
                        .tabItem {
                            Image(viewState == .home ? .homeIcon : .homeGray)
                            Text("홈")
                        }
                    
                    MapPageView(mapViewModel: mapViewModel, boothModel: boothModel)
                        .onAppear {
                            mapViewModel.startUpdatingLocation()
                            viewState = .map
                        }
                        .onDisappear {
                            mapViewModel.stopUpdateLocation()
                        }
                        .tabItem {
                            Image(viewState == .map ? .mapIcon : .mapGray)
                            Text("지도")
                        }
                    
                    WaitingView(viewModel: viewModel, tabViewSelection: $tabViewSelection)
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
            
            if !NetworkManager().isConnected {
                NetworkErrorView(errorType: .network)
            }
            
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView()
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
