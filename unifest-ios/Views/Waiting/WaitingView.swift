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
                Text("웨이팅")
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding()
            
            Image(.waitingBack)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .overlay {
                    HStack {
                        Text("나의 웨이팅")
                            .font(.system(size: 13))
                            .bold()
                            .foregroundStyle(.defaultPink)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
            
            Spacer()
            
            Text("신청한 웨이팅이 없어요")
                .font(.system(size: 15))
                .fontWeight(.medium)
                .padding(.bottom, 4)
            
            Button {
                tabViewSelection = 2
            } label: {
                HStack(spacing: 0) {
                    Text("주점/부스 구경하러 가기")
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
