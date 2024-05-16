//
//  MenuView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import SwiftUI

struct MenuView: View {
    @State private var isListViewPresented: Bool = false
    @ObservedObject var boothModel: BoothModel
    @State private var isDetailViewPresented: Bool = false
    @State private var randomLikeList: [Int] = []
    
    @State private var isPermissionAlertPresented: Bool = false
    
    // 메일
    @State private var isErrorDeclarationModalPresented: Bool = false
    @State private var isCopyFinishPresented: Bool = false
    
    // 앱 초기화
    @State private var isResetAlertPresented: Bool = false
    
    // 클러스터링 여부 설정
    @State private var clusterToggle: Bool = true
    
    var body: some View {
        ZStack {
            ScrollView {
                Spacer()
                    .frame(height: 56)
                
                HStack {
                    Text(StringLiterals.Menu.LikedSchoolTitle)
                        .font(.system(size: 15))
                        .bold()
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    /*
                    Button {
                        
                    } label: {
                        HStack(spacing: 0) {
                            Text("추가하기")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                                .underline()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 11))
                                .foregroundColor(.gray)
                        }
                    }*/
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
                
                // LazyHGrid
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 5), spacing: 25) {
                    circleSchoolView(image: .konkukLogo, name: "건국대")
                    /* circleSchoolView(image: .chungangLogo, name: "중앙대")
                    circleSchoolView(image: .uosLogo, name: "한국외대")
                    circleSchoolView(image: .konkukLogo, name: "건국대")
                    circleSchoolView(image: .chungangLogo, name: "중앙대")
                    circleSchoolView(image: .uosLogo, name: "한국외대")
                    circleSchoolView(image: .konkukLogo, name: "건국대")
                    circleSchoolView(image: .chungangLogo, name: "중앙대")
                    circleSchoolView(image: .uosLogo, name: "한국외대")*/
                }
                .padding(.horizontal)
                
                Image(.boldLine)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                
                HStack {
                    Text(StringLiterals.Menu.LikedBoothTitle)
                        .font(.system(size: 15))
                        .bold()
                        .foregroundStyle(.black)
                    
                    Spacer()
                    
                    if !boothModel.likedBoothList.isEmpty {
                        Button {
                            isListViewPresented.toggle()
                        } label: {
                            HStack(spacing: 0) {
                                Text(StringLiterals.Menu.more)
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                                    .underline()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                if boothModel.likedBoothList.isEmpty {
                    VStack(alignment: .center) {
                        Text(StringLiterals.Menu.noLikedBoothTitle)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(.defaultBlack)
                            .padding(.bottom, 1)
                        
                        Text(StringLiterals.Menu.noLikedBoothMessage)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                    }
                    .frame(height: 240)
                } else {
                    VStack {
                        // let randomLikeList = boothModel.getRandomLikedBooths()
                        
                        ForEach(randomLikeList, id: \.self) { boothID in
                            if let booth = boothModel.getBoothByID(boothID) {
                                LikedBoothBoxView(boothModel: boothModel, boothID: boothID, image: booth.thumbnail, name: booth.name, description: booth.description, location: booth.location)
                                    .padding(.vertical, 10)
                                    .onTapGesture {
                                        GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_CLICK_BOOTH_ROW, params: ["boothID": boothID])
                                        boothModel.loadBoothDetail(boothID)
                                        isDetailViewPresented = true
                                    }
                                Divider()
                            }
                        }
                    }
                    .onChange(of: boothModel.likedBoothList) {
                        randomLikeList = boothModel.getRandomLikedBooths()
                    }
                }
                
                Image(.boldLine)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 0)
                
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
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 8)
                        
                        Text(StringLiterals.Menu.askTitle)
                            .font(.system(size: 15))
                            .foregroundStyle(.darkGray)
                            .fontWeight(.medium)
                        
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
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 8)
                        
                        Text(StringLiterals.Menu.operatorModeTitle)
                            .font(.system(size: 15))
                            .foregroundStyle(.darkGray)
                            .fontWeight(.medium)
                        
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
                            .font(.system(size: 15))
                            .foregroundStyle(.darkGray)
                            .fontWeight(.medium)
                        
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
                        .foregroundStyle(.defaultBlack)
                        .bold()
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Divider()
                
                // 클러스터링 여부
                HStack(alignment: .center) {
                    Image(systemName: "circle.dotted.and.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.darkGray)
                        .padding(.trailing, 8)
                    
                    VStack(alignment: .leading) {
                        Text("부스 묶어보기")
                            .font(.system(size: 15))
                            .foregroundStyle(.darkGray)
                            .fontWeight(.medium)
                        
                        Text("축소된 지도에서 가까운 부스를 묶어 표시합니다")
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
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
                }
                .frame(height: 60)
                .padding(.horizontal)
                
                Divider()
                
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
                    isPermissionAlertPresented = true
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
                            .font(.system(size: 15))
                            .foregroundStyle(.darkGray)
                            .fontWeight(.medium)
                        
                        Spacer()
                    }
                    .frame(height: 60)
                    .padding(.horizontal)
                }
                
                Divider()
                
                // 개인정보 처리방침
                Button {
                    if let url = URL(string: StringLiterals.URL.privacyPolicyLink) {
                            UIApplication.shared.open(url, options: [:])
                        }
                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_OPEN_PRIVACY)
                } label: {
                    HStack {
                        Image(systemName: "lock.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.darkGray)
                            .padding(.trailing, 8)
                        
                        Text(StringLiterals.Menu.privacyText)
                            .font(.system(size: 15))
                            .foregroundStyle(.darkGray)
                            .fontWeight(.medium)
                        
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
                        
                        Text(StringLiterals.Menu.developerMail)
                            .font(.system(size: 15))
                            .foregroundStyle(.darkGray)
                            .fontWeight(.medium)
                        
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
            }
            .padding(.top, 32)
            
            VStack {
                NavigationHeaderView(text: StringLiterals.Menu.title)
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isListViewPresented, content: {
            LikeBoothListView(boothModel: boothModel)
        })
        .onAppear {
            // boothModel.likedBoothList = [1, 2, 3, 78, 79, 80, 81, 82]
            randomLikeList = boothModel.getRandomLikedBooths()
            clusterToggle = UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP")
        }
        .sheet(isPresented: $isDetailViewPresented) {
            DetailView(boothModel: boothModel)
                .presentationDragIndicator(.visible)
                .onAppear {
                    GATracking.eventScreenView(GATracking.ScreenNames.likedBoothListView)
                }
        }
        // 권한 허가 수정 안내 모달
        .alert("권한 허가 수정 안내", isPresented: $isPermissionAlertPresented, actions: {
            Button("설정 앱으로 이동할래요", role: .cancel) {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                }
                
            }
            Button("알겠어요", role: nil) {
                
            }
        }, message: {
            Text("권한 허가 수정은 Apple 정책 상 직접 iPhone 설정 앱 - 펫스페이스 에서 권한을 수정할 수 있어요.")
        })
        // 기능 오류 신고 모달
        .alert("피드백 안내", isPresented: $isErrorDeclarationModalPresented, actions: {
            Button("메일을 작성할래요", role: nil) {
                // 메일 보내기
//                let emailAddr = "mailto:leehe228@konkuk.ac.kr"
//                guard let emailUrl = URL(string: emailAddr) else { return }
//                UIApplication.shared.open(emailUrl)
                if let emailUrl = URL(string: "mailto:hoeunlee228@gmail.com"), UIApplication.shared.canOpenURL(emailUrl) {
                    UIApplication.shared.open(emailUrl)
                } else {
                    print("Failed to open email URL")
                }
            }
            Button("메일 주소를 복사할래요", role: nil) {
                // 클립보드에 복사
                UIPasteboard.general.string = "hoeunlee228@gmail.com"
                isCopyFinishPresented = true
            }
            Button("알겠어요", role: nil) {
                //
            }
        }, message: {
            Text("피드백은 hoeunlee228@gmail.com으로 메일을 작성해주세요. 소중한 의견 감사합니다.")
        })
        // 복사 완료 모달
        .alert("복사 완료", isPresented: $isCopyFinishPresented, actions: {
            Button("알겠어요", role: nil) {
                
            }
        }, message: {
            Text("클립보드에 복사가 완료되었어요. 소중한 의견을 작성해 보내주세요.")
        })
        
        // 앱 데이터 초기화
        .alert("앱을 초기화할까요?", isPresented: $isResetAlertPresented, actions: {
            Button("초기화할게요", role: .destructive) {
                
            }
            Button("취소할게요", role: .cancel) {
                
            }
        }, message: {
            Text("앱 저장소에 저장된 모든 데이터를 제거하여 앱을 초기 상태로 되돌립니다. 삭제된 데이터는 복구할 수 없습니다.")
        })
    }
    
    @ViewBuilder
    func circleSchoolView(image: ImageResource, name: String) -> some View {
        VStack(spacing: 8) {
            Circle()
                .fill(.background)
                .frame(width: 58, height: 58)
                .shadow(color: .black.opacity(0.1), radius: 6.67, x: 0, y: 1)
                .overlay {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 46, height: 46)
                }
            
            Text(name)
                .font(.system(size: 12))
                .fontWeight(.medium)
                .foregroundStyle(.darkGray)
        }
    }
}

#Preview {
    MenuView(boothModel: BoothModel())
}
