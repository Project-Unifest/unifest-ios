//
//  MapPageView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/22/24.
//

import SwiftUI

// MapPageView는 TabBar에서 '지도'를 선택했을 때 나타나는 뷰
// MapPageView는 MapPageHeaderView와 MapView로 이루어져있음
// MapPageHeaderView는 이 프리뷰에서 위에 보이는 검색창과 주점, 먹거리.. 가 있는 뷰
// MapView는 그 밑에 있는 지도가 있는 뷰임
// ZStack에 MapView(MapViewiOS17, mapViewiOS16)를 띄우고, 
// 그 위에 VStack으로 MapPageHeaderView와 밑에 보이는 '인기부스' 버튼을 묶어서 띄움

// isPopularBoothPresented: '인기 부스' 버튼을 탭할 때 true/false
// isBoothListPresented: map의 annotation을 탭했을 때 true/false

struct MapPageView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel

    @State private var isBoothDetailViewPresented: Bool = false
    @State private var tappedBoothId = 0
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                
                if #available(iOS 17, *) {
                    MapViewiOS17(viewModel: viewModel, mapViewModel: mapViewModel, searchText: $searchText)
                } else {
                    MapViewiOS16(viewModel: viewModel, mapViewModel: mapViewModel, searchText: $searchText)
                }
            }
            
            VStack {
                // MapPageHeaderView(searchText: $searchText, isTagSelected: $isTagSelected, isSearchSchoolViewPresented: $isSearchSchoolViewPresented, isPopularBoothPresented: $isPopularBoothPresented)
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
                    
                Spacer()
                
                HStack(alignment: .center, spacing: 0) {
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
                            // Image(.popCloseButton)
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
                    
                    Spacer()
                }
                
                // isPopularBoothPresented: '인기 부스' 버튼을 탭할 때 true/false
                // isBoothListPresented: map의 annotation을 탭했을 때 true/false
                HStack {
                    Spacer()
                    
                    if mapViewModel.isPopularBoothPresented || mapViewModel.isBoothListPresented {
                        VStack {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    if mapViewModel.isPopularBoothPresented {
                                        ForEach(Array(viewModel.boothModel.top5booths.enumerated()), id: \.1) { index, topBooth in
                                            BoothBox(rank: index, title: topBooth.name, description: topBooth.description, position: topBooth.location, imageURL: topBooth.thumbnail)
                                                .onTapGesture {
                                                    GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLOSE_FABOR_BOOTH, params: ["boothID": topBooth.id])
                                                    viewModel.boothModel.loadBoothDetail(topBooth.id)
                                                    isBoothDetailViewPresented = true
                                                }
                                        }
                                    } else {
                                        if viewModel.boothModel.mapSelectedBoothList.isEmpty {
                                            //
                                        } else {
                                            ForEach(viewModel.boothModel.mapSelectedBoothList, id: \.self) { booth in
                                                BoothBox(rank: -1, title: booth.name, description: booth.description, position: booth.location, imageURL: booth.thumbnail)
                                                    .onTapGesture {
                                                        GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_BOOTH_ROW, params: ["boothID": booth.id])
                                                        viewModel.boothModel.loadBoothDetail(booth.id)
                                                        tappedBoothId = booth.id
                                                        isBoothDetailViewPresented = true
                                                    }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 35)
                                .frame(maxWidth: .infinity) // HStack을 화면 너비만큼 확장
                            }
                            .padding(.bottom)
                            
                            Spacer()
                                .frame(height: 80)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Spacer() // 우측 여백
                }
            }
            
        }
        .ignoresSafeArea()
        .sheet(isPresented: $isBoothDetailViewPresented) {
            BoothDetailView(viewModel: viewModel, currentBoothId: tappedBoothId)
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            viewModel.boothModel.loadTop5Booth()
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
                    
                    VStack(alignment: .leading) {
                        // MarqueeText(text: title, font: .systemFont(ofSize: 18), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .leading)
                        Text(title)
                            .font(.pretendard(weight: .p6, size: 18))
                            .foregroundStyle(.grey900)
                            .baselineOffset(3)
                            .lineLimit(1)
                        
                        Text(description)
                            .font(.pretendard(weight: .p4, size: 13))
                            .foregroundStyle(.grey600)
                            //.baselineOffset(4)
                            .lineLimit(2)
                        
                        HStack(spacing: 2) {
                            Image(.marker)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            
                            // MarqueeText(text: position, font: .systemFont(ofSize: 13), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .leading)
                            Text(position)
                                .font(.pretendard(weight: .p6, size: 13))
                                .foregroundStyle(.grey700)
                                .lineLimit(1)
                        }
                        .padding(.bottom, 3)
                    }
                    .frame(width: 160)
                    .padding(.leading, 10)
                }
            }
    }
}

#Preview {
    MapPageView(viewModel: RootViewModel(), mapViewModel: MapViewModel(viewModel: RootViewModel()))
}
