//
//  WelcomeView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 5/17/24.
//

import SwiftUI
import ConfettiSwiftUI

struct WelcomeView: View {
    // Environment
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
                    WelcomeRow(iconName: "map.circle", mainColor: .accent, title: "지도로 보는 각 부스 위치", subtitle: "주점이 어디더라? 지도에서 내가 찾는 부스가 \n어디에 있는지 한 눈에 찾아보세요")
                    WelcomeRow(iconName: "questionmark.circle", mainColor: .blue, title: "한 눈에 보는 부스 정보", subtitle: "이 주점 뭐 팔아? 부스에서 판매중인 메뉴, \n기념품, 이벤트를 손쉽게 확인해보세요")
                    WelcomeRow(iconName: "person.2.circle", mainColor: .green, title: "축제 인기부스 보기", subtitle: "지금 인기있는 부스는 어디? \n실시간으로 인기있는 부스를 볼 수 있어요")
                    WelcomeRow(iconName: "calendar.circle", mainColor: .yellow, title: "캘린더로 대학 축제 일정 확인", subtitle: "오늘은 어느 대학 축제 갈까? 캘린더에서 한 눈에 \n다른 학교의 축제와 공연 일정까지 확인할 수 있어요")
                })
                .padding()
            }
            
            Spacer()
            
            Text("UNIFEST 2024 ⓒ ALL RIGHT RESERVED")
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
