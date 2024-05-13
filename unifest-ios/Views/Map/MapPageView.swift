//
//  MapPageView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/22/24.
//

import SwiftUI

struct MapPageView: View {
    @ObservedObject var mapViewModel: MapViewModel = MapViewModel()
    @State private var isPopularBoothPresented: Bool = false
    
    @State private var isSearchSchoolViewPresented: Bool = false
    @State private var isDetailViewPresented: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                MapView(mapViewModel: mapViewModel)
            }
            
            VStack {
                MapPageHeaderView(isSearchSchoolViewPresented: $isSearchSchoolViewPresented)
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
                
                Button {
                    withAnimation(.spring) {
                        isPopularBoothPresented.toggle()
                    }
                } label: {
                    Image(.popBoothButton)
                        .overlay {
                            HStack {
                                Text("인기 부스")
                                    .font(.system(size: 13))
                                    .foregroundStyle(.accent)
                                    .fontWeight(.semibold)
                                Image(.upPinkArrow)
                                    .rotationEffect(isPopularBoothPresented ? .degrees(180) : .degrees(0))
                            }
                            .padding(.bottom, 2)
                        }
                }
                
                if isPopularBoothPresented {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            BoothBox(rank: 1, title: "컴공 주점", description: "저희 주점은 일본 이자카야를 모티브로 만든 컴공인을 위한 주점입니다.", position: "청심대 앞", imageURL: "")
                                .onTapGesture {
                                    isDetailViewPresented = true
                                }
                            BoothBox(rank: 2, title: "컴공 주점", description: "저희 주점은 일본 이자카야를 모티브로 만든 컴공인을 위한 주점입니다.", position: "청심대 앞", imageURL: "")
                                .onTapGesture {
                                    isDetailViewPresented = true
                                }
                            BoothBox(rank: 3, title: "컴공 주점", description: "저희 주점은 일본 이자카야를 모티브로 만든 컴공인을 위한 주점입니다.", position: "청심대 앞", imageURL: "")
                                .onTapGesture {
                                    isDetailViewPresented = true
                                }
                            BoothBox(rank: 4, title: "컴공 주점", description: "저희 주점은 일본 이자카야를 모티브로 만든 컴공인을 위한 주점입니다.", position: "청심대 앞", imageURL: "")
                                .onTapGesture {
                                    isDetailViewPresented = true
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
            DetailView()
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    TabView {
        MapPageView()
            .tabItem {
                Image(.tabMapSelected)
                Text("지도")
            }
    }
}

struct MapPageHeaderView: View {
    @State private var isInfoTextPresented: Bool = true
    @State private var searchText: String = ""
    @State private var isTagSelected: [Bool] = [true, true, false, false]
    
    @Binding var isSearchSchoolViewPresented: Bool
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    isSearchSchoolViewPresented = true
                } label: {
                    HStack {
                        Text("건국대학교")
                            .font(.system(size: 20))
                            .bold()
                            .foregroundStyle(.defaultBlack)
                        
                        Image(.downArrow)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                    }
                }
                
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
                    .opacity(isInfoTextPresented ? 1 : 0)
                
                Spacer()
            }
            .padding(.horizontal)
            
            Image(.searchBox)
                .overlay {
                    HStack {
                        TextField("부스/주점을 검색해보세요.", text: $searchText)
                            .font(.system(size: 13))
                        Image(.searchIcon)
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.bottom, 6)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    Image(isTagSelected[0] ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text("주점")
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundStyle(isTagSelected[0] ? .defaultPink : .defaultBlack)
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                isTagSelected[0].toggle()
                            }
                        }
                    
                    Image(isTagSelected[1] ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text("부스")
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundStyle(isTagSelected[1] ? .defaultPink : .defaultBlack)
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                isTagSelected[1].toggle()
                            }
                        }
                    
                    Image(isTagSelected[2] ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text("의무실")
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundStyle(isTagSelected[2] ? .defaultPink : .defaultBlack)
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                isTagSelected[2].toggle()
                            }
                        }
                    
                    Image(isTagSelected[3] ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text("화장실")
                                .fontWeight(.semibold)
                                .font(.system(size: 13))
                                .foregroundStyle(isTagSelected[3] ? .defaultPink : .defaultBlack)
                        }
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                isTagSelected[3].toggle()
                            }
                        }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    MapPageHeaderView(isSearchSchoolViewPresented: .constant(false))
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
                                
                                ProgressView()
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        VStack {
                            HStack {
                                Circle()
                                    .fill(Color.defaultPink)
                                    .frame(width: 36, height: 36)
                                    .overlay {
                                        Text("\(rank)위")
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

#Preview {
    ZStack {
        Color.gray
        BoothBox(rank: 1, title: "컴공 주점", description: "저희 주점은 일본 이자카야를 모티브로 만든 컴공인을 위한 주점입니다.", position: "청심대 앞", imageURL: "https://i.namu.wiki/i/JaudlPaMxzH-kbYH_b788UT_sX47F_ajB1hFH7s37d5CZUqOfA6vcoXMiW3E4--hG_PwgDcvQ6Hi021KyzghLQ.webp")
    }
}
