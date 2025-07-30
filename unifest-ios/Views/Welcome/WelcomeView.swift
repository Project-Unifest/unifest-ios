//
//  WelcomeView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/17/24.
//

import SwiftUI
import ConfettiSwiftUI

// 가천대 특화 기획에서는 빠지는 뷰입니다.
struct WelcomeView: View {
    @Environment(\.dismiss) var dismiss
    
    // ConfettiCannon Library
    @State private var counter: Int = 0
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack {
                Image("appLogo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(30)
                    .padding(.top, 40)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        counter += 1
                    }
            }
            .padding(.top)
            
            ZStack {
                Text("유니페스에 오신 것을 \n환영합니다!")
                    .font(.title)
                    .multilineTextAlignment(.center)
                
                ConfettiCannon(counter: $counter, num: 20, repetitions: 3, repetitionInterval: 0.3)
                    .onAppear() {
                        counter += 1
                    }
            }
            
            // 안내
            ScrollView {
                VStack(alignment: .center, spacing: 10,content: {
                    WelcomeRow(iconName: "calendar.circle", mainColor: .accent, title: "캘린더로 대학 축제 일정 확인", subtitle: "오늘은 어느 대학 축제에 갈까? 캘린더에서 한눈에 \n다른 학교의 축제와 공연 일정까지 확인할 수 있어요.")
                    WelcomeRow(iconName: "map.circle", mainColor: .yellow, title: "지도로 보는 각 부스 위치", subtitle: "주점이 어디더라?\n찾고 있는 부스를 지도에서 쉽게 확인하세요.")
                    WelcomeRow(iconName: "questionmark.circle", mainColor: .blue, title: "한 눈에 보는 부스 정보", subtitle: "이 주점 메뉴는 뭐지? 부스에서 판매중인 메뉴, \n기념품, 이벤트 정보를 손쉽게 확인해보세요.")
                    WelcomeRow(iconName: "person.2.circle", mainColor: .green, title: "축제 인기부스 보기", subtitle: "지금 인기있는 부스는 어디? \n실시간으로 인기 있는 부스를 확인할 수 있어요.")
                    WelcomeRow(iconName: "hourglass.circle", mainColor: .purple, title: "부스 웨이팅 신청하기", subtitle: "웨이팅하는 동안 액티비티나 즐겨볼까? \n입장을 원하는 부스에 웨이팅을 신청하고 축제를 더 알차게 즐겨보세요.")
                    WelcomeRow(iconName: "star.circle", mainColor: .mint, title: "스탬프 받기", subtitle: "부스에서 스탬프를 받으며 축제에 더 적극적으로 참여해보세요.")
                })
                .padding()
            }
            
            Spacer()
            
            Text("UNIFEST 2025 ⓒ ALL RIGHT RESERVED")
                .font(.system(size: 11))
                .foregroundStyle(.gray)
                .padding(.bottom, 4)
        }
        .dynamicTypeSize(.large)
        .background(.ufBackground)
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { timer in
                counter += 1
            }
        }
    }
}

struct WelcomeRow: View {
    let iconName: String
    let mainColor: Color
    let title: String
    let subtitle: String
    
    var body: some View {
        GroupBox {
            HStack {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(mainColor)
                    .padding(.trailing, 8)
                
                VStack(alignment: .leading, content: {
                    Text(title)
                        .font(.system(size: 15))
                        .multilineTextAlignment(.leading)
                        .bold()
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .multilineTextAlignment(.leading)
                    
                })
                
                Spacer()
            }
        }
    }
}

#Preview {
    WelcomeView()
}
