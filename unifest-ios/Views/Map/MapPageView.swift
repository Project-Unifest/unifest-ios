//
//  MapPageView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/22/24.
//

import SwiftUI

struct MapPageView: View {
    @ObservedObject var mapViewModel: MapViewModel
    @ObservedObject var boothModel: BoothModel
    
    @State private var isPopularBoothPresented: Bool = false
    
    @State private var isSearchSchoolViewPresented: Bool = false
    @State private var isDetailViewPresented: Bool = false
    
    @State private var searchText: String = ""
    
    @State private var isTagSelected: [BoothType: Bool] = [.drink: true, .food: true, .booth: true, .event: true, .hospital: true, .toilet: true]
    
    @State private var isBoothListPresented: Bool = false
    @State private var selectedBoothIDList: [Int] = []
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                MapView(mapViewModel: mapViewModel, boothModel: boothModel, isTagSelected: $isTagSelected, searchText: $searchText, selectedBoothIDList: $selectedBoothIDList, isBoothListPresented: $isBoothListPresented, isPopularBoothPresented: $isPopularBoothPresented)
            }
            
            VStack {
                MapPageHeaderView(searchText: $searchText, isTagSelected: $isTagSelected, isSearchSchoolViewPresented: $isSearchSchoolViewPresented, isPopularBoothPresented: $isPopularBoothPresented)
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
                    
                    if isBoothListPresented {
                        Button {
                            withAnimation(.spring) {
                                isBoothListPresented = false
                            }
                        } label: {
                            Image(.popCloseButton)
                        }
                    }
                    
                    if !boothModel.top5booths.isEmpty && searchText.isEmpty && !isBoothListPresented {
                        Button {
                            withAnimation(.spring) {
                                // isPopularBoothPresented.toggle()
                                if isPopularBoothPresented {
                                    // on -> off
                                    isPopularBoothPresented = false
                                } else {
                                    // off -> on
                                    if isBoothListPresented {
                                        isBoothListPresented = false
                                    }
                                    isPopularBoothPresented = true
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
                                            .rotationEffect(isPopularBoothPresented ? .degrees(180) : .degrees(0))
                                    }
                                    .padding(.bottom, 2)
                                }
                        }
                    }
                    
                    Spacer()
                }
                
                if isPopularBoothPresented || isBoothListPresented {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            if isPopularBoothPresented {
                                ForEach(Array(boothModel.top5booths.enumerated()), id: \.1) { index, topBooth in
                                    BoothBox(rank: index, title: topBooth.name, description: topBooth.description, position: topBooth.location, imageURL: topBooth.thumbnail)
                                        .onTapGesture {
                                            boothModel.loadBoothDetail(topBooth.id)
                                            isDetailViewPresented = true
                                        }
                                }
                            } else {
                                if boothModel.mapSelectedBoothList.isEmpty {
                                    //
                                } else {
                                    ForEach(boothModel.mapSelectedBoothList, id: \.self) { booth in
                                        BoothBox(rank: -1, title: booth.name, description: booth.description, position: booth.location, imageURL: booth.thumbnail)
                                            .onTapGesture {
                                                boothModel.loadBoothDetail(booth.id)
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
            DetailView(boothModel: boothModel)
                .presentationDragIndicator(.visible)
        }
        .onAppear {
            boothModel.loadTop5Booth()
        }
    }
}

#Preview {
    TabView {
        MapPageView(mapViewModel: MapViewModel(), boothModel: BoothModel())
            .tabItem {
                Image(.tabMapSelected)
                Text("지도")
            }
    }
}

struct MapPageHeaderView: View {
    @State private var isInfoTextPresented: Bool = true
    @Binding var searchText: String
    @Binding var isTagSelected: [BoothType: Bool]
    
    @Binding var isSearchSchoolViewPresented: Bool
    @Binding var isPopularBoothPresented: Bool
    
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
                                    withAnimation(.spring) {
                                        isPopularBoothPresented = false
                                    }
                                }
                            }
                        
                        if searchText.isEmpty {
                            Image(.searchIcon)
                        } else {
                            Button {
                                searchText = ""
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
                    Image(isTagSelected[.drink] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.drinkBoothTitle)
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundStyle(isTagSelected[.drink] ?? false ? .defaultPink : .defaultBlack)
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                isTagSelected[.drink]?.toggle()
                            }
                        }
                    
                    Image(isTagSelected[.food] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.foodBoothTitle)
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundStyle(isTagSelected[.food] ?? false ? .defaultPink : .defaultBlack)
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                isTagSelected[.food]?.toggle()
                            }
                        }
                    
                    Image(isTagSelected[.event] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.eventBoothTitle)
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundStyle(isTagSelected[.event] ?? false ? .defaultPink : .defaultBlack)
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                isTagSelected[.event]?.toggle()
                            }
                        }
                    
                    Image(isTagSelected[.booth] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.generalBoothTitle)
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundStyle(isTagSelected[.booth] ?? false ? .defaultPink : .defaultBlack)
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                isTagSelected[.booth]?.toggle()
                            }
                        }
                    
                    Image(isTagSelected[.hospital] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.hospitalBoothTitle)
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundStyle(isTagSelected[.hospital] ?? false ? .defaultPink : .defaultBlack)
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                isTagSelected[.hospital]?.toggle()
                            }
                        }
                    
                    Image(isTagSelected[.toilet] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.toiletBoothTitle)
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundStyle(isTagSelected[.toilet] ?? false ? .defaultPink : .defaultBlack)
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                isTagSelected[.toilet]?.toggle()
                            }
                        }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
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
                        }
                    }
                    .frame(width: 160)
                    .padding(.leading, 10)
                }
            }
    }
}

/* #Preview {
    ZStack {
        Color.gray
        BoothBox(rank: 1, title: "컴공 주점", description: "저희 주점은 일본 이자카야를 모티브로 만든 컴공인을 위한 주점입니다.", position: "청심대 앞", imageURL: "https://i.namu.wiki/i/JaudlPaMxzH-kbYH_b788UT_sX47F_ajB1hFH7s37d5CZUqOfA6vcoXMiW3E4--hG_PwgDcvQ6Hi021KyzghLQ.webp")
    }
}
*/
