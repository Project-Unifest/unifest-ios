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
    @ObservedObject var networkManager = NetworkManager()
    
    // @State private var viewState: ViewState = .home
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
                            GATracking.eventScreenView(GATracking.ScreenNames.homeView)
                        }
                        .tabItem {
                            // Image(viewState == .home ? .homeIcon : .homeGray)
                            // Text(StringLiterals.Root.home)
                            Label(StringLiterals.Root.home, systemImage: "house.circle")
                        }
                        .tag(0)
                    
                    MapPageView(mapViewModel: mapViewModel, boothModel: boothModel)
                        .onAppear {
                            mapViewModel.startUpdatingLocation()
                            GATracking.eventScreenView(GATracking.ScreenNames.mapView)
                        }
                        .onDisappear {
                            mapViewModel.stopUpdateLocation()
                        }
                        .tabItem {
                            // Image(viewState == .map ? .mapIcon : .mapGray)
                            // Text(StringLiterals.Root.map)
                            Label(StringLiterals.Root.map, systemImage: "map.circle")
                        }
                        .tag(1)
                    
                    WaitingView(viewModel: viewModel, tabViewSelection: $tabViewSelection)
                        .onAppear {
                            GATracking.eventScreenView(GATracking.ScreenNames.waitingView)
                        }
                        .tabItem {
                            // Image(viewState == .waiting ? .waitingIcon : .waitingGray)
                            // Text(StringLiterals.Root.waiting)
                            Label(StringLiterals.Root.waiting, systemImage: "hourglass.circle")
                        }
                        .tag(2)
                    
                    MenuView(boothModel: boothModel)
                        .onAppear {
                            GATracking.eventScreenView(GATracking.ScreenNames.menuView)
                        }
                        .tabItem {
                            // Image(viewState == .menu ? .menuIcon : .menuGray)
                            // Text(StringLiterals.Root.menu)
                            Label(StringLiterals.Root.menu, systemImage: "line.3.horizontal.circle")
                        }
                        .tag(3)
                }
            }
            
            if !networkManager.isConnected {
                NetworkErrorView(errorType: .network)
                    .onAppear {
                        GATracking.eventScreenView(GATracking.ScreenNames.networkErrorView)
                    }
            }
            
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.2).ignoresSafeArea()
                    ProgressView()
                }
            }
        }
        .onAppear {
            boothModel.loadLikeBoothListDB()
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
