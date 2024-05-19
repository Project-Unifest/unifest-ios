//
//  RootView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var networkManager: NetworkManager
    
    // @State private var viewState: ViewState = .home
    @State private var tabViewSelection: Int = 0
    @State private var isNetworkAlertPresented: Bool = false
    
    @State private var appVersionAlertPresented: Bool = false
    
    @State private var isWelcomeViewPresented: Bool = false
    
    init(rootViewModel: RootViewModel) {
        self.viewModel = rootViewModel
        self.mapViewModel = MapViewModel(viewModel: rootViewModel)
        self.networkManager = NetworkManager()
    }
    
    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .intro:
                IntroView(viewModel: viewModel)
            case .home, .map, .waiting, .menu:
                TabView(selection: $tabViewSelection) {
                    CalendarTabView(viewModel: viewModel)
                        .onAppear {
                            GATracking.eventScreenView(GATracking.ScreenNames.homeView)
                        }
                        .tabItem {
                            // Image(viewState == .home ? .homeIcon : .homeGray)
                            // Text(StringLiterals.Root.home)
                            Label(StringLiterals.Root.home, systemImage: "house.circle")
                        }
                        .tag(0)
                    
                    MapPageView(viewModel: viewModel, mapViewModel: mapViewModel)
                        .onAppear {
                            mapViewModel.startUpdatingLocation()
                            GATracking.eventScreenView(GATracking.ScreenNames.mapView)
                        }
                        .onDisappear {
                            mapViewModel.stopUpdatingLocation()
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
                    
                    MenuView(viewModel: viewModel)
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
            if !UserDefaults.standard.bool(forKey: "IS_FIRST_LAUNCH") {
                isWelcomeViewPresented = true
            }
            
            viewModel.boothModel.loadLikeBoothListDB()
            
            if VersionService.shared.isOldVersion {
                print("This app is old. Updated Needed")
                appVersionAlertPresented = true
            } else {
                print("This app is latest.")
            }
        }
        .sheet(isPresented: $isWelcomeViewPresented) {
            WelcomeView()
                .onAppear {
                    GATracking.eventScreenView(GATracking.ScreenNames.welcomeView)
                }
                .onDisappear {
                    UserDefaults.standard.set(true, forKey: "IS_FIRST_LAUNCH")
                }
                .presentationDragIndicator(.visible)
        }
        .alert("유니페스 업데이트 안내", isPresented: $appVersionAlertPresented, actions: {
            Button("업데이트") {
                if let url = URL(string: VersionService.shared.appStoreOpenUrlString), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    // sleep(3)
                    // exit(0)
                }
            }
        }, message: {
            Text("새 버전이 출시되었습니다. 앱을 최신 버전으로 업데이트 해주세요.")
        })
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
    RootView(rootViewModel: RootViewModel())
}
