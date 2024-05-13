//
//  NetworkErrorView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 4/5/24.
//

import SwiftUI

struct NetworkErrorView: View {
    let errorType: NetworkErrorType
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            Image(.dialogBackground)
                .overlay {
                    VStack(alignment: .center) {
                        Image(systemName: errorType == .server ? "exclamationmark.triangle.fill" : "wifi")
                            .foregroundColor(errorType == .server ? .red : .black)
                            .padding(.top, 26)
                            .padding(.bottom, 10)
                        
                        Text(errorType == .server ? "서버 문제 발생" : "네트워크 문제")
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                            .padding(.bottom, 3)
                        
                        Text(errorType == .server ? "개발자에게 문의 바랍니다." : "와이파이나 데이터 접속을 확인해주세요.")
                            .font(.system(size: 13))
                            .fontWeight(.medium)
                            .padding(.bottom, 10)
                        
                        Button {
                            // TODO: Retry
                        } label: {
                            Image(.mediumPinkButton)
                                .overlay {
                                    Text("재시도")
                                        .font(.system(size: 13))
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                }
                        }
                        .padding(.bottom, 16)
                    }
                }
        }
    }
    
    enum NetworkErrorType {
        case server
        case network
    }
}

#Preview {
    NetworkErrorView(errorType: .network)
}

#Preview {
    NetworkErrorView(errorType: .server)
}
