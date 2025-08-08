//
//  MapPageView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/22/24.
//

import SwiftUI

// MapPageView는 TabBar에서 '지도'를 선택했을 때 나타나는 뷰
// MapPageView는 MapPageHeaderView와 MapView로 이루어져있음
// MapPageHeaderView는 위에 보이는 검색창과 주점, 먹거리.. 가 있는 뷰
// MapView는 그 밑에 있는 지도뷰
// ZStack에 MapView(MapViewiOS17, mapViewiOS16)를 띄우고,
// 그 위에 VStack으로 MapPageHeaderView와 밑에 보이는 '인기부스' 버튼을 묶어서 띄움

// isPopularBoothPresented: '인기 부스' 버튼을 탭할 때 true/false
// isBoothListPresented: map의 annotation을 탭했을 때 true/false

struct MapPageView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    
    @State private var isBoothDetailViewPresented: Bool = false
    @State private var isBoothMapViewPresented: Bool = false
    @State private var tappedBoothId = 0
    @State private var searchText: String = ""
    
    private let boothImageURL: String = "" // URL 그냥 넣어버려
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Spacer()
                    
                    MapViewiOS17(viewModel: viewModel, mapViewModel: mapViewModel, searchText: $searchText)
                }
                
                VStack {
                    MapPageHeaderView(viewModel: viewModel, mapViewModel: mapViewModel, searchText: $searchText)
                        .background(.ufBackground)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 0,
                                bottomLeadingRadius: 23,
                                bottomTrailingRadius: 23,
                                topTrailingRadius: 0
                            )
                        )
                    
                    boothMapButtonView
                        .padding(.top, 18)
                    
                    Spacer()
                    
                    // 지도에서 annotation을 탭했을 때 보이는 X버튼
                    if mapViewModel.isBoothListPresented {
                        Button {
                            DispatchQueue.main.async {
                                withAnimation(.spring) {
                                    mapViewModel.isBoothListPresented = false
                                }
                            }
                            mapViewModel.setSelectedAnnotationID(-1)
                            viewModel.boothModel.updateMapSelectedBoothList([])
                        } label: {
                            Text("").roundedButton(background: .ufBackground, strokeColor: .primary500, height: 36, cornerRadius: 18)
                                .frame(width: 36)
                                .overlay {
                                    Image(systemName: "xmark")
                                        .foregroundColor(.primary500)
                                }
                        }
                    }
                    
                    if !viewModel.boothModel.top5booths.isEmpty && searchText.isEmpty && !mapViewModel.isBoothListPresented {
                        VStack {
                            Button {
                                if mapViewModel.isPopularBoothPresented {
                                    // on -> off
                                    GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLOSE_FABOR_BOOTH)
                                    DispatchQueue.main.async {
                                        withAnimation {
                                            mapViewModel.isPopularBoothPresented = false
                                        }
                                    }
                                } else {
                                    // off -> on
                                    GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_OPEN_FABOR_BOOTH)
                                    if mapViewModel.isBoothListPresented {
                                        DispatchQueue.main.async {
                                            withAnimation {
                                                mapViewModel.isBoothListPresented = false
                                            }
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        withAnimation {
                                            mapViewModel.isPopularBoothPresented = true
                                        }
                                    }
                                }
                            } label: {
                                Text("")
                                    .roundedButton(background: .ufNetworkErrorBackground, strokeColor: .primary500, height: 36, cornerRadius: 39)
                                    .frame(width: 120)
                                // Image(.popBoothButton)
                                    .overlay {
                                        HStack {
                                            Text(StringLiterals.Map.favoriteBoothTitle)
                                                .font(.pretendard(weight: .p7, size: 13))
                                                .foregroundStyle(.primary500)
                                            Image(.upPinkArrow)
                                                .rotationEffect(mapViewModel.isPopularBoothPresented ? .degrees(180) : .degrees(0))
                                        }
                                    }
                            }
                            
                            if mapViewModel.isPopularBoothPresented == false {
                                Spacer()
                                    .frame(height: 95)
                            }
                        }
                    }
                    
                    // isPopularBoothPresented: '인기 부스' 버튼을 탭할 때 true/false
                    // isBoothListPresented: map의 annotation을 탭했을 때 true/false
                    if mapViewModel.isPopularBoothPresented || mapViewModel.isBoothListPresented {
                        if mapViewModel.isPopularBoothPresented {
                            VStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        ForEach(Array(viewModel.boothModel.top5booths.enumerated()), id: \.1) { index, topBooth in
                                            BoothBox(rank: index, title: topBooth.name, description: topBooth.description, position: topBooth.location, imageURL: topBooth.thumbnail)
                                                .onTapGesture {
                                                    GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLOSE_FABOR_BOOTH, params: ["boothID": topBooth.id])
                                                    viewModel.boothModel.loadBoothDetail(topBooth.id)
                                                    isBoothDetailViewPresented = true
                                                }
                                        }
                                    }
                                    .padding(.horizontal, (geometry.size.width - 322) / 2) // (화면너비-BoothBox너비)/2를 padding으로 줌
                                    .frame(minWidth: geometry.size.width)
                                }
                                
                                Spacer()
                                    .frame(height: 93)
                            }
                            
                        } else {
                            if viewModel.boothModel.mapSelectedBoothList.isEmpty {
                                //
                            } else {
                                VStack {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            Spacer()
                                            
                                            ForEach(viewModel.boothModel.mapSelectedBoothList, id: \.self) { booth in
                                                BoothBox(rank: -1, title: booth.name, description: booth.description, position: booth.location, imageURL: booth.thumbnail)
                                                    .onTapGesture {
                                                        GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_BOOTH_ROW, params: ["boothID": booth.id])
                                                        viewModel.boothModel.loadBoothDetail(booth.id)
                                                        tappedBoothId = booth.id
                                                        isBoothDetailViewPresented = true
                                                    }
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, (geometry.size.width - 322) / 2) // (화면너비-BoothBox너비)/2를 padding으로 줌
                                        .frame(minWidth: geometry.size.width)
                                    }
                                    
                                    Spacer()
                                        .frame(height: 93) // VStack
                                }
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea()
            .sheet(isPresented: $isBoothDetailViewPresented) {
                BoothDetailView(viewModel: viewModel, mapViewModel: mapViewModel, currentBoothId: tappedBoothId)
                    .presentationDragIndicator(.visible)
            }
            .fullScreenCover(isPresented: $isBoothMapViewPresented) {
                ScalableImageView(imageName: boothImageURL)
            }
        }
    }
}

private extension MapPageView {
    var boothMapButtonView: some View {
        HStack {
            Spacer()
            
            Button {
                isBoothMapViewPresented = true
            } label: {
                Circle()
                    .foregroundStyle(.accent)
                    .frame(width: 56, height: 56)
                    .shadow(radius: 8.8, x: 2, y: 2)
                    .overlay {
                        Text("부스\n배치도")
                            .foregroundStyle(.ufWhite)
                            .font(.pretendard(weight: .p6, size: 13))
                    }
            }
            .padding(.trailing, 22)
        }
    }
}

extension UIApplication {
    func endEditing(_ force: Bool) {
        self.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct BoothBox: View {
    let rank: Int
    let title: String
    let description: String
    let position: String
    let imageURL: String
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(.ufBoothBoxBackground)
            .frame(width: 306, height: 116)
            .overlay {
                HStack {
                    ZStack {
                        AsyncImage(url: URL(string: imageURL)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 90, height: 86)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        } placeholder: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.lightGray)
                                    .frame(width: 90, height: 86)
                                
                                Image(.noImagePlaceholder)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                            }
                        }
                        .frame(width: 90, height: 86)
                        
                        if rank != -1 {
                            VStack {
                                HStack {
                                    Circle()
                                        .fill(Color.primary500)
                                        .frame(width: 36, height: 36)
                                        .overlay {
                                            Text("\(rank + 1)" + StringLiterals.Map.ranking)
                                                .font(.pretendard(weight: .p6, size: 13))
                                                .foregroundStyle(.ufBoothBoxBackground)
                                        }
                                    Spacer()
                                }
                                Spacer()
                            }
                            .offset(x: -10, y: -8)
                        }
                    }
                    .frame(width: 86, height: 86)
                    .padding(.leading, 14)
                    
                    VStack(alignment: .leading) {
                        // MarqueeText(text: title, font: .systemFont(ofSize: 18), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .leading)
                        Text(title)
                            .font(.pretendard(weight: .p6, size: 18))
                            .foregroundStyle(.grey900)
                            .baselineOffset(3)
                            .lineLimit(1)
                        
                        Text(description.isEmpty ? "등록된 정보가 없습니다" : description)
                            .font(.pretendard(weight: .p4, size: 13))
                            .foregroundStyle(.grey600)
                            .lineLimit(2)
                        
                        Spacer()
                        
                        HStack(spacing: 2) {
                            Image(.marker)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            
                            // MarqueeText(text: position, font: .systemFont(ofSize: 13), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .leading)
                            Text(position.isEmpty ? "등록된 위치 설명이 없습니다" : position)
                                .font(.pretendard(weight: .p6, size: 13))
                                .foregroundStyle(.grey700)
                                .lineLimit(1)
                        }
                        .padding(.bottom, 3)
                    }
                    .padding(.leading, 10)
                    .padding(.vertical, 15)
                    
                    Spacer()
                }
            }
    }
}

#Preview {
     MapPageView(viewModel: RootViewModel(), mapViewModel: MapViewModel(viewModel: RootViewModel()))
//    BoothBox(rank: -1, title: "test", description: "test", position: "", imageURL: "")
}
