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
            
            Text("")
                .roundedButton(background: .ufNetworkErrorBackground, strokeColor: .clear, height: 196, cornerRadius: 5)
                .frame(width: 300)
            // Image(.dialogBackground)
                .overlay {
                    VStack(alignment: .center) {
                        Image(systemName: errorType == .server ? "exclamationmark.triangle.fill" : "wifi")
                            .foregroundStyle(errorType == .server ? .ufRed : .ufBlack)
                            .padding(.top, 26)
                            .padding(.bottom, 10)
                        
                        Text(errorType == .server ? StringLiterals.NetworkError.serverErrorTitle : StringLiterals.NetworkError.networkErrorTitle)
                            .font(.pretendard(weight: .p6, size: 18))
                            .foregroundStyle(.grey900)
                            .padding(.bottom, 3)
                        
                        Text(errorType == .server ? StringLiterals.NetworkError.serverErrorMessage : StringLiterals.NetworkError.networkErrorMessage)
                            .font(.pretendard(weight: .p5, size: 13))
                            .foregroundStyle(.grey600)
                            .padding(.bottom, 10)
                        
                        Button {
                            // TODO: Retry
                        } label: {
                            Text("")
                                .roundedButton(background: .primary500, strokeColor: .clear, height: 45, cornerRadius: 5)
                                .padding(.horizontal)
                            // Image(.mediumPinkButton)
                                .overlay {
                                    Text(StringLiterals.NetworkError.retry)
                                        .font(.pretendard(weight: .p6, size: 13))
                                        .foregroundStyle(.white)
                                        .fontWeight(.semibold)
                                }
                        }
                        .padding(.bottom, 16)
                        .padding(.top, 8)
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
