//
//  DetailView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/26/24.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: RootViewModel
    @State private var isMapViewPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var isReloadButtonPresent: Bool = false
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        ZStack {
                            AsyncImage(url: URL(string: viewModel.boothModel.selectedBooth?.thumbnail ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: geometry.size.width, height: 260)
                                    .clipped()
                            } placeholder: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(.lightGray)
                                    
                                    Image(.noImagePlaceholder)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                }
                            }
                            .frame(height: 260)
                            .frame(maxWidth: .infinity)
                        }
                        
                        if viewModel.boothModel.selectedBooth == nil {
                            VStack {
                                if !isReloadButtonPresent {
                                    ProgressView()
                                }
                            }
                            .frame(height: 160)
                        } else {
                            HStack {
                                Text(viewModel.boothModel.selectedBooth?.name ?? "")
                                    .font(.system(size: 22))
                                    .bold()
                                    .lineLimit(1)
                                
                                Text(viewModel.boothModel.selectedBooth?.warning ?? "")
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.accent)
                                    .padding(.bottom, 4)
                                    .lineLimit(2)
                                
                                Spacer()
                            }
                            .padding()
//                            .frame(maxWidth: .infinity)
                            
                            VStack {
                                Text(viewModel.boothModel.selectedBooth?.description ?? "")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.darkGray)
                                    .padding(.bottom)
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            
                            HStack {
                                Image(.greenMarker)
                                
                                Text(viewModel.boothModel.selectedBooth?.location ?? "")
                                    .font(.system(size: 13))
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                            
                            Button {
                                isMapViewPresented = true
                            } label: {
                                Image(.longPinkButton)
                                    .overlay {
                                        Text(StringLiterals.Detail.openLocation)
                                            .font(.system(size: 13))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.accent)
                                    }
                            }
                            .padding(.bottom)
                        }
                        
                        Image(.boldLine)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 8)
                        
                        HStack {
                            Text(StringLiterals.Detail.menuTitle)
                                .font(.system(size: 18))
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 6)
                        
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
                                            MenuBar(imageURL: menu.imgUrl ?? "", name: menu.name ?? "", price: menu.price ?? 0)
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
                    
                    Spacer()
                        .frame(height: 70)
                }
                .ignoresSafeArea(edges: .top)
                .background(.background)
                .fullScreenCover(isPresented: $isMapViewPresented, content: {
                    OneMapView(viewModel: viewModel, booth: viewModel.boothModel.selectedBooth)
                        .onAppear {
                            GATracking.eventScreenView(GATracking.ScreenNames.oneMapView)
                        }
                })
            }
            
            VStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        Spacer()
                            .frame(width: 10)
                        
                        VStack {
                            Button {
                                if viewModel.boothModel.isBoothContain(viewModel.boothModel.selectedBoothID) {
                                    // delete
                                    GATracking.sendLogEvent(GATracking.LogEventType.BoothDetailView.BOOTH_DETAIL_LIKE_CANCEL, params: ["boothID": viewModel.boothModel.selectedBoothID])
                                    viewModel.boothModel.deleteLikeBoothListDB(viewModel.boothModel.selectedBoothID)
                                    viewModel.boothModel.deleteLike(viewModel.boothModel.selectedBoothID)
                                } else {
                                    // add
                                    GATracking.sendLogEvent(GATracking.LogEventType.BoothDetailView.BOOTH_DETAIL_LIKE_ADD, params: ["boothID": viewModel.boothModel.selectedBoothID])
                                    viewModel.boothModel.insertLikeBoothDB(viewModel.boothModel.selectedBoothID)
                                    viewModel.boothModel.addLike(viewModel.boothModel.selectedBoothID)
                                }
                            } label: {
                                Image(viewModel.boothModel.isBoothContain(viewModel.boothModel.selectedBoothID) ? .pinkBookMark : .bookmark)
                            }
                            .padding(.horizontal, 10)
                            .disabled(viewModel.boothModel.selectedBooth == nil)
                            
                            if viewModel.boothModel.selectedBooth == nil {
                                Text("-")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.darkGray)
                            } else {
                                Text("\(viewModel.boothModel.selectedBoothNumLike > 0 ? viewModel.boothModel.selectedBoothNumLike : 0)")
                                    .font(.system(size: 10))
                                    .foregroundStyle(.darkGray)
                            }
                        }
                        .padding(.top, 8)
                        
                        Button {
                            // TODO: To Waiting
                        } label: {
                            Image(.longButtonDarkGray)
                                .overlay {
                                    if viewModel.boothModel.selectedBooth == nil {
                                        if !isReloadButtonPresent {
                                            ProgressView()
                                        } else {
                                            Text(StringLiterals.Detail.noWaitingBooth)
                                                .foregroundStyle(.white)
                                                .font(.system(size: 14))
                                                .bold()
                                        }
                                    } else {
                                        Text(StringLiterals.Detail.noWaitingBooth)
                                            .foregroundStyle(.white)
                                            .font(.system(size: 14))
                                            .bold()
                                    }
                                }
                        }
                        .disabled(true)
                        
                        Spacer()
                            .frame(width: 20)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.background)
                .shadow(color: .black.opacity(0.12), radius: 18.5, x: 0, y: -4)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isReloadButtonPresent = true
            }
            GATracking.eventScreenView(GATracking.ScreenNames.boothDetailView)
        }
        .onDisappear {
            viewModel.boothModel.selectedBooth = nil
            viewModel.boothModel.selectedBoothID = 0
        }
    }
}

#Preview {
    @ObservedObject var viewModel = RootViewModel()
    
    return Group {
        DetailView(viewModel: viewModel)
            .onAppear {
                viewModel.boothModel.selectedBoothID = 126
                viewModel.boothModel.loadBoothDetail(126)
            }
    }
}

struct MenuBar: View {
    let imageURL: String
    let name: String
    let price: Int
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 86, height: 86)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.lightGray)
                        .frame(width: 86, height: 86)
                    
                    Image(.noImagePlaceholder)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.trailing, 8)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 14))
                    .fontWeight(.semibold)
                    .padding(.bottom, 1)
                
                if price == 0 {
                    Text("무료")
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                } else {
                    Text("\(price)" + StringLiterals.Detail.won)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                }
            }
            
            Spacer()
        }
    }
}
