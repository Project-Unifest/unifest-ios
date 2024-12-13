//
//  RootView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import SwiftUI
import UserNotifications

struct RootView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var networkManager: NetworkManager
    @StateObject var tabSelect = TabSelect() // 사용X
    @StateObject var waitingVM: WaitingViewModel
    @StateObject var favoriteFestivalVM: FavoriteFestivalViewModel
    @StateObject var stampVM: StampViewModel
    // @State private var viewState: ViewState = .home
    @State private var tabViewSelection: Int = 0
    @State private var isNetworkErrorViewPresented: Bool = false
    @State private var appVersionAlertPresented: Bool = false
    @State private var isWelcomeViewPresented: Bool = false
    @State private var isBoothDetailViewPresented: Bool = false
    @State private var isIntroViewPresented: Bool = false
    @State private var selectedBoothId = 0
    
    init(rootViewModel: RootViewModel, networkManager: NetworkManager) {
        self.viewModel = rootViewModel
        self.mapViewModel = MapViewModel(viewModel: rootViewModel)
        // self.networkManager = NetworkManager()
        // UITabBar.appearance().backgroundColor = UIColor(Color.grey100)
        self.networkManager = networkManager
        _waitingVM = StateObject(wrappedValue: WaitingViewModel(networkManager: networkManager))
        _favoriteFestivalVM = StateObject(wrappedValue: FavoriteFestivalViewModel(networkManager: networkManager))
        _stampVM = StateObject(wrappedValue: StampViewModel(networkManager: networkManager))
    }
    
    var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .intro:
                IntroView(viewModel: viewModel)
            case .home, .map, .waiting, .menu:
                ZStack {
                    TabView(selection: $tabSelect.selectedTab) {
                        Group {
                            HomeView(viewModel: viewModel)
                                .onAppear {
                                    HapticManager.shared.hapticImpact(style: .light)
                                    GATracking.eventScreenView(GATracking.ScreenNames.homeView)
                                }
                                .tabItem {
                                    // Image(viewState == .home ? .homeIcon : .homeGray)
                                    // Text(StringLiterals.Root.home)
                                    Label(StringLiterals.Root.home, systemImage: "house.circle")
                                }
                                .tag(0)
                            
                            WaitingView(viewModel: viewModel)
                                .onAppear {
                                    HapticManager.shared.hapticImpact(style: .light)
                                    GATracking.eventScreenView(GATracking.ScreenNames.waitingView)
                                }
                                .tabItem {
                                    // Image(viewState == .waiting ? .waitingIcon : .waitingGray)
                                    // Text(StringLiterals.Root.waiting)
                                    Label(StringLiterals.Root.waiting, systemImage: "hourglass.circle")
                                }
                                .tag(1)
                            
                            MapPageView(viewModel: viewModel, mapViewModel: mapViewModel)
                                .onAppear {
                                    HapticManager.shared.hapticImpact(style: .light)
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
                                .tag(2)
                            
                            StampView(viewModel: viewModel)
                                .onAppear {
                                    HapticManager.shared.hapticImpact(style: .light)
                                }
                                .tabItem {
                                    Label(StringLiterals.Root.stamp, systemImage: "star.circle")
                                }
                                .tag(3)
                            
                            MenuView(viewModel: viewModel)
                                .onAppear {
                                    HapticManager.shared.hapticImpact(style: .light)
                                    GATracking.eventScreenView(GATracking.ScreenNames.menuView)
                                }
                                .tabItem {
                                    // Image(viewState == .menu ? .menuIcon : .menuGray)
                                    // Text(StringLiterals.Root.menu)
                                    Label(StringLiterals.Root.menu, systemImage: "line.3.horizontal.circle")
                                }
                                .tag(4)
                        }
                        .toolbarBackground(Color.ufBackground, for: .tabBar)
                        .toolbarBackground(.visible, for: .tabBar)
                    }
                    
                    // TabView와 TabBar를 구분하는 구분선 명시적으로 선언
//                    VStack {
//                        Spacer()
//                        
//                        Divider()
//                            .frame(height: 1)
//                            .background(Color.grey100)
//                        
//                        Spacer().frame(height: 49) // 탭바 높이만큼 여백을 추가하여 탭바와의 겹침 방지
//                    }
                }
            }
            
            if waitingVM.cancelWaiting == true {
                WaitingCancelView()
            }
            
            if networkManager.isNetworkConnected == false {
                NetworkErrorView(errorType: .network)
                    .onAppear {
                        GATracking.eventScreenView(GATracking.ScreenNames.networkErrorView)
                    }
            }
            
            if networkManager.isServerError == true {
                NetworkErrorView(errorType: .server)
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
        .dynamicTypeSize(.large)
        .environmentObject(tabSelect)
        .environmentObject(waitingVM)
        .environmentObject(networkManager)
        .environmentObject(favoriteFestivalVM)
        .environmentObject(stampVM)
        .onAppear {
            if !UserDefaults.standard.bool(forKey: "IS_FIRST_LAUNCH") {
                isWelcomeViewPresented = true
            }
            UserDefaults.standard.setValue(true, forKey: "IS_CLUSTER_ON_MAP")
            
            viewModel.boothModel.loadLikeBoothListDB()
        }
        .task {
            let versionServce = VersionService.shared
            guard let latestVersion = try? await versionServce.loadAppStoreVersion() else { return }
            guard let currentVersion = versionServce.currentVersion() else { return }
            let cmpResult = currentVersion.compare(latestVersion, options: .numeric)
            versionServce.isOldVersion = cmpResult == .orderedAscending
            if versionServce.isOldVersion {
                print("This app is old. Updated Needed")
                appVersionAlertPresented = true
            } else {
                print("This app is latest.")
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NavigateToMapPage"))) { notification in
            // onReceive를 통해 AppDelegate에서 전송된 NotificationCenter의 알림 감지
            // 감지된 알림을 통해 boothId를 추출하고, tabSelect.selectedTab을 업데이트해 MapPageView로 이동한 뒤 BoothDetailView를 열어줌
            if let userInfo = notification.userInfo, let boothId = userInfo["boothId"] as? Int {
                // 탭 변경
                tabSelect.selectedTab = 2
                
                // BoothDetailView를 열기 위해 viewModel에 boothId를 설정
                selectedBoothId = boothId
                viewModel.boothModel.loadBoothDetail(boothId)
                
                isBoothDetailViewPresented = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("NavigateToWaitingTab"))) { _ in
            tabSelect.selectedTab = 1
        }
        .sheet(isPresented: $isBoothDetailViewPresented) {
            BoothDetailView(viewModel: viewModel, currentBoothId: selectedBoothId)
                .environmentObject(waitingVM)
                .environmentObject(networkManager)
                .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $isWelcomeViewPresented) {
            WelcomeView()
                .onAppear {
                    GATracking.eventScreenView(GATracking.ScreenNames.welcomeView)
                }
                .onDisappear {
                    UserDefaults.standard.set(true, forKey: "IS_FIRST_LAUNCH")
                    withAnimation(.easeInOut) {
                        isIntroViewPresented = true
                    }
                }
                .presentationDragIndicator(.visible)
        }
        .fullScreenCover(isPresented: $isIntroViewPresented) {
            IntroView(viewModel: viewModel)
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
            Text("새 버전이 출시되었습니다. 더 나은 사용자 경험을 위해 앱을 최신 버전으로 업데이트 해주세요.")
        })
    }
}

class TabSelect: ObservableObject {
    @Published var selectedTab: Int = 0
}

#Preview {
    RootView(rootViewModel: RootViewModel(), networkManager: NetworkManager())
        .environmentObject(WaitingViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
        .environmentObject(FavoriteFestivalViewModel(networkManager: NetworkManager()))
        .environmentObject(StampViewModel(networkManager: NetworkManager()))
}
