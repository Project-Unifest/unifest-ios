//
//  MenuView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import SwiftUI
import UserNotifications

struct MenuView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var themeManager = ThemeManager()
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @EnvironmentObject var favoriteFestivalVM: FavoriteFestivalViewModel
    @EnvironmentObject var networkManager: NetworkManager
    @EnvironmentObject var tabSelect: TabSelect
    @State private var isListViewPresented: Bool = false
    @State private var isEditFavoriteFestivalViewPresented: Bool = false
    @State private var tappedBoothId = 0
    @State private var isDetailViewPresented: Bool = false
    @State private var randomLikeList: [Int] = []
    
    // 설정
    @State private var clusterToggle: Bool = true // 클러스터링 여부 설정
    @State private var subscribeFestival: Bool = UserDefaults.standard.bool(forKey: "subscribeFestival") // 관심축제 설정
    @State private var isNotificationNotPermittedAlertPresented: Bool = false
    @State private var isFavoriteFestivalRequestLoading: Bool = false
    
    // 권한 수정
    @State private var isLocationPermissionAlertPresented: Bool = false
    @State private var isCameraPermissionAlertPresented: Bool = false
    @State private var isNotificationPermissionAlertPresented: Bool = false
    
    // 메일
    @State private var isErrorDeclarationModalPresented: Bool = false
    @State private var isCopyFinishPresented: Bool = false
    
    // 앱 초기화
    @State private var isResetAlertPresented: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                Spacer()
                    .frame(height: 110)
                
                HStack {
                    Text(StringLiterals.Menu.LikedSchoolTitle)
                        .font(.pretendard(weight: .p7, size: 15))
                        .foregroundStyle(.grey900)
                    
                    Spacer()
                    
                    
                    Button {
                        isEditFavoriteFestivalViewPresented = true
                    } label: {
                        HStack(spacing: 0) {
                            Text("추가하기 >")
                                .font(.pretendard(weight: .p6, size: 11))
                                .foregroundColor(.grey600)
                                .underline()
                            //                            Image(systemName: "chevron.right")
                            //                                .font(.system(size: 10))
                            //                                .foregroundColor(.grey600)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                
                // LazyHGrid
                if subscribeFestival {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 5), spacing: 25) {
//                        Button {
//                            tabSelect.selectedTab = 2
//                        } label: {
//                            circleSchoolView(image: .uotLogo2, name: "한국교통대", festivalName: "Young:one")
//                        }
                    }
                    .padding(.horizontal)
                } else {
                        if favoriteFestivalVM.favoriteFestivalList.isEmpty {
                            VStack(alignment: .center) {
                                Text("관심축제 없음")
                                    .font(.pretendard(weight: .p6, size: 18))
                                    .foregroundStyle(.grey900)
                                    .padding(.bottom, 5)
                                
                                Text("관심축제를 등록해주세요")
                                    .font(.pretendard(weight: .p5, size: 13))
                                    .foregroundStyle(.grey600)
                                    .padding(.bottom, 10)
                            }
                            .frame(height: 150)
                            .padding(.horizontal)
                        } else {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    let favoriteFestivals = viewModel.festivalModel.festivalSearchResult.filter {
                                        favoriteFestivalVM.favoriteFestivalList.contains($0.festivalId)
                                    }
                                    
                                    ForEach(favoriteFestivals, id: \.festivalId) { festival in
                                        circleSchoolView(
                                            image: festival.thumbnail ?? "",
                                            name: festival.schoolName,
                                            festivalName: festival.festivalName
                                        )
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.vertical, 14)
                            }
                        }
                    }
                
                Text("")
                    .boldLine()
                    .padding(.vertical)
                
                // 관심부스 뷰
                // 관심부스는 사용자가 BoothFooter에서 저장 버튼을 탭하면 로컬에 저장함
                HStack {
                    Text(StringLiterals.Menu.LikedBoothTitle)
                        .font(.pretendard(weight: .p7, size: 15))
                        .foregroundStyle(.grey900)
                    
                    Spacer()
                    
                    if !viewModel.boothModel.likedBoothList.isEmpty {
                        // 체크한 관심 있는 부스가 있는 경우
                        Button {
                            isListViewPresented.toggle()
                        } label: {
                            HStack(spacing: 0) {
                                Text(StringLiterals.Menu.more)
                                    .font(.pretendard(weight: .p6, size: 11))
                                    .foregroundStyle(.grey600)
                                    .underline()
                                //                                Image(systemName: "chevron.right")
                                //                                    .font(.system(size: 11))
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                if viewModel.boothModel.likedBoothList.isEmpty || randomLikeList.isEmpty {
                    // 체크한 관심 있는 부스가 없는 경우
                    VStack(alignment: .center) {
                        Text(StringLiterals.Menu.noLikedBoothTitle)
                            .font(.pretendard(weight: .p6, size: 18))
                            .foregroundStyle(.grey900)
                            .padding(.bottom, 5)
                        
                        Text(StringLiterals.Menu.noLikedBoothMessage)
                            .font(.pretendard(weight: .p5, size: 13))
                            .foregroundStyle(.grey600)
                            .padding(.bottom, 10)
                    }
                    .frame(height: 150)
                } else {
//                    if #available(iOS 17, *) {
                        List {
                            ForEach(randomLikeList, id: \.self) { boothID in
                                if let booth = viewModel.boothModel.getBoothByID(boothID) {
                                    LikedBoothBoxView(viewModel: viewModel, boothID: boothID, image: booth.thumbnail, name: booth.name, description: booth.description, location: booth.location)
                                    // .padding(.vertical, 10)
                                        .listRowBackground(Color.ufBackground)
                                        .listRowSeparator(.hidden)
                                        .onTapGesture {
                                            GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_CLICK_BOOTH_ROW, params: ["boothID": boothID])
                                            viewModel.boothModel.loadBoothDetail(boothID)
                                            tappedBoothId = boothID
                                            isDetailViewPresented = true
                                        }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                            Button {
                                                GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_BOOTH_LIKE_CANCEL, params: ["boothID": boothID])
                                                viewModel.boothModel.deleteLikeBoothListDB(boothID)
                                                viewModel.boothModel.deleteLike(boothID)
                                            } label: {
                                                Label("삭제", systemImage: "trash.circle").tint(.ufRed)
                                            }
                                        }
                                }
                                else {
                                    HStack {
                                        Spacer()
                                        ProgressView()
                                        Spacer()
                                    }
                                    .frame(height: 114)
                                }
                            }
                        }
                        .listStyle(.plain)
                        .scrollDisabled(true)
                        .frame(height: CGFloat(114 * randomLikeList.count))
                        .onChange(of: viewModel.boothModel.likedBoothList) {
                            randomLikeList = viewModel.boothModel.getRandomLikedBooths()
                        }
//                    } else {
//                        List {
//                            ForEach(randomLikeList, id: \.self) { boothID in
//                                if let booth = viewModel.boothModel.getBoothByID(boothID) {
//                                    LikedBoothBoxView(viewModel: viewModel, boothID: boothID, image: booth.thumbnail, name: booth.name, description: booth.description, location: booth.location)
//                                    // .padding(.vertical, 10)
//                                        .onTapGesture {
//                                            GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_CLICK_BOOTH_ROW, params: ["boothID": boothID])
//                                            viewModel.boothModel.loadBoothDetail(boothID)
//                                            tappedBoothId = boothID
//                                            isDetailViewPresented = true
//                                        }
//                                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                                            Button {
//                                                GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_BOOTH_LIKE_CANCEL, params: ["boothID": boothID])
//                                                viewModel.boothModel.deleteLikeBoothListDB(boothID)
//                                                viewModel.boothModel.deleteLike(boothID)
//                                            } label: {
//                                                Label("삭제", systemImage: "trash.circle").tint(.ufRed)
//                                            }
//                                        }
//                                } else {
//                                    HStack {
//                                        Spacer()
//                                        ProgressView()
//                                        Spacer()
//                                    }
//                                    .frame(height: 114)
//                                }
//                            }
//                        }
//                        .background(.ufBackground)
//                        .listStyle(.plain)
//                        .scrollDisabled(true)
//                        .frame(height: CGFloat(114 * randomLikeList.count))
//                        .onChange(of: viewModel.boothModel.likedBoothList) { _ in
//                            randomLikeList = viewModel.boothModel.getRandomLikedBooths()
//                        }
//                    }
                }
                
                Text("").boldLine().padding(.bottom, 0)
                
                HStack {
                    Text("Contact Us")
                        .font(.system(size: 15))
                        .foregroundStyle(.defaultBlack)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Divider()
                
                // 이용 문의
                Button {
                    if let url = URL(string: StringLiterals.URL.messageChannelLink) {
                        UIApplication.shared.open(url, options: [:])
                    }
                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_CLICK_KAKAO_CHANNEL)
                } label: {
                    HStack {
                        Image(systemName: "headphones.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.grey900)
                            .padding(.trailing, 8)
                        
                        Text(StringLiterals.Menu.askTitle)
                            .font(.pretendard(weight: .p5, size: 15))
                            .foregroundStyle(.grey900)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Divider()
                
                // 운영자 모드
                Button {
                    if let url = URL(string: StringLiterals.URL.operatorModeLink) {
                        UIApplication.shared.open(url, options: [:])
                    }
                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_CLICK_OPERATOR_SITE)
                } label: {
                    HStack {
                        Image(systemName: "ellipsis.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(.grey900)
                            .padding(.trailing, 8)
                        
                        Text(StringLiterals.Menu.operatorModeTitle)
                            .font(.pretendard(weight: .p5, size: 15))
                            .foregroundStyle(.grey900)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Divider()
                
                // 인스타
                Button {
                    if let url = URL(string: StringLiterals.URL.instagramLink) {
                        UIApplication.shared.open(url, options: [:])
                    }
                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_CLICK_INSTAGRAM)
                } label: {
                    HStack {
                        Image(.instagramLogo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 8)
                        
                        Text(StringLiterals.Menu.instagram)
                            .font(.pretendard(weight: .p5, size: 15))
                            .foregroundStyle(.grey900)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Divider()
                
                // 설정
                HStack {
                    Text("설정")
                        .font(.system(size: 15))
                        .foregroundStyle(.ufBlack)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Divider()
                
                // 클러스터링 여부
                HStack(alignment: .center) {
//                    if #available(iOS 17, *) {
                        Image(systemName: "circle.dotted.and.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 8)
//                    } else {
//                        Image(systemName: "circle.dashed.inset.filled")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 24, height: 24)
//                            .foregroundColor(.darkGray)
//                            .padding(.trailing, 8)
//                    }
                    
                    VStack(alignment: .leading) {
                        Text("부스 묶어보기")
                            .font(.pretendard(weight: .p5, size: 15))
                            .foregroundStyle(.grey900)
                            .padding(.bottom, -2)
                        
                        Text("축소된 지도에서 가까운 부스를 묶어 표시합니다")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
//                    if #available(iOS 17, *) {
                        Toggle("", isOn: $clusterToggle)
                            .frame(width: 60)
                            .onChange(of: clusterToggle) {
                                if clusterToggle {
                                    // off -> on
                                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_TURN_ON_CLUSTERING)
                                    UserDefaults.standard.setValue(true, forKey: "IS_CLUSTER_ON_MAP")
                                    // print(UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP"))
                                } else {
                                    // on -> off
                                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_TURN_OFF_CLUSTERING)
                                    UserDefaults.standard.setValue(false, forKey: "IS_CLUSTER_ON_MAP")
                                    // print(UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP"))
                                }
                            }
//                    } else {
//                        Toggle("", isOn: $clusterToggle)
//                            .frame(width: 60)
//                            .onChange(of: clusterToggle) { _ in
//                                if clusterToggle {
//                                    // off -> on
//                                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_TURN_ON_CLUSTERING)
//                                    UserDefaults.standard.setValue(true, forKey: "IS_CLUSTER_ON_MAP")
//                                    // print(UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP"))
//                                } else {
//                                    // on -> off
//                                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_TURN_OFF_CLUSTERING)
//                                    UserDefaults.standard.setValue(false, forKey: "IS_CLUSTER_ON_MAP")
//                                    // print(UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP"))
//                                }
//                            }
//                    }
                }
                .frame(height: 60)
                .padding(.horizontal)
                
                Divider()
                
                // 관심축제 on/off
                /* HStack(alignment: .center) {
                 Image(systemName: "sparkle.magnifyingglass")
                 .resizable()
                 .scaledToFit()
                 .frame(width: 24, height: 24)
                 .foregroundColor(.darkGray)
                 .padding(.trailing, 8)
                 
                 VStack(alignment: .leading) {
                 Text("관심축제 등록")
                 .font(.pretendard(weight: .p5, size: 15))
                 .foregroundStyle(.grey900)
                 .padding(.bottom, -2)
                 
                 Text("관심축제로 등록하면 부스 소식을 알림으로\n받을 수 있습니다")
                 .font(.system(size: 12))
                 .foregroundStyle(.gray)
                 .fontWeight(.medium)
                 }
                 
                 Spacer()
                 
                 if #available(iOS 17, *) {
                 Toggle("", isOn: $subscribeFestival)
                 .frame(width: 60)
                 .onChange(of: subscribeFestival) {
                 if subscribeFestival {
                 // off -> on
                 let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                 UNUserNotificationCenter.current().requestAuthorization(
                 options: authOptions) { granted, error in
                 if granted { // 알림 권한이 설정되어있음
                 if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
                 Task {
                 await favoriteFestivalVM.addFavoriteFestival(festivalId: 2, fcmToken: fcmToken)
                 if favoriteFestivalVM.isAddFavoriteFestivalSucceeded { // 관심축제 등록 api 성공
                 // subscribeFestival == true
                 UserDefaults.standard.setValue(true, forKey: "subscribeFestival")
                 } else { // 관심축제 등록 api 실패
                 subscribeFestival = false
                 UserDefaults.standard.setValue(false, forKey: "subscribeFestival") // 이때는 addFavoriteFestival() 메서드에서 NetworkErrorView 띄움
                 }
                 }
                 } else {
                 subscribeFestival = false
                 UserDefaults.standard.setValue(false, forKey: "subscribeFestival")
                 print("fcmToken이 존재하지 않습니다")
                 }
                 } else { // 알림 권한이 설정 되어있지 않음
                 // 알림 권한을 허용해야 한다는 alert 띄우고
                 isNotificationNotPermittedAlertPresented = true
                 // subscribeFestival을 false로 바꾸기
                 subscribeFestival = false
                 UserDefaults.standard.setValue(false, forKey: "subscribeFestival")
                 }
                 }
                 } else {
                 // on -> off
                 if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
                 Task {
                 await favoriteFestivalVM.deleteFavoriteFestival(festivalId: 2, fcmToken: fcmToken)
                 if favoriteFestivalVM.isDeleteFavoriteFestivalSucceeded { // 관심축제 해제 api 성공
                 // subscribeFestival == false
                 UserDefaults.standard.setValue(false, forKey: "subscribeFestival")
                 } else { // 관심축제 해제 api 실패
                 subscribeFestival = true
                 UserDefaults.standard.setValue(true, forKey: "subscribeFestival") // 이때는 deleteFavoriteFestival() 메서드에서 NetworkErrorView 띄움
                 }
                 }
                 } else {
                 subscribeFestival = true
                 UserDefaults.standard.setValue(true, forKey: "subscribeFestival")
                 print("fcmToken이 존재하지 않습니다")
                 }
                 }
                 }
                 } else {
                 Toggle("", isOn: $subscribeFestival)
                 .frame(width: 60)
                 .onChange(of: subscribeFestival) { _ in
                 if subscribeFestival {
                 // off -> on
                 let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                 UNUserNotificationCenter.current().requestAuthorization(
                 options: authOptions) { granted, error in
                 if granted { // 알림 권한이 설정되어있음
                 if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
                 Task {
                 await favoriteFestivalVM.addFavoriteFestival(festivalId: 2, fcmToken: fcmToken)
                 if favoriteFestivalVM.isAddFavoriteFestivalSucceeded { // 관심축제 등록 api 성공
                 // subscribeFestival == true
                 UserDefaults.standard.setValue(true, forKey: "subscribeFestival")
                 } else { // 관심축제 등록 api 실패
                 subscribeFestival = false
                 UserDefaults.standard.setValue(false, forKey: "subscribeFestival")
                 // 이때는 NetworkErrorView 뜨도록 구현함
                 }
                 }
                 } else {
                 subscribeFestival = false
                 UserDefaults.standard.setValue(false, forKey: "subscribeFestival")
                 print("fcmToken이 존재하지 않습니다")
                 }
                 } else { // 알림 권한이 설정 되어있지 않음
                 // 알림 권한을 허용해야 한다는 alert 띄우고
                 isNotificationNotPermittedAlertPresented = true
                 // subscribeFestival을 false로 바꾸기
                 subscribeFestival = false
                 UserDefaults.standard.setValue(false, forKey: "subscribeFestival")
                 }
                 }
                 } else {
                 // on -> off
                 if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
                 Task {
                 await favoriteFestivalVM.deleteFavoriteFestival(festivalId: 2, fcmToken: fcmToken)
                 if favoriteFestivalVM.isDeleteFavoriteFestivalSucceeded { // 관심축제 해제 api 성공
                 // subscribeFestival == false
                 UserDefaults.standard.setValue(false, forKey: "subscribeFestival")
                 } else { // 관심축제 해제 api 실패
                 subscribeFestival = true
                 UserDefaults.standard.setValue(true, forKey: "subscribeFestival") // 이때는 deleteFavoriteFestival() 메서드에서 NetworkErrorView 띄움
                 }
                 }
                 } else {
                 subscribeFestival = true
                 UserDefaults.standard.setValue(true, forKey: "subscribeFestival")
                 print("fcmToken이 존재하지 않습니다")
                 }
                 }
                 }
                 }
                 }
                 .frame(height: 60)
                 .padding(.horizontal)
                 
                 Divider() */
                
                // 화면 모드
                /* Menu {
                 Button("라이트") {
                 themeManager.colorScheme = .light
                 }
                 
                 Button("다크") {
                 themeManager.colorScheme = .dark
                 }
                 
                 Button("시스템") {
                 themeManager.colorScheme = .system
                 }
                 // GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_CHANGE_SCREENMODE, params: ["screenMode": ""])
                 } label: {
                 HStack {
                 Image(systemName: colorScheme == .dark ? "moon.circle" : "sun.max.circle")
                 .resizable()
                 .scaledToFit()
                 .frame(width: 24, height: 24)
                 .foregroundColor(.darkGray)
                 .padding(.trailing, 8)
                 
                 Text("화면 모드")
                 .font(.system(size: 15))
                 .foregroundStyle(.darkGray)
                 .fontWeight(.medium)
                 
                 Spacer()
                 
                 Text("라이트")
                 .font(.system(size: 15))
                 .foregroundStyle(.darkGray)
                 .fontWeight(.medium)
                 .padding(.trailing, 6)
                 }
                 .frame(height: 60)
                 .padding(.horizontal)
                 }
                 
                 Divider()*/
                
                HStack {
                    Text("권한 및 개인정보 처리방침")
                        .font(.system(size: 15))
                        .foregroundStyle(.defaultBlack)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Divider()
                
                // 권한 수정
                Button {
                    isLocationPermissionAlertPresented = true
                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_OPEN_SETTING)
                } label: {
                    HStack {
                        Image(systemName: "location.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 8)
                        
                        Text(StringLiterals.Menu.locationAuthText)
                            .font(.pretendard(weight: .p5, size: 15))
                            .foregroundStyle(.grey900)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Divider()
                
                Button {
                    isCameraPermissionAlertPresented = true
                    // GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_OPEN_SETTING) // 카메라 GATracking 추가하고 코드 수정하기
                } label: {
                    HStack {
                        Image(systemName: "camera.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 8)
                        
                        Text(StringLiterals.Menu.cameraAuthText)
                            .font(.pretendard(weight: .p5, size: 15))
                            .foregroundStyle(.grey900)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Divider()
                
                Button {
                    isNotificationPermissionAlertPresented = true
                } label: {
                    HStack {
                        Image(systemName: "bell.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 8)
                        
                        Text(StringLiterals.Menu.notificationAuthText)
                            .font(.pretendard(weight: .p5, size: 15))
                            .foregroundStyle(.grey900)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Divider()
                
                // 개인정보 처리방침
                Button {
                    if let url = URL(string: "https://beaded-alley-5ed.notion.site/0398cc021c9d4879bdfbcd031d56da5e?pvs=74") {
                        UIApplication.shared.open(url, options: [:])
                    }
                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_OPEN_PRIVACY)
                } label: {
                    HStack {
                        Image(systemName: "lock.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.grey900)
                            .padding(.trailing, 8)
                        
                        Text(StringLiterals.Menu.privacyText)
                            .font(.pretendard(weight: .p5, size: 15))
                            .foregroundStyle(.grey900)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Divider()
                
                HStack {
                    Text("피드백")
                        .font(.system(size: 15))
                        .foregroundStyle(.defaultBlack)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Divider()
                
                // 메일 보내기
                Button {
                    isErrorDeclarationModalPresented = true
                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_MAIL_TO_DEV)
                } label: {
                    HStack {
                        Image(systemName: "envelope.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 8)
                        
                        VStack(alignment: .leading) {
                            Text("개발자에게 메일 보내기")
                                .font(.pretendard(weight: .p5, size: 15))
                                .foregroundStyle(.grey900)
                                .padding(.bottom, -2)
                            
                            Text("앱 오류 신고, 개선점, 피드백을 남겨주세요")
                                .font(.system(size: 12))
                                .foregroundStyle(.gray)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Divider()
                
                // 앱스토어 이동
                Button {
                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_OPEN_APPSTORE)
                    if let url = URL(string: VersionService.shared.appStoreOpenUrlString), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                } label: {
                    HStack {
                        Image(systemName: "star.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 8)
                        
                        VStack(alignment: .leading) {
                            Text("앱스토어에 리뷰 남기기")
                                .font(.pretendard(weight: .p5, size: 15))
                                .foregroundStyle(.grey900)
                                .padding(.bottom, -2)
                            
                            Text("남겨주신 소중한 리뷰는 개발자에게 큰 힘이 됩니다")
                                .font(.system(size: 12))
                                .foregroundStyle(.gray)
                                .fontWeight(.medium)
                        }
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                /* Divider()
                 
                 HStack {
                 Text("초기화")
                 .font(.system(size: 15))
                 .foregroundStyle(.red)
                 .bold()
                 
                 Spacer()
                 }
                 .padding(.horizontal)
                 .padding(.top, 20)
                 
                 Divider()
                 
                 Button {
                 isResetAlertPresented = true
                 } label: {
                 HStack {
                 Image(systemName: "xmark.circle")
                 .resizable()
                 .scaledToFit()
                 .frame(width: 24, height: 24)
                 .foregroundColor(.red)
                 .padding(.trailing, 8)
                 
                 Text(StringLiterals.Menu.clearApp)
                 .font(.system(size: 15))
                 .foregroundColor(.red)
                 .fontWeight(.medium)
                 
                 Spacer()
                 }
                 .frame(height: 60)
                 .padding(.horizontal)
                 }*/
                
                Divider()
                    .padding(.bottom, 20)
                
                if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    Text(StringLiterals.Menu.appTitle + " iOS v\(appVersion)")
                        .font(.system(size: 11))
                        .foregroundStyle(.gray)
                } else {
                    Text(StringLiterals.Menu.appTitle)
                }
                
                Text(StringLiterals.Menu.copyright)
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
                    .padding(.bottom, 20)
                
                Spacer()
                    .frame(height: 90)
            }
            .padding(.top, 32)
            .background(.ufBackground)
            
            VStack {
                NavigationHeaderView(text: StringLiterals.Menu.title)
                Spacer()
            }
        }
        .dynamicTypeSize(.large)
        .ignoresSafeArea()
        // .environmentObject(themeManager)
        // .environment(\.colorScheme, .getCurrentColorScheme())
        .fullScreenCover(isPresented: $isListViewPresented, content: {
            LikeBoothListView(viewModel: viewModel, mapViewModel: mapViewModel)
                .ignoresSafeArea()
        })
        .sheet(isPresented: $isEditFavoriteFestivalViewPresented) {
            EditFavoriteFestivalView(viewModel: viewModel, mapViewModel: mapViewModel)
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            // boothModel.likedBoothList = [1, 2, 3, 78, 79, 80, 81, 82]
            randomLikeList = viewModel.boothModel.getRandomLikedBooths()
            print("randomLikeList num: \(randomLikeList.count)")
            print(randomLikeList)
            clusterToggle = UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP")
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions) { granted, error in
                    if granted { // 알림 권한이 설정되어있음
                        subscribeFestival = UserDefaults.standard.bool(forKey: "subscribeFestival")
                    } else { // 알림 권한이 설정되어있지않음
                        UserDefaults.standard.setValue(false, forKey: "subscribeFestival")
                        subscribeFestival = false
                    }
                }
        }
        .sheet(isPresented: $isDetailViewPresented) {
            BoothDetailView(viewModel: viewModel, mapViewModel: mapViewModel, currentBoothId: tappedBoothId)
                .presentationDragIndicator(.visible)
                .onAppear {
                    GATracking.eventScreenView(GATracking.ScreenNames.likedBoothListView)
                }
        }
        // 알림 권한 허가 없이 관심 축제로 설정할 경우 alert 띄우기
        .alert("관심축제 설정 안내", isPresented: $isNotificationNotPermittedAlertPresented) {
            HStack {Button("닫기", role: .cancel) {
                subscribeFestival = false
                UserDefaults.standard.setValue(false, forKey: "subscribeFestival")
            }
                
                Button("설정하기", role: nil) {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    if UIApplication.shared.canOpenURL(url) {
                        subscribeFestival = false
                        UserDefaults.standard.setValue(false, forKey: "subscribeFestival")
                        UIApplication.shared.open(url)
                    }
                }
            }
        } message: {
            Text("관심축제 알림을 받으려면 알림 권한을 허용해야돼요. 앱 설정으로 가서 알림 권한을 수정할 수 있어요.")
        }
        // 권한 허가 수정 안내 모달
        .alert("위치 권한 수정 안내", isPresented: $isLocationPermissionAlertPresented, actions: {
            HStack {
                Button("닫기", role: .cancel) { }
                
                Button("설정하기", role: nil) {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                    
                }
            }
        }, message: {
            Text("앱 설정에서 위치 권한을 수정할 수 있어요. 이동하시겠어요?")
        })
        .alert("카메라 권한 수정 안내", isPresented: $isCameraPermissionAlertPresented) {
            HStack {
                Button("닫기", role: .cancel) { }
                
                Button("설정하기", role: nil) {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                    
                }
            }
        } message: {
            Text("앱 설정에서 카메라 권한을 수정할 수 있어요. 이동하시겠어요?")
        }
        .alert("알림 권한 수정 안내", isPresented: $isNotificationPermissionAlertPresented) {
            HStack {
                Button("닫기", role: .cancel) { }
                
                Button("설정하기", role: nil) {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                    
                }
            }
        } message: {
            Text("앱 설정에서 알림 권한을 수정할 수 있어요. 이동하시겠어요?")
        }
        // 기능 오류 신고 모달
        .alert("메일 보내기", isPresented: $isErrorDeclarationModalPresented, actions: {
            Button("메일을 작성할게요", role: nil) {
                // 메일 보내기
                //                let emailAddr = "mailto:leehe228@konkuk.ac.kr"
                //                guard let emailUrl = URL(string: emailAddr) else { return }
                //                UIApplication.shared.open(emailUrl)
                if let emailUrl = URL(string: "mailto:wltjd6300@naver.com"), UIApplication.shared.canOpenURL(emailUrl) {
                    UIApplication.shared.open(emailUrl)
                } else {
                    print("Failed to open email URL")
                }
            }
            Button("메일 주소를 복사할게요", role: nil) {
                // 클립보드에 복사
                UIPasteboard.general.string = "wltjd6300@naver.com"
                isCopyFinishPresented = true
            }
            Button("닫기", role: nil) { }
        }, message: {
            Text("wltjd6300@naver.com으로 메일을 작성해주세요. 소중한 의견 감사합니다.")
        })
        // 복사 완료 모달
        .alert("복사 완료", isPresented: $isCopyFinishPresented, actions: {
            Button("닫기", role: nil) { }
        }, message: {
            Text("클립보드에 복사가 완료되었어요. 소중한 의견을 작성해 보내주세요.")
        })
        
        // 앱 데이터 초기화
        .alert("앱을 초기화할까요?", isPresented: $isResetAlertPresented, actions: {
            Button("초기화하기", role: .destructive) {
                
            }
            Button("취소", role: .cancel) {
                
            }
        }, message: {
            Text("앱 저장소에 저장된 모든 데이터를 제거하여 앱을 초기 상태로 되돌립니다. 삭제된 데이터는 복구할 수 없습니다.")
        })
    }
    
    @ViewBuilder
    func circleSchoolView(image: String, name: String, festivalName: String) -> some View {
        VStack(spacing: 0) {
            Circle()
                .fill(.white)
                .frame(width: 58, height: 58)
                .shadow(color: .black.opacity(0.1), radius: 6.67, x: 0, y: 1)
                .overlay {
                    AsyncImage(url: URL(string: image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 46, height: 46)
                        case .success(let image):
                            image
                                .resizable()
                                .clipShape(Circle())
                                .scaledToFit()
                                .frame(width: 46, height: 46)
                        case .failure:
                            Image(.noImagePlaceholder)
                                .resizable()
                                .clipShape(Circle())
                                .scaledToFit()
                                .frame(width: 46, height: 46)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .padding(.bottom, 8)
            
            Text(name)
                .font(.system(size: 12))
                .fontWeight(.medium)
                .foregroundStyle(.gray)
                .padding(.bottom, 2)
            
            Text(festivalName)
                .font(.system(size: 11))
                .fontWeight(.semibold)
                .foregroundStyle(.darkGray)
        }
    }
}

#Preview {
    MenuView(viewModel: RootViewModel(), mapViewModel: MapViewModel(viewModel: RootViewModel()))
        .environmentObject(FavoriteFestivalViewModel(networkManager: NetworkManager()))
        .environmentObject(NetworkManager())
        .environmentObject(TabSelect())
}
