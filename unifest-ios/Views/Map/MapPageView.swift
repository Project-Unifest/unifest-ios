//
//  MapPageView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/22/24.
//

import SwiftUI

struct MapPageView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    
    @State private var isSearchSchoolViewPresented: Bool = false
    @State private var isDetailViewPresented: Bool = false
    
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                // MapView(mapViewModel: mapViewModel, boothModel: boothModel, isTagSelected: $isTagSelected, searchText: $searchText, selectedBoothIDList: $selectedBoothIDList, isBoothListPresented: $isBoothListPresented, isPopularBoothPresented: $isPopularBoothPresented)
                MapView(viewModel: viewModel, mapViewModel: mapViewModel, searchText: $searchText)
            }
            
            VStack {
                // MapPageHeaderView(searchText: $searchText, isTagSelected: $isTagSelected, isSearchSchoolViewPresented: $isSearchSchoolViewPresented, isPopularBoothPresented: $isPopularBoothPresented)
                MapPageHeaderView(viewModel: viewModel, mapViewModel: mapViewModel, searchText: $searchText)
                    .background(.background)
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
                    
                    if mapViewModel.isBoothListPresented {
                        Button {
                            withAnimation(.spring) {
                                mapViewModel.isBoothListPresented = false
                            }
                            mapViewModel.setSelectedAnnotationID(-1)
                            viewModel.boothModel.updateMapSelectedBoothList([])
                        } label: {
                            Image(.popCloseButton)
                        }
                    }
                    
                    if !viewModel.boothModel.top5booths.isEmpty && searchText.isEmpty && !mapViewModel.isBoothListPresented {
                        Button {
                            withAnimation(.spring) {
                                if mapViewModel.isPopularBoothPresented {
                                    // on -> off
                                    GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLOSE_FABOR_BOOTH)
                                    DispatchQueue.main.async {
                                        mapViewModel.isPopularBoothPresented = false
                                    }
                                } else {
                                    // off -> on
                                    GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_OPEN_FABOR_BOOTH)
                                    if mapViewModel.isBoothListPresented {
                                        DispatchQueue.main.async {
                                            mapViewModel.isBoothListPresented = false
                                        }
                                    }
                                    DispatchQueue.main.async {
                                        mapViewModel.isPopularBoothPresented = true
                                    }
                                }
                            }
                        } label: {
                            Image(.popBoothButton)
                                .overlay {
                                    HStack {
                                        Text(StringLiterals.Map.favoriteBoothTitle)
                                            .font(.system(size: 13))
                                            .foregroundStyle(.accent)
                                            .fontWeight(.semibold)
                                        Image(.upPinkArrow)
                                            .rotationEffect(mapViewModel.isPopularBoothPresented ? .degrees(180) : .degrees(0))
                                    }
                                    .padding(.bottom, 2)
                                }
                        }
                    }
                    
                    Spacer()
                }
                
                if mapViewModel.isPopularBoothPresented || mapViewModel.isBoothListPresented {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            if mapViewModel.isPopularBoothPresented {
                                ForEach(Array(viewModel.boothModel.top5booths.enumerated()), id: \.1) { index, topBooth in
                                    BoothBox(rank: index, title: topBooth.name, description: topBooth.description, position: topBooth.location, imageURL: topBooth.thumbnail)
                                        .onTapGesture {
                                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLOSE_FABOR_BOOTH, params: ["boothID": topBooth.id])
                                            viewModel.boothModel.loadBoothDetail(topBooth.id)
                                            isDetailViewPresented = true
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
                                                isDetailViewPresented = true
                                            }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 35)
                    }
                    .padding(.bottom)
                }
            }
            
        }
        .sheet(isPresented: $isSearchSchoolViewPresented) {
            SearchSchoolView()
                .presentationDragIndicator(.visible)
                // .presentationDetents([.height(700)])
        }
        .sheet(isPresented: $isDetailViewPresented) {
            DetailView(viewModel: viewModel)
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            viewModel.boothModel.loadTop5Booth()
        }
    }
}

#Preview {
    RootView(rootViewModel: RootViewModel())
}

struct MapPageHeaderView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @State private var isInfoTextPresented: Bool = true
    @Binding var searchText: String
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    // isSearchSchoolViewPresented = true
                } label: {
                    HStack {
                        Text("건국대학교")
                            .font(.system(size: 20))
                            .bold()
                            .foregroundStyle(.defaultBlack)
                        
                        /* Image(.downArrow)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16) */
                    }
                }
                
                /*
                Image(.blackBubble)
                    .overlay {
                        VStack(alignment: .center) {
                            Text("여기를 눌러서 학교를 검색해보세요.")
                                .font(.system(size: 11))
                                .foregroundStyle(.white)
                                .padding(.top, 2)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring(duration: 0.1)) {
                            isInfoTextPresented = false
                        }
                    }
                    .opacity(isInfoTextPresented ? 1 : 0)*/
                
                Spacer()
            }
            .padding(.horizontal)
            
            Image(.searchBox)
                .overlay {
                    HStack {
                        TextField(StringLiterals.Map.searchPlaceholder, text: $searchText)
                            .font(.system(size: 13))
                            .onChange(of: searchText) {
                                if !searchText.isEmpty {
                                    mapViewModel.isPopularBoothPresented = false
                                    mapViewModel.isBoothListPresented = false
                                    mapViewModel.setSelectedAnnotationID(-1)
                                    viewModel.boothModel.updateMapSelectedBoothList([])
                                }
                            }
                        
                        if searchText.isEmpty {
                            Image(.searchIcon)
                        } else {
                            Button {
                                searchText = ""
                                UIApplication.shared.endEditing(true)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.bottom, 6)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    Image(mapViewModel.isTagSelected[.drink] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.drinkBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.drink] ?? false ? .defaultPink : .gray)
                        }
                        .onTapGesture {
                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_TAG_BUTTON, params: ["tagType": BoothType.drink.rawValue, "turn": (mapViewModel.isTagSelected[.drink] ?? false) ? "off" : "on"])
                            DispatchQueue.main.async {
                                withAnimation(.spring(duration: 0.2)) {
                                    mapViewModel.isTagSelected[.drink]?.toggle()
                                }
                            }
                        }
                    
                    Image(mapViewModel.isTagSelected[.food] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.foodBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.food] ?? false ? .defaultPink : .gray)
                        }
                        .onTapGesture {
                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_TAG_BUTTON, params: ["tagType": BoothType.food.rawValue, "turn": (mapViewModel.isTagSelected[.food] ?? false) ? "off" : "on"])
                            DispatchQueue.main.async {
                                withAnimation(.spring(duration: 0.2)) {
                                    mapViewModel.isTagSelected[.food]?.toggle()
                                }
                            }
                        }
                    
                    Image(mapViewModel.isTagSelected[.event] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.eventBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.event] ?? false ? .defaultPink : .gray)
                        }
                        .onTapGesture {
                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_TAG_BUTTON, params: ["tagType": BoothType.event.rawValue, "turn": (mapViewModel.isTagSelected[.event] ?? false) ? "off" : "on"])
                            DispatchQueue.main.async {
                                withAnimation(.spring(duration: 0.2)) {
                                    mapViewModel.isTagSelected[.event]?.toggle()
                                }
                            }
                        }
                    
                    Image(mapViewModel.isTagSelected[.booth] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.generalBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.booth] ?? false ? .defaultPink : .gray)
                        }
                        .onTapGesture {
                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_TAG_BUTTON, params: ["tagType": BoothType.booth.rawValue, "turn": (mapViewModel.isTagSelected[.booth] ?? false) ? "off" : "on"])
                            DispatchQueue.main.async {
                                withAnimation(.spring(duration: 0.2)) {
                                    mapViewModel.isTagSelected[.booth]?.toggle()
                                }
                            }
                        }
                    
                    Image(mapViewModel.isTagSelected[.hospital] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.hospitalBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.hospital] ?? false ? .defaultPink : .gray)
                        }
                        .onTapGesture {
                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_TAG_BUTTON, params: ["tagType": BoothType.hospital.rawValue, "turn": (mapViewModel.isTagSelected[.hospital] ?? false) ? "off" : "on"])
                            DispatchQueue.main.async {
                                withAnimation(.spring(duration: 0.2)) {
                                    mapViewModel.isTagSelected[.hospital]?.toggle()
                                }
                            }
                        }
                    
                    Image(mapViewModel.isTagSelected[.toilet] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.toiletBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.toilet] ?? false ? .defaultPink : .gray)
                        }
                        .onTapGesture {
                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_TAG_BUTTON, params: ["tagType": BoothType.toilet.rawValue, "turn": (mapViewModel.isTagSelected[.toilet] ?? false) ? "off" : "on"])
                            DispatchQueue.main.async {
                                withAnimation(.spring(duration: 0.2)) {
                                    mapViewModel.isTagSelected[.toilet]?.toggle()
                                }
                            }
                        }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
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
            .fill(.background)
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
                                        .fill(Color.defaultPink)
                                        .frame(width: 36, height: 36)
                                        .overlay {
                                            Text("\(rank + 1)" + StringLiterals.Map.ranking)
                                                .font(.system(size: 13))
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.white)
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
                        Text(title)
                            .font(.system(size: 18))
                            .fontWeight(.semibold)
                            .padding(.bottom, 1)
                            .lineLimit(1)
                        
                        Text(description)
                            .font(.system(size: 13))
                            .foregroundStyle(.gray)
                            .lineLimit(2)
                        
                        HStack(spacing: 2) {
                            Image(.marker)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                            Text(position)
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                                .lineLimit(1)
                        }
                    }
                    .frame(width: 160)
                    .padding(.leading, 10)
                }
            }
    }
}
