//
//  AddFavoriteFestivalView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/24/24.
//

import SwiftUI

// MapPageHeaderView에서 학교이름을 탭했을 떄 나타나는 뷰
// 검색을 하지 않았을 때는 '나의 관심축제' 뷰 <- SchoolBoxView
// 검색을 했을 때는 '검색 결과' 뷰가 보이게 만듦 <- LongSchoolBoxView

struct EditFavoriteFestivalView: View {
    @State private var searchText: String = ""
    let columns = [GridItem(.adaptive(minimum: 114))]
    @ObservedObject var viewModel: RootViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
                
                HStack {
                    Text("검색결과")
                        .font(.pretendard(weight: .p5, size: 12))
                        .foregroundStyle(.grey600)
                    Text("총 \(viewModel.festivalModel.festivalSearchResult.count)개")
                        .font(.pretendard(weight: .p5, size: 12))
                        .foregroundStyle(.grey900)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                ForEach(viewModel.festivalModel.festivalSearchResult, id: \.festivalId) { festival in
                    LongSchoolBoxView(
                        thumbnail: festival.thumbnail,
                        schoolName: festival.schoolName,
                        festivalName: festival.festivalName,
                        startDate: formatDate(festival.beginDate),
                        endDate: formatDate(festival.endDate)
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
                
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                        ForEach(viewModel.festivalModel.festivalSearchResult, id: \.festivalId) { festival in
                            SchoolBoxView(
                                isSelected: .constant(false),
                                schoolImageURL: festival.thumbnail,
                                schoolName: festival.schoolName,
                                festivalName: festival.festivalName,
                                startDate: festival.beginDate,
                                endDate: festival.endDate
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .onAppear {
                // 처음 나타날 때는 모든 축제 다 보여주기
                viewModel.festivalModel.festivalSearchResult = viewModel.festivalModel.festivals
                print("festivalSearchResult: \(viewModel.festivalModel.festivalSearchResult)")
            }
            .dynamicTypeSize(.large)
        }
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

// Preview 오류 발생해서 지움
