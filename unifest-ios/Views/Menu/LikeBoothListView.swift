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
    
    var body: some View {
        ZStack {
            if viewModel.boothModel.getFullLikedBoothList().isEmpty {
                VStack(alignment: .center) {
                    Spacer()
                    Text(StringLiterals.Menu.noLikedBoothTitle)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .foregroundColor(.defaultBlack)
                        .padding(.bottom, 1)
                    
                    Text(StringLiterals.Menu.noLikedBoothMessage)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    Spacer()
                }
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
                                .onTapGesture {
                                    GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_CLICK_BOOTH_ROW, params: ["boothID": boothID])
                                    viewModel.boothModel.loadBoothDetail(boothID)
                                    isDetailViewPresented = true
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button {
                                        GATracking.sendLogEvent(GATracking.LogEventType.MenuView.MENU_BOOTH_LIKE_CANCEL, params: ["boothID": boothID])
                                        viewModel.boothModel.deleteLikeBoothListDB(boothID)
                                    } label: {
                                        Label("삭제", systemImage: "trash.circle").tint(.red)
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
                .listStyle(.plain)
                .padding(.top, 60)
            }
            
            VStack {
                HStack(alignment: .bottom) {
                    Spacer()
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .background(.background)
                .frame(height: 32)
                .overlay {
                    Image(.navBottom)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .offset(y: 32)
                }
                .overlay {
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
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundStyle(.defaultBlack)
                        Spacer()
                        Spacer()
                            .frame(width: 20)
                    }
                    .offset(y: 4)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $isDetailViewPresented) {
            BoothDetailView(viewModel: viewModel)
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    // LikeBoothListView(viewModel: RootViewModel())
    RootView(rootViewModel: RootViewModel())
}
