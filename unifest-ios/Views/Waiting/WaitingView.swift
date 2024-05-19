//
//  WaitingView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import SwiftUI

struct WaitingView: View {
    @ObservedObject var viewModel: RootViewModel
    @Binding var tabViewSelection: Int
    
    var body: some View {
        VStack {
            HStack {
                Text(StringLiterals.Waiting.title)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding()
            
            Text("").roundedButton(background: .defaultLightPink, strokeColor: .accent, height: 34, cornerRadius: 30)
                .padding(.horizontal)
            // Image(.waitingBack)
                // .resizable()
                // .scaledToFit()
                // .frame(maxWidth: .infinity)
                .overlay {
                    HStack {
                        Text(StringLiterals.Waiting.myWaiting)
                            .font(.system(size: 13))
                            .bold()
                            .foregroundStyle(.defaultPink)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                }
            
            Spacer()
            
            Text(StringLiterals.Waiting.noWaitingTitle)
                .font(.system(size: 15))
                .fontWeight(.medium)
                .padding(.bottom, 4)
            
            Button {
                tabViewSelection = 1
            } label: {
                HStack(spacing: 0) {
                    Text(StringLiterals.Waiting.gotoMapView)
                        .foregroundColor(.gray)
                        .font(.system(size: 11))
                        .underline()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                        .font(.system(size: 11))
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    WaitingView(viewModel: RootViewModel(), tabViewSelection: .constant(2))
}
