//
//  IntroView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/22/24.
//

import SwiftUI

struct IntroView: View {
    @ObservedObject var viewModel: RootViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State private var likedList: [Int] = []
    @State private var searchText: String = ""
    @State private var count: Int = 0
    // 지역 선택 index
    @State private var regionIndex: Int = 0
    let regions: [String] = ["전체", "서울", "경기∙인천", "강원", "대전∙충청", "광주∙전라", "부산∙대구", "경상"]
    let columns = [GridItem(.adaptive(minimum: 114))]
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                Spacer()
                    .frame(height: 40)
                
                Text(StringLiterals.Intro.infoTitle)
                    .font(.pretendard(weight: .p6, size: 18))
                    .foregroundStyle(.grey900)
                    .padding(.bottom, 4)
                
                Text(StringLiterals.Intro.infoSubtitle)
                    .font(.pretendard(weight: .p5, size: 12))
                    .foregroundStyle(.grey600)
                
                Spacer()
                    .frame(height: 32)
                
                Image(.searchBox)
                    .overlay {
                        HStack {
                            TextField("학교/축제 이름을 검색해보세요", text: $searchText)
                                .font(.system(size: 13))
                                .onChange(of: searchText) { newValue in
                                    viewModel.festivalModel.filterFestivals(byKeyword: searchText)
                                    
                                    if newValue.isEmpty {
                                        regionIndex = 0; // '전체'탭으로 전환
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
                
                Spacer()
                    .frame(height: 5)
                
                HStack {
                    Text(StringLiterals.Intro.myFestivalTitle)
                        .font(.pretendard(weight: .p6, size: 15))
                        .foregroundStyle(.grey900)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text(StringLiterals.Intro.discardAll)
                            .font(.pretendard(weight: .p5, size: 12))
                            .foregroundStyle(.grey600)
                            .underline()
                    }
                }
                .padding(.horizontal)
                
                /* ScrollView(.horizontal, showsIndicators: false) {
                 HStack(spacing: 7) {
                 /* if let festivalData = festivalData {
                  ForEach(festivalData, id: \.self) { festival in
                  if let festivalID = festival.festivalId {
                  if likedFestivalIDData.contains(festivalID) {
                  if let thumbnail = festival.thumbnail, let schoolName = festival.schoolName, let festivalName = festival.festivalName, let beginDate = festival.beginDate, let endDate = festival.endDate {
                  SchoolBoxView(isSelected: .constant(true), schoolImageURL: thumbnail, schoolName: schoolName, festivalName: festivalName, startDate: beginDate, endDate: endDate)
                  .onTapGesture {
                  if let toDeleteIndex = likedFestivalIDData.firstIndex(of: festivalID) {
                  likedFestivalIDData.remove(at: toDeleteIndex)
                  }
                  }
                  }
                  }
                  }
                  }
                  }*/
                 */
                
                Rectangle()
                    .fill(colorScheme == .light ? .grey100 : .grey200)
                    .frame(height: 7)
                    .padding(.top, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(regions.indices, id: \.self) { index in
                            Button {
                                withAnimation(.spring) {
                                    regionIndex = index
                                }
                                viewModel.festivalModel.filterFestivals(byRegion: regions[index])
                            } label: {
                                Text(regions[index])
                                    .font(index == regionIndex ? .pretendard(weight: .p7, size: 14) : .pretendard(weight: .p4, size: 14))
                                    .foregroundStyle(index == regionIndex ? .primary500 : .grey900)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                }
                
                Rectangle()
                    .fill(.grey300)
                    .frame(height: 1)
                
                if viewModel.festivalModel.festivalSearchResult.isEmpty {
                    VStack {
                        Spacer()
                        Text("검색 결과가 없어요")
                            .font(.pretendard(weight: .p4, size: 14))
                            .foregroundStyle(.grey600)
                        Spacer()
                    }
                } else {
                    ScrollView {
                        VStack {
                            HStack {
                                Text("총 \(viewModel.festivalModel.festivalSearchResult.count)개")
                                    .font(.pretendard(weight: .p5, size: 12))
                                    .foregroundStyle(.grey900)
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .padding(.top, 5)

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
                    .padding(.top, -8)
                }
                
            }
            
            Button {
                dismiss()
            } label: {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.primary500)
                    .frame(width: 349, height: 51)
                    .overlay {
                        Text("추가 완료")
                            .font(.pretendard(weight: .p7, size: 14))
                            .foregroundStyle(.white)
                    }
            }
            .padding(.horizontal)
            .padding(.bottom, 7)
        }
        .dynamicTypeSize(.large)
        .background(.ufBackground)
        .onAppear {
            // 처음 나타날 때는 모든 축제 다 보여주기
            viewModel.festivalModel.festivalSearchResult = viewModel.festivalModel.festivals
            print("festivalSearchResult: ", viewModel.festivalModel.festivalSearchResult)
            print("festivals: ",viewModel.festivalModel.festivals)
        }
    }
    
    @ViewBuilder
    func schoolBoxView(for festival: FestivalItem, isSelected: Bool) -> some View {
        Image(isSelected ? .selectedSchoolBoxBackground : .nonselectedSchoolBoxBackground)
            .resizable()
            .scaledToFit()
            .frame(width: 113, height: 121)
            .overlay {
                VStack {
                    AsyncImage(url: URL(string: festival.thumbnail)) { image in
                        image.image?
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .padding(.bottom, 4)
                    }
                    
                    Text(festival.schoolName)
                        .font(.system(size: 13))
                    
                    Text(festival.festivalName)
                        .font(.system(size: 12))
                        .bold()
                    
                    Text(formattedDate(from: festival.beginDate) + "-" + formattedDate(from: festival.endDate))
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
            }
    }
    
    func formattedDate(from dateString: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MM.dd"
        
        if let date = dateFormatterGet.date(from: dateString) {
            return dateFormatterPrint.string(from: date)
        } else {
            return "Error formatting date"
        }
    }
}

#Preview {
    IntroView(viewModel: RootViewModel())
}
