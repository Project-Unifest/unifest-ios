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
    
    @State private var isWaitingRequested = true
    
    var body: some View {
        VStack {
            HStack {
                Text(StringLiterals.Waiting.title)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                        
                Spacer()
            }
            .padding()
                    
            Text("")
                .roundedButton(background: .defaultLightPink, strokeColor: .accent, height: 34, cornerRadius: 30)
                .padding(.horizontal)
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
                    
            WaitingListView(isWaitingRequested: $isWaitingRequested, tabViewSelection: $tabViewSelection)
        }
    }
}

#Preview {
    WaitingView(viewModel: RootViewModel(), tabViewSelection: .constant(2))
}
