//
//  WaitingView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import SwiftUI

struct WaitingView: View {
    @ObservedObject var viewModel: RootViewModel
    @State private var isWaitingRequested = false
    // @State private var showAppInstallAlarmView = true
    
    var body: some View {
        ZStack {
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
                
                HStack {
                    Text("총 10건")
                        .font(.pretendard(weight: .p6, size: 11))
                        .foregroundStyle(.gray545454)
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "chevron.down")
                                .resizable()
                                .frame(width: 7, height: 7)
                                .foregroundStyle(.gray545454)
                            Text("정렬")
                                .font(.pretendard(weight: .p6, size: 11))
                                .foregroundStyle(.gray545454)
                                .padding(.leading, -3)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                WaitingListView(isWaitingRequested: $isWaitingRequested)
            }
            
//            if showAppInstallAlarmView {
//                AppInstallAlarmView(showAppInstallAlarmView: $showAppInstallAlarmView)
//            }
        }
    }
}

#Preview {
    WaitingView(viewModel: RootViewModel())
}
