//
//  WaitingListView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/5/24.
//

import SwiftUI

struct WaitingListView: View {
    @Binding var isRequestedWaitingExists: Bool
    @EnvironmentObject var tabSelect: TabSelect
    
    var body: some View {
        if isRequestedWaitingExists {
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
            
            ScrollView {
                ForEach(0 ..< 15, id: \.self) { _ in
                     WaitingInfoView()
                        .padding(.horizontal, 20) // WaitingInfoView에 적용한 shadow가 ForEach문에서 잘리는 문제 해결
                }
                .padding(.top, 8)
            }
        } else {
            Spacer()
            
            Text(StringLiterals.Waiting.noWaitingTitle)
                .font(.pretendard(weight: .p6, size: 18))
                .foregroundStyle(.grey900)
                .padding(.bottom, 4)
            
            Button {
                tabSelect.selectedTab = 1
            } label: {
                HStack(spacing: 0) {
                    Text(StringLiterals.Waiting.gotoMapView)
                    Image(systemName: "chevron.right")
                }
                .font(.pretendard(weight: .p5, size: 13))
                .foregroundStyle(.grey600)
                .underline()
            }
            
            Spacer()
        }
    }
}

#Preview {
    WaitingListView(isRequestedWaitingExists: .constant(true))
}
