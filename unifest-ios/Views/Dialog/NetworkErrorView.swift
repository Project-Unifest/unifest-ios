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
                        
                        Text(errorType == .server ? StringLiterals.NetworkError.serverErrorTitle : StringLiterals.NetworkError.networkErrorTitle)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                            .padding(.bottom, 3)
                        
                        Text(errorType == .server ? StringLiterals.NetworkError.serverErrorMessage : StringLiterals.NetworkError.networkErrorMessage)
                            .font(.system(size: 13))
                            .fontWeight(.medium)
                            .padding(.bottom, 10)
                        
                        Button {
                            // TODO: Retry
                        } label: {
                            Text("")
                                .roundedButton(background: .defaultPink, strokeColor: .accent, height: 45, cornerRadius: 5)
                                .padding(.horizontal)
                            // Image(.mediumPinkButton)
                                .overlay {
                                    Text(StringLiterals.NetworkError.retry)
                                        .font(.system(size: 13))
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
