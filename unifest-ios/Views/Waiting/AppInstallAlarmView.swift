//
//  AppInstallAlarmView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/19/24.
//

import SwiftUI

struct AppInstallAlarmView: View {
    @Binding var showAppInstallAlarmView: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white)
                    .frame(width: 313, height: 396)
                    .overlay {
                        VStack(alignment: .center) {
                            Image(.appLogo)
                                .resizable()
                                .frame(width: 107, height: 113)
                                .rotationEffect(Angle(degrees: 21))
                                .shadow(radius: 10, y: 10.0)
                                .padding(.top, 29)
                            
                            Text("해당 기능은 앱에서만 사용 가능해요")
                                .font(.pretendard(weight: .p6, size: 18))
                                .padding(.top, 20)
                            
                            Text("유니페스 모바일앱을 설치하고\n 더욱 다양한 축제기능들을 만나보세요!")
                                .font(.pretendard(weight: .p4, size: 14))
                                .foregroundStyle(.gray727276)
                                .multilineTextAlignment(.center)
                                .padding(.top, 8)
                            
                            Button {
                                openUnifestAppStore()
                            } label: {
                                RoundedRectangle(cornerRadius: 81)
                                    .fill(Color.defaultPink)
                                    .frame(width: 185, height: 45)
                                    .overlay {
                                        Text("앱 설치하러 가기")
                                            .font(.pretendard(weight: .p7, size: 14))
                                            .foregroundStyle(.white)
                                    }
                            }
                            .padding(.top, 40)
                        }
                }
                
                Button {
                    showAppInstallAlarmView = false
                } label: {
                    Text("괜찮아요. 모바일웹으로 볼게요.")
                        .underline()
                        .font(.pretendard(weight: .p5, size: 14))
                        .foregroundStyle(.grayBABABF)
                        .padding(.top, 16)
                }
            }
        }
    }
    
    // 연결 되는 지 확인하보기
    func openUnifestAppStore() {
        if let url = URL(string: "apps.apple.com/app/id6502256367"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

#Preview {
    AppInstallAlarmView(showAppInstallAlarmView: .constant(true))
}
