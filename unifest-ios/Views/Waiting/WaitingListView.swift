//
//  WaitingListView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/5/24.
//

import SwiftUI

struct WaitingListView: View {
    @Binding var isWaitingRequested: Bool
    @EnvironmentObject var tabSelect: TabSelect
    
    var body: some View {
        if isWaitingRequested {
            ScrollView {
                ForEach(0 ..< 15, id: \.self) { _ in
                     WaitingInfoView()
                }
            }
        } else {
            Spacer()
            
            Text(StringLiterals.Waiting.noWaitingTitle)
                .font(.system(size: 15))
                .fontWeight(.medium)
                .padding(.bottom, 4)
            
            Button {
                tabSelect.selectedTab = 1
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
    WaitingListView(isWaitingRequested: .constant(true))
}
