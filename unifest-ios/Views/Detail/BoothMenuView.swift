//
//  MenuView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/21/24.
//

import SwiftUI

struct BoothMenuView: View {
    @ObservedObject var viewModel: RootViewModel
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var isReloadButtonPresent: Bool
    @Binding var isMenuImagePresented: Bool
    @Binding var selectedMenu: SelectedMenuInfo
    
    var body: some View {
        VStack {
            HStack {
                Text(StringLiterals.Detail.menuTitle)
                    .font(.pretendard(weight: .p6, size: 18))
                    .foregroundStyle(.ufBlack)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 6)
            .padding(.top, 8)
            
            if let booth = viewModel.boothModel.selectedBooth {
                if let boothMenu = booth.menus {
                    if boothMenu.isEmpty {
                        VStack {
                            Spacer()
                                .frame(height: 100)
                            
                            HStack {
                                Spacer()
                                Text(StringLiterals.Detail.noMenuTitle)
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 12))
                                Spacer()
                            }
                            
                            Spacer()
                                .frame(height: 100)
                            
                        }
                    } else {
                        VStack(spacing: 10) {
                            ForEach(boothMenu, id: \.self) { menu in
                                MenuBarView(
                                    imageURL: menu.imgUrl ?? "",
                                    name: menu.name ?? "",
                                    price: menu.price ?? 0,
                                    menuStatus: menu.menuStatus,
                                    // menuStatus: menu.menuStatus,
                                    isMenuImagePresented: $isMenuImagePresented,
                                    selectedMenu: $selectedMenu)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            } else {
                VStack {
                    if !isReloadButtonPresent {
                        ProgressView()
                            .padding(.bottom, 20)
                    } else {
                        Text("부스 정보를 불러오지 못했습니다")
                            .foregroundStyle(.darkGray)
                            .font(.system(size: 15))
                            .padding(.bottom, 4)
                        Button {
                            viewModel.boothModel.loadBoothDetail(viewModel.boothModel.selectedBoothID)
                        } label: {
                            Text("다시 시도")
                                .foregroundStyle(.gray)
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                        }
                    }
                }
                .frame(height: 100)
                .padding(.bottom, 20)
            }
        }
        .background(colorScheme == .dark ? Color.grey100 : Color.white)
    }
}
