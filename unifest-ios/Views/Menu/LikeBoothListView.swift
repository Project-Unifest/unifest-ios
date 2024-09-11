//
//  LikeBoothListView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 4/5/24.
//

import SwiftUI

struct LikeBoothListView: View {
    @ObservedObject var viewModel: RootViewModel
    @Environment(\.dismiss) var dismiss
    @State private var isDetailViewPresented: Bool = false
    @State private var tappedBoothId = 0 // 좋아요 한 부스 리스트에서 특정 부스를 탭했을 때, 해당 부스의 부스ID를 BoothDetailView로 넘김
    
    var body: some View {
        ZStack {
            if viewModel.boothModel.getFullLikedBoothList().isEmpty {
                VStack(alignment: .center) {
                    Spacer()
                    Text(StringLiterals.Menu.noLikedBoothTitle)
                        .font(.pretendard(weight: .p6, size: 18))
                        .foregroundStyle(.grey900)
                        .padding(.bottom, 1)
                    
                    Text(StringLiterals.Menu.noLikedBoothMessage)
                        .font(.pretendard(weight: .p5, size: 13))
                        .foregroundStyle(.grey600)
                    Spacer()
                }
                .background(.ufBackground)
                .padding(.top, 32)
            }
            else {
                /* ScrollView {
                 Spacer()
                 .frame(height: 32)
                 ForEach(viewModel.boothModel.likedBoothList, id: \.self) { boothID in
                 if let booth = viewModel.boothModel.getBoothByID(boothID) {
                 // boothBox(image: booth.thumbnail, name: booth.name, description: booth.description, location: booth.location)
                 LikedBoothBoxView(viewModel: viewModel, boothID: boothID, image: booth.thumbnail, name: booth.name, description: booth.description, location: booth.location)
                 .padding(.vertical, 10)
                 .onTapGesture {
                 GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_CLICK_BOOTH_ROW, params: ["boothID": boothID])
                 viewModel.boothModel.loadBoothDetail(boothID)
                 isDetailViewPresented = true
                 }
                 Divider()
                 }
                 }
                 }
                 .padding(.top, 32)*/
                
                
                List {
                    ForEach(viewModel.boothModel.getFullLikedBoothList(), id: \.self) { boothID in
                        if let booth = viewModel.boothModel.getBoothByID(boothID) {
                            // boothBox(image: booth.thumbnail, name: booth.name, description: booth.description, location: booth.location)
                            LikedBoothBoxView(viewModel: viewModel, boothID: boothID, image: booth.thumbnail, name: booth.name, description: booth.description, location: booth.location)
                            // .padding(.vertical, 10)
                                .listRowBackground(Color.ufBackground)
                                .listRowSeparator(.hidden)
                                .onTapGesture {
                                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_CLICK_BOOTH_ROW, params: ["boothID": boothID])
                                    viewModel.boothModel.loadBoothDetail(boothID)
                                    tappedBoothId = boothID
                                    isDetailViewPresented = true
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button {
                                        GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_BOOTH_LIKE_CANCEL, params: ["boothID": boothID])
                                        viewModel.boothModel.deleteLikeBoothListDB(boothID)
                                    } label: {
                                        Label("삭제", systemImage: "trash.circle").tint(.ufRed)
                                    }
                                }
                            // Divider()
                        }
                        else {
                            HStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                            .frame(height: 114)
                        }
                    }
                }
                .background(.ufBackground)
                .listStyle(.plain)
                .padding(.top, 123)
            }
            
            VStack {
                Rectangle()
                    .fill(Color.ufNetworkErrorBackground)
                    .frame(height: 115)
                    .clipShape(
                        .rect(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 23,
                            bottomTrailingRadius: 23,
                            topTrailingRadius: 0
                        )
                    )
                    .shadow(color: Color.black.opacity(0.1), radius: 10, y: 8)
                    .overlay {
                        VStack {
                            Spacer()
                            
                            HStack(alignment: .bottom) {
                                Button {
                                    dismiss()
                                } label: {
                                    Image(systemName: "chevron.left")
                                        .foregroundColor(.darkGray)
                                }
                                .frame(width: 20)
                                
                                Spacer()
                                
                                Text(StringLiterals.Menu.LikedBoothTitle)
                                    .font(.pretendard(weight: .p6, size: 20))
                                    .foregroundStyle(.grey900)
                                
                                Spacer()
                                Spacer()
                                    .frame(width: 20)
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 13)
                        }
                    }
                
                Spacer()
            }
        }
        .dynamicTypeSize(.large)
        .background(.ufBackground)
        .sheet(isPresented: $isDetailViewPresented) {
            BoothDetailView(viewModel: viewModel, currentBoothId: tappedBoothId)
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    // LikeBoothListView(viewModel: RootViewModel())
    RootView(rootViewModel: RootViewModel(), networkManager: NetworkManager())
}
