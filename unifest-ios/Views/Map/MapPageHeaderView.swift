//
//  MapPageHeaderView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/1/24.
//

import SwiftUI

struct MapPageHeaderView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @State private var isInfoTextPresented: Bool = true
    @Binding var searchText: String
    @State private var isEditFavoriteFestivalViewPresented = false
    @State private var isVoteViewPresented = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    isEditFavoriteFestivalViewPresented = true
                } label: {
                    HStack {
                        Text(festivalMapDataList[mapViewModel.festivalMapDataIndex].schoolName)
                            .font(.pretendard(weight: .p6, size: 18))
                            .foregroundStyle(.grey900)
                        
                        Image(.downArrow)
                         .resizable()
                         .scaledToFit()
                         .frame(width: 12, height: 12)
                    }
                }
                
                Image(.blackBubble)
                    .resizable()
                    .frame(width: 180, height: 30)
                    .overlay {
                        VStack(alignment: .center) {
                            Text("    여기서 축제를 선택할 수 있어요.")
                                .font(.pretendard(weight: .p5, size: 11))
                                .foregroundStyle(.white)
                                .padding(.top, 2)
                        }
                    }
                    .opacity(isInfoTextPresented ? 1 : 0)
                    .onAppear {
                        isInfoTextPresented = true
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                            withAnimation(.easeOut(duration: 1.2)) {
//                                isInfoTextPresented = false
//                            }
//                        }
                    }
                    .onTapGesture {
                        isInfoTextPresented = false
                    }
                
                Spacer()
                
//                Button {
//                    isVoteViewPresented = true
//                } label: {
//                    Image(.vote)
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                }
            }
            .padding(.horizontal, 18)
            
            Text("")
                .roundedButton(background: .ufBackground, strokeColor: .grey400, height: 46, cornerRadius: 67)
                .padding(.horizontal)
            // Image(.searchBox)
                .overlay {
                    HStack {
//                        if #available(iOS 17, *) {
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
//                        } else {
//                            TextField(StringLiterals.Map.searchPlaceholder, text: $searchText)
//                                .font(.system(size: 13))
//                                .onChange(of: searchText) { _ in
//                                    if !searchText.isEmpty {
//                                        mapViewModel.isPopularBoothPresented = false
//                                        mapViewModel.isBoothListPresented = false
//                                        mapViewModel.setSelectedAnnotationID(-1)
//                                        viewModel.boothModel.updateMapSelectedBoothList([])
//                                    }
//                                }
//                        }
                        
                        if searchText.isEmpty {
                            Image(.searchIcon)
                        } else {
                            Button {
                                searchText = ""
                                UIApplication.shared.endEditing(true)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.grey600)
                            }
                        }
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.bottom, 6)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    Text("")
                        .roundedButton(background: (mapViewModel.isTagSelected[.drink] ?? false) ? .primary500.opacity(0.2) : .ufBackground, strokeColor: (mapViewModel.isTagSelected[.drink] ?? false) ? .primary500 : .grey400, height: 26, cornerRadius: 34)
                        .frame(width: 56)
                        .padding(.vertical, 1)
                    // Image(mapViewModel.isTagSelected[.drink] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.drinkBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.drink] ?? false ? .primary500 : .grey600)
                        }
                        .onTapGesture {
                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_TAG_BUTTON, params: ["tagType": BoothType.drink.rawValue, "turn": (mapViewModel.isTagSelected[.drink] ?? false) ? "off" : "on"])
                            DispatchQueue.main.async {
                                withAnimation(.spring(duration: 0.2)) {
                                    mapViewModel.isTagSelected[.drink]?.toggle()
                                }
                            }
                        }
                    
                    Text("")
                        .roundedButton(background: (mapViewModel.isTagSelected[.food] ?? false) ? .primary500.opacity(0.2) : .ufBackground, strokeColor: (mapViewModel.isTagSelected[.food] ?? false) ? .primary500 : .grey400, height: 26, cornerRadius: 34)
                        .frame(width: 56)
                        .padding(.vertical, 1)
                    // Image(mapViewModel.isTagSelected[.food] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.foodBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.food] ?? false ? .primary500 : .grey600)
                        }
                        .onTapGesture {
                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_TAG_BUTTON, params: ["tagType": BoothType.food.rawValue, "turn": (mapViewModel.isTagSelected[.food] ?? false) ? "off" : "on"])
                            DispatchQueue.main.async {
                                withAnimation(.spring(duration: 0.2)) {
                                    mapViewModel.isTagSelected[.food]?.toggle()
                                }
                            }
                        }
                    
                    Text("")
                        .roundedButton(background: (mapViewModel.isTagSelected[.event] ?? false) ? .primary500.opacity(0.2) : .ufBackground, strokeColor: (mapViewModel.isTagSelected[.event] ?? false) ? .primary500 : .grey400, height: 26, cornerRadius: 34)
                        .frame(width: 56)
                        .padding(.vertical, 1)
                    // Image(mapViewModel.isTagSelected[.event] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.eventBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.event] ?? false ?  .primary500 : .grey600)
                        }
                        .onTapGesture {
                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_TAG_BUTTON, params: ["tagType": BoothType.event.rawValue, "turn": (mapViewModel.isTagSelected[.event] ?? false) ? "off" : "on"])
                            DispatchQueue.main.async {
                                withAnimation(.spring(duration: 0.2)) {
                                    mapViewModel.isTagSelected[.event]?.toggle()
                                }
                            }
                        }
                    
                    Text("")
                        .roundedButton(background: (mapViewModel.isTagSelected[.booth] ?? false) ? .primary500.opacity(0.2) : .ufBackground, strokeColor: (mapViewModel.isTagSelected[.booth] ?? false) ? .primary500 : .grey400, height: 26, cornerRadius: 34)
                        .frame(width: 56)
                        .padding(.vertical, 1)
                    // Image(mapViewModel.isTagSelected[.booth] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.generalBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.booth] ?? false ? .primary500 : .grey600)
                        }
                        .onTapGesture {
                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_TAG_BUTTON, params: ["tagType": BoothType.booth.rawValue, "turn": (mapViewModel.isTagSelected[.booth] ?? false) ? "off" : "on"])
                            DispatchQueue.main.async {
                                withAnimation(.spring(duration: 0.2)) {
                                    mapViewModel.isTagSelected[.booth]?.toggle()
                                }
                            }
                        }
                    
                    Text("")
                        .roundedButton(background: (mapViewModel.isTagSelected[.hospital] ?? false) ? .primary500.opacity(0.2) : .ufBackground, strokeColor: (mapViewModel.isTagSelected[.hospital] ?? false) ? .primary500 : .grey400, height: 26, cornerRadius: 34)
                        .frame(width: 56)
                        .padding(.vertical, 1)
                    // Image(mapViewModel.isTagSelected[.hospital] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.hospitalBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.hospital] ?? false ? .primary500 : .grey600)
                        }
                        .onTapGesture {
                            GATracking.sendLogEvent(GATracking.LogEventType.MapView.MAP_CLICK_TAG_BUTTON, params: ["tagType": BoothType.hospital.rawValue, "turn": (mapViewModel.isTagSelected[.hospital] ?? false) ? "off" : "on"])
                            DispatchQueue.main.async {
                                withAnimation(.spring(duration: 0.2)) {
                                    mapViewModel.isTagSelected[.hospital]?.toggle()
                                }
                            }
                        }
                    
                    Text("")
                        .roundedButton(background: (mapViewModel.isTagSelected[.toilet] ?? false) ? .primary500.opacity(0.2) : .ufBackground, strokeColor: (mapViewModel.isTagSelected[.toilet] ?? false) ?  .primary500 : .grey400, height: 26, cornerRadius: 34)
                        .frame(width: 56)
                        .padding(.vertical, 1)
                    // Image(mapViewModel.isTagSelected[.toilet] ?? false ? .selectedTagBox : .nonselectedTagBox)
                        .overlay {
                            Text(StringLiterals.Map.toiletBoothTitle)
                                .font(.system(size: 13))
                                .foregroundStyle(mapViewModel.isTagSelected[.toilet] ?? false ? .primary500 : .grey600)
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
        .padding(.top, 60) 
        .padding(.bottom)
//        .fullScreenCover(isPresented: $isVoteViewPresented) {
//            VoteView()
//        }
        .sheet(isPresented: $isEditFavoriteFestivalViewPresented) {
            EditFavoriteFestivalView(viewModel: viewModel, mapViewModel: mapViewModel)
                .presentationDragIndicator(.visible)
            // .presentationDetents([.height(700)])
        }
    }
}

#Preview {
    MapPageHeaderView(viewModel: RootViewModel(), mapViewModel: MapViewModel(viewModel: RootViewModel()), searchText: .constant("부스/주점을 검색해보세요"))
}
