//
//  BoothNoshowDialogView.swift
//  unifest-ios
//
//  Created by 임지성 on 10/25/24.
//

import SwiftUI

struct BoothNoshowDialogView: View {
    @Binding var isNoshowDialogPresented: Bool
    @EnvironmentObject var tabSelect: TabSelect
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.66)
                .ignoresSafeArea()
            
            Color.ufWhite
                .cornerRadius(10)
                .frame(width: 301, height: 211)
                .overlay {
                    VStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(.ufRed)
                            .padding(.top, 3)
                        
                        Text("부재 처리된 부스예요")
                            .font(.pretendard(weight: .p6, size: 18))
                            .foregroundStyle(.grey900)
                            .padding(.top, 15)
                        
                        Text("해당 부스에 다시 웨이팅하려면 부재 웨이팅을 지워야해요. 웨이팅 탭으로 이동하시겠어요?")
                            .font(.pretendard(weight: .p5, size: 13))
                            .foregroundStyle(.grey600)
                            .multilineTextAlignment(.center)
                            .padding(.top, -5)
                            .padding(.horizontal)
                        
                        HStack {
                            Button {
                                isNoshowDialogPresented = false
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.grey100)
                                    .frame(width: 133, height: 45)
                                    .overlay {
                                        Text("취소")
                                            .font(.pretendard(weight: .p6, size: 14))
                                            .foregroundStyle(.grey700)
                                    }
                            }
                            
                            Button {
                                isNoshowDialogPresented = false
                                dismiss()
                                tabSelect.selectedTab = 1
                            } label: {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(Color.primary500)
                                    .frame(width: 133, height: 45)
                                    .overlay {
                                        Text("이동하기")
                                            .font(.pretendard(weight: .p6, size: 14))
                                            .foregroundStyle(.ufWhite)
                                    }
                            }
                        }
                        .padding(.top, 21)
                    }
                }
            
        }
        .ignoresSafeArea()
    }
}

#Preview {
    BoothNoshowDialogView(isNoshowDialogPresented: .constant(false))
        .environmentObject(TabSelect())
}
