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
    @State private var isOneImagePresented: Bool = false
    @State private var selectedMenuURL: String = ""
    @State private var selectedMenuName: String = ""
    @State private var selectedMenuPrice: String = ""
    
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
                                        .fill(.defaultLightGray)
                                    
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
                            VStack(alignment: .leading) {
                                /* MarqueeText(text: viewModel.boothModel.selectedBooth?.name ?? "", font: .systemFont(ofSize: 22), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .leading)
                                    .frame(maxWidth: 160)
                                    .bold()
                                    .border(.green)*/
                                /* Text(viewModel.boothModel.selectedBooth?.name ?? "")
                                    .font(.system(size: 22))
                                    .bold()
                                    .lineLimit(1)
                                 */
                                // Text(viewModel.boothModel.selectedBooth?.name ?? "")
                                if let name = viewModel.boothModel.selectedBooth?.name {
                                    if !name.isEmpty {
                                        MarqueeText(text: name, font: .systemFont(ofSize: 24), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .leading)
                                        // .font(.system(size: 24))
                                            .fontWeight(.bold)
                                            .padding(.bottom, 4)
                                        // .border(.green)
                                    }
                                }
                                
                                if let warning = viewModel.boothModel.selectedBooth?.warning {
                                    if !warning.isEmpty {
                                        Text(viewModel.boothModel.selectedBooth?.warning ?? "")
                                            .font(.system(size: 11))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.accent)
                                            .lineLimit(3)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            // .border(.red)
                            
                            if let description = viewModel.boothModel.selectedBooth?.description {
                                if !description.isEmpty {
                                    VStack {
                                        Text(viewModel.boothModel.selectedBooth?.description ?? "")
                                            .font(.system(size: 13))
                                            .foregroundStyle(.darkGray)
                                            .padding(.bottom)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal)
                                }
                            }
                            
                            HStack {
                                Image(.greenMarker)
                                
                                MarqueeText(text: viewModel.boothModel.selectedBooth?.location ?? "", font: .systemFont(ofSize: 13), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .leading)
                                // Text(viewModel.boothModel.selectedBooth?.location ?? "")
                                    // .font(.system(size: 13))
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                            
                            Button {
                                isMapViewPresented = true
                            } label: {
                                // Image(.longPinkButton)
                                Text("")
                                    .roundedButton(background: .defaultWhite, strokeColor: .accent, height: 33, cornerRadius: 10)
                                    .padding(.horizontal)
                                    .overlay {
                                        Text(StringLiterals.Detail.openLocation)
                                            .font(.system(size: 13))
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.accent)
                                    }
                            }
                            .padding(.bottom)
                        }
                        
                        Text("").boldLine().padding(.bottom, 8)
                        /* Image(.boldLine)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 8)*/
                        
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
                                            MenuBar(imageURL: menu.imgUrl ?? "", name: menu.name ?? "", price: menu.price ?? 0, isImagePresented: $isOneImagePresented, selectedURL: $selectedMenuURL, selectedName: $selectedMenuName, selectedPrice: $selectedMenuPrice)
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
                    if #available(iOS 17, *) {
                        OneMapViewiOS17(viewModel: viewModel, booth: viewModel.boothModel.selectedBooth)
                            .onAppear {
                                GATracking.eventScreenView(GATracking.ScreenNames.oneMapView)
                            }
                    } else {
                        OneMapViewiOS16(viewModel: viewModel, booth: viewModel.boothModel.selectedBooth)
                            .onAppear {
                                GATracking.eventScreenView(GATracking.ScreenNames.oneMapView)
                            }
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
                            Text("")
                                .roundedButton(background: .defaultDarkGray, strokeColor: .clear, height: 45, cornerRadius: 10)
                            // Image(.longButtonDarkGray)
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
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 26, height: 26)
                                .tint(.defaultWhite.opacity(0.5))
                            
                            Image(systemName: "xmark.circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.defaultBlack)
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            
            if isOneImagePresented {
                OneImageView(isPresented: $isOneImagePresented, imageURL: selectedMenuURL, name: selectedMenuName, price: selectedMenuPrice)
                    .onDisappear {
                        selectedMenuURL = ""
                        selectedMenuName = ""
                        selectedMenuPrice = ""
                    }
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
        Text("")
            .sheet(isPresented: .constant(true), content: {
                DetailView(viewModel: viewModel)
                    .onAppear {
                        viewModel.boothModel.selectedBoothID = 119
                        viewModel.boothModel.loadBoothDetail(119)
                    }
            })
    }
}

struct MenuBar: View {
    let imageURL: String
    let name: String
    let price: Int
    @Binding var isImagePresented: Bool
    @Binding var selectedURL: String
    @Binding var selectedName: String
    @Binding var selectedPrice: String
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 86, height: 86)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .onTapGesture {
                        selectedURL = imageURL
                        selectedName = name
                        selectedPrice = formattedPrice(price) + StringLiterals.Detail.won
                        withAnimation(.spring(duration: 0.1)) {
                            isImagePresented = true
                        }
                    }
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.defaultLightGray)
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
                    Text(formattedPrice(price) + StringLiterals.Detail.won)
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                }
            }
            
            Spacer()
        }
    }
    
    func formattedPrice(_ price: Int) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            
            if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
                return "\(formattedPrice)"
            } else {
                return "\(price)"
            }
        }
}
