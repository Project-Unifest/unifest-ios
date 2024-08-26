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
    @State private var isSearchSchoolViewPresented = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    isSearchSchoolViewPresented = true
                } label: {
                    HStack {
                        Text("건국대학교")
                            .font(.pretendard(weight: .p6, size: 20))
                            .foregroundStyle(.grey900)
                        
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
            
            Text("")
                .roundedButton(background: .ufBackground, strokeColor: .grey400, height: 46, cornerRadius: 67)
                .padding(.horizontal)
            // Image(.searchBox)
                .overlay {
                    HStack {
                        if #available(iOS 17, *) {
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
                        } else {
                            TextField(StringLiterals.Map.searchPlaceholder, text: $searchText)
                                .font(.system(size: 13))
                                .onChange(of: searchText) { _ in
                                    if !searchText.isEmpty {
                                        mapViewModel.isPopularBoothPresented = false
                                        mapViewModel.isBoothListPresented = false
                                        mapViewModel.setSelectedAnnotationID(-1)
                                        viewModel.boothModel.updateMapSelectedBoothList([])
                                    }
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
        .sheet(isPresented: $isSearchSchoolViewPresented) {
            SearchSchoolView()
                .presentationDragIndicator(.visible)
            // .presentationDetents([.height(700)])
        }
    }
}

#Preview {
    MapPageHeaderView(viewModel: RootViewModel(), mapViewModel: MapViewModel(viewModel: RootViewModel()), searchText: .constant("부스/주점을 검색해보세요"))
}
