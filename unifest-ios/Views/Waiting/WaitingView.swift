//
//  WaitingView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/31/24.
//

import SwiftUI

struct WaitingView: View {
    @ObservedObject var viewModel: RootViewModel
    @EnvironmentObject var waiting: WaitingViewModel
    @State private var isRequestedWaitingExists = true
    // @State private var showAppInstallAlarmView = true
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text(StringLiterals.Waiting.title)
                        .font(.pretendard(weight: .p6, size: 20))
                        .foregroundStyle(.grey900)
                    
                    Spacer()
                }
                .padding()
                
                Text("")
                    .roundedButton(background: .primary50, strokeColor: .accent, height: 34, cornerRadius: 30)
                    .padding(.horizontal)
                    .overlay {
                        HStack {
                            Text(StringLiterals.Waiting.myWaiting)
                                .font(.pretendard(weight: .p7, size: 13))
                                .foregroundStyle(.primary500)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 30)
                    }
                
                WaitingListView(isRequestedWaitingExists: $isRequestedWaitingExists)
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
