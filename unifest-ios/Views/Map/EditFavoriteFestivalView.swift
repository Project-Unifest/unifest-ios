//
//  EditFavoriteFestivalView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/24/24.
//

import SwiftUI

// 검색을 하지 않았을 때는 '나의 관심축제(SchoolBoxView)'뷰
// 검색을 했을 때는 '검색 결과(LongSchoolBoxView)'뷰가 보이게 만듦

struct EditFavoriteFestivalView: View {
    @State private var searchText: String = ""
    let columns = [GridItem(.adaptive(minimum: 114))]
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @EnvironmentObject var favoriteFestivalVM: FavoriteFestivalViewModel
    @EnvironmentObject var networkManager: NetworkManager
    @Environment(\.dismiss) var dismiss
    @State private var isUpdatingFavoriteFestival: Bool = false
    @State private var isClustering: Bool = true
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    Spacer()
                        .frame(height: 30)
                    
                    // 학교/축제 데이터는 FestivalModel의 이니셜라이저에서 앱이 처음 실행될 때 저장됨
                    Image(.searchBox)
                        .overlay {
                            HStack {
                                TextField("학교/축제 이름을 검색해보세요", text: $searchText)
                                    .font(.system(size: 13))
                                    .onChange(of: searchText) { newValue in
                                        viewModel.festivalModel.filterFestivals(byKeyword: searchText)
                                        
                                        if newValue.isEmpty {
                                            viewModel.festivalModel.festivalSearchResult = viewModel.festivalModel.festivals
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
                            .padding(.horizontal, 15)
                        }
                        .padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        Text("학교 로고를 탭하면 해당 축제의 지도로 이동해요")
                            .font(.pretendard(weight: .p5, size: 13))
                            .foregroundStyle(.primary500)
                            .padding(.bottom, 4)
                        
                        HStack {
                            Text("검색결과")
                                .font(.pretendard(weight: .p5, size: 13))
                                .foregroundStyle(.grey600)
                            Text("총 \(viewModel.festivalModel.festivalSearchResult.count)개")
                                .font(.pretendard(weight: .p5, size: 13))
                                .foregroundStyle(.grey900)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                    
                    ForEach(viewModel.festivalModel.festivalSearchResult, id: \.festivalId) { festival in
                        LongSchoolBoxView(
                            viewModel: viewModel,
                            mapViewModel: mapViewModel,
                            festivalId: festival.festivalId,
                            thumbnail: festival.thumbnail ?? "",
                            schoolName: festival.schoolName,
                            festivalName: festival.festivalName,
                            startDate: formatDate(festival.beginDate),
                            endDate: formatDate(festival.endDate),
                            isUpdatingFavoriteFestival: $isUpdatingFavoriteFestival
                        )
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 6)
                    
                    Rectangle()
                        .fill(.grey100)
                        .frame(height: 8)
                    
                    HStack {
                        Text("나의 관심 축제")
                            .font(.pretendard(weight: .p6, size: 15))
                            .foregroundStyle(.grey900)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    if favoriteFestivalVM.favoriteFestivalList.isEmpty {
                        VStack {
                            Text("추가한 관심축제가 없어요")
                                .font(.pretendard(weight: .p4, size: 14))
                                .foregroundStyle(.grey600)
                                .padding(.vertical, 60)
                                .padding(.bottom, 20)
                        }
                    } else {
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                                ForEach(viewModel.festivalModel.festivalSearchResult, id: \.festivalId) { festival in
                                    let isFavoriteFestival = favoriteFestivalVM.favoriteFestivalList.contains(festival.festivalId) // 해당 festival이 관심축제에 추가됐는지 나타냄
                                    
                                    if isFavoriteFestival {
                                        SchoolBoxView(
                                            isSelected: .constant(false),
                                            festivalId: festival.festivalId,
                                            schoolImageURL: festival.thumbnail ?? "",
                                            schoolName: festival.schoolName,
                                            festivalName: festival.festivalName,
                                            startDate: festival.beginDate,
                                            endDate: festival.endDate,
                                            isUpdatingFavoriteFestival: $isUpdatingFavoriteFestival
                                        )
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .onAppear {
                    // 처음 나타날 때는 모든 축제 다 보여주기
                    viewModel.festivalModel.festivalSearchResult = viewModel.festivalModel.festivals
                }
                .onDisappear {
                    let mapFestivalId = FestivalIdManager.mapFestivalId
                    viewModel.boothModel.loadStoreListData(festivalId: mapFestivalId) {
                        print("\(mapFestivalId) 축제 부스 로드 완료")
                    }
                    viewModel.boothModel.loadTop5Booth(festivalId: mapFestivalId)
                    isClustering = UserDefaults.standard.bool(forKey: "IS_CLUSTER_ON_MAP")
                    mapViewModel.updateAnnotationList(makeCluster: isClustering)
                }
                .task {
                    await favoriteFestivalVM.getFavoriteFestivalList(deviceId: DeviceUUIDManager.shared.getDeviceToken())
                }
                .dynamicTypeSize(.large)
            }
            
            if isUpdatingFavoriteFestival {
                ZStack {
                    Color.black.opacity(0.66)
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(.circular)
                            .tint(Color.white)
                        Spacer()
                    }
                }
            }
            
            if networkManager.isNetworkConnected == false {
                NetworkErrorView(errorType: .network)
                    .onAppear {
                        GATracking.eventScreenView(GATracking.ScreenNames.networkErrorView)
                    }
            }
            
            if networkManager.isServerError == true {
                NetworkErrorView(errorType: .server)
                    .onAppear {
                        GATracking.eventScreenView(GATracking.ScreenNames.networkErrorView)
                    }
            }
        }
        .toastView(toast: $favoriteFestivalVM.updateSucceededToast)
        .dynamicTypeSize(.large)
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: dateString) else {
            return ""
        }
        
        // Format month and day
        let month = Calendar.current.component(.month, from: date)
        let day = Calendar.current.component(.day, from: date)
        
        return "\(month).\(day)"
    }
}
