//
//  DetailView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/26/24.
//

import SwiftUI

struct DetailView: View {
    @State private var isMapViewPresented: Bool = false
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var boothModel: BoothModel
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        ZStack {
                            AsyncImage(url: URL(string: boothModel.selectedBooth?.thumbnail ?? "")) { image in
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
                        
                        HStack {
                            Text(boothModel.selectedBooth?.name ?? "")
                                .font(.system(size: 22))
                                .bold()
                            
                            VStack {
                                Spacer()
                                
                                Text(boothModel.selectedBooth?.warning ?? "")
                                    .font(.system(size: 10))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.accent)
                                    .padding(.bottom, 4)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text(boothModel.selectedBooth?.description ?? "")
                                .font(.system(size: 13))
                                .foregroundStyle(.darkGray)
                                .padding(.horizontal)
                                .padding(.bottom)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Image(.greenMarker)
                            
                            Text(boothModel.selectedBooth?.location ?? "")
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
                        
                        if let booth = boothModel.selectedBooth {
                            if booth.menus.isEmpty {
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
                                    ForEach(boothModel.selectedBooth!.menus, id: \.self) { menu in
                                        MenuBar(imageURL: menu.imgUrl, name: menu.name, price: menu.price)
                                    }
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 20)
                            }
                        }
                    }
                    
                    Spacer()
                        .frame(height: 70)
                }
                .ignoresSafeArea(edges: .top)
                .background(.background)
                .fullScreenCover(isPresented: $isMapViewPresented, content: {
                    OneMapView(mapViewModel: MapViewModel(), booth: boothModel.selectedBooth)
                })
            }
            
            VStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 10)
                    
                    HStack {
                        VStack {
                            Button {
                                if boothModel.isBoothContain(boothModel.selectedBoothID) {
                                    // delete
                                    boothModel.deleteLikeBoothListDB(boothModel.selectedBoothID)
                                    boothModel.deleteLike(boothModel.selectedBoothID)
                                } else {
                                    // add
                                    boothModel.insertLikeBoothDB(boothModel.selectedBoothID)
                                    boothModel.addLike(boothModel.selectedBoothID)
                                }
                            } label: {
                                Image(boothModel.isBoothContain(boothModel.selectedBoothID) ? .pinkBookMark : .bookmark)
                            }
                            .padding(.horizontal, 10)
                            
                            
                            Text("\(boothModel.selectedBoothNumLike > 0 ? boothModel.selectedBoothNumLike : 0)")
                                .font(.system(size: 10))
                                .foregroundStyle(.darkGray)
                        }
                        .padding(.top, 2)
                        
                        Button {
                            
                        } label: {
                            Image(.longButtonDarkGray)
                                .overlay {
                                    Text(StringLiterals.Detail.noWaitingBooth)
                                        .foregroundStyle(.white)
                                        .font(.system(size: 14))
                                        .bold()
                                }
                        }
                        .padding(.trailing, 10)
                        .disabled(true)
                    }
                }
                .frame(maxWidth: .infinity)
                .background(.background)
                .shadow(color: .black.opacity(0.12), radius: 18.5, x: 0, y: -4)
            }
        }
    }
}

#Preview {
    @ObservedObject var boothModel = BoothModel()
    
    return Group {
        DetailView(boothModel: boothModel)
            .onAppear {
                boothModel.loadBoothDetail(78)
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
                
                Text("\(price)" + StringLiterals.Detail.won)
                    .font(.system(size: 16))
                    .fontWeight(.semibold)
            }
            
            Spacer()
        }
    }
}
