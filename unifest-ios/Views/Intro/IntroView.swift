//
//  IntroView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/22/24.
//

import SwiftUI

struct IntroView: View {
    @ObservedObject var viewModel: RootViewModel
    @State private var likedList: [Int] = []
    @State private var searchText: String = ""
    @State private var count: Int = 0
    
    // 지역 선택 index
    @State private var regionIndex: Int = 0
    let regions: [String] = ["전체", "서울", "경기∙인천", "강원", "대전∙충청", "광주∙전라", "부산∙대구", "경상"]
    
    let columns = [GridItem(.adaptive(minimum: 114))]
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView {
                Spacer()
                    .frame(height: 78)
                
                Text(StringLiterals.Intro.infoTitle)
                    .font(.pretendard(weight: .p6, size: 18))
                    .foregroundStyle(.grey900)
                    .padding(.bottom, 4)
                
                Text(StringLiterals.Intro.infoSubtitle)
                    .font(.pretendard(weight: .p5, size: 12))
                    .foregroundStyle(.grey600)
                
                Spacer()
                    .frame(height: 52)
                
                Image(.searchBox)
                    .overlay {
                        HStack {
                            TextField(StringLiterals.Intro.searchPlaceholder, text: $searchText)
                                .font(.pretendard(weight: .p5, size: 13))
                                .foregroundStyle(.grey400)
                            Image(.searchIcon)
                        }
                        .padding(.horizontal, 15)
                    }
                
                Spacer()
                    .frame(height: 18)
                
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
                 /* SchoolBoxView(isSelected: .constant(true), schoolImage: , schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                  SchoolBoxView(isSelected: .constant(true), schoolImage: .hongikLogo, schoolName: "홍익대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                  SchoolBoxView(isSelected: .constant(true), schoolImage: .chungangLogo, schoolName: "중앙대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                  SchoolBoxView(isSelected: .constant(true), schoolImage: .snutLogo, schoolName: "서울과기대", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                  SchoolBoxView(isSelected: .constant(true), schoolImage: .uosLogo, schoolName: "서울시립대", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )*/
                 }
                 .padding(.horizontal)
                 }*/
                
                HStack {
                    Spacer()
                        .frame(width: .infinity, height: 7)
                }
                .background(.grey100)
                .frame(width: .infinity, height: 7)
                .padding(.top, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0 ..< 7) { index in
                            Button {
                                withAnimation(.spring) {
                                    regionIndex = index
                                }
                            } label: {
                                Text(regions[index])
                                    .font(index == regionIndex ? .pretendard(weight: .p7, size: 14) : .pretendard(weight: .p4, size: 14))
                                    .foregroundStyle(index == regionIndex ? .primary500 : .grey900)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                
                Divider()
                    .frame(height: 1.5)
                    .background(.grey100)
                
                HStack {
                    // Text("총 \(viewModel.festivalModel.festivals.count)개")
                    //     .font(.system(size: 12))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                ScrollView {
                    LazyVGrid(columns: columns) {
                        //                        ForEach(viewModel.festivalModel.festivals.filter { $0.region! == regions[regionIndex] }, id: \.self) { festival in
                        //                            SchoolBoxView(isSelected: .constant(false), schoolImageURL: festival.thumbnail, schoolName: festival.schoolName, festivalName: festival.festivalName, startDate: festival.beginDate, endDate: festival.endDate)
                        //                        }
                        /* ForEach(viewModel.festivalModel.festivals.filter { $0.region == regions[regionIndex] }) { festival in
                         // SchoolBoxView(isSelected: .constant(false), schoolImageURL: festival.thumbnail, schoolName: festival.schoolName, festivalName: festival.festivalName, startDate: festival.beginDate, endDate: festival.endDate)
                         } */
                        // let festivalList = viewModel.festivalModel.festivals.filter{ $0.region! == regions[regionIndex] }
                        let festivalList: [FestivalItem] = viewModel.festivalModel.festivals
                        
                        /*  if (regionIndex > 0) {
                         festivalList = festivalList.filter { $0.region == "서울" }
                         }*/
                        
                        /* ForEach(festivalList, id: \.self) { festival in
                         if (regionIndex == 0 || festival.region == regions[regionIndex]) {
                         Image(.nonselectedSchoolBoxBackground)
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
                         }*/
                    }
                    .padding(.horizontal)
                }
            }
            
            Button {
                viewModel.transtion(to: .home)
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
        }
        .dynamicTypeSize(.large)
        .background(.ufBackground)
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
