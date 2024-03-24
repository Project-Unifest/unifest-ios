//
//  IntroView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/22/24.
//

import SwiftUI

struct IntroView: View {
    @State private var searchText: String = ""
    
    // 지역 선택 index
    @State private var regionIndex: Int = 0
    let regions: [String] = ["전체", "서울", "경기/인천", "강원", "대전/충청", "광주/전라", "부산"]
    
    let columns = [GridItem(.adaptive(minimum: 114))]
    
    var body: some View {
        VStack(alignment: .center) {
<<<<<<< Updated upstream
            
            Spacer()
                .frame(height: 78)
            
            Text(StringLiterals.Intro.infoTitle)
                .font(.system(size: 18))
                .bold()
                .padding(.bottom, 4)
            
            Text(StringLiterals.Intro.infoSubtitle)
                .font(.system(size: 12))
                .foregroundStyle(.gray)
            
            Spacer()
                .frame(height: 52)
            
            Image(.searchBox)
                .overlay {
                    HStack {
                        TextField(StringLiterals.Intro.searchPlaceholder, text: $searchText)
                            .font(.system(size: 13))
                        Image(.searchIcon)
                    }
                    .padding(.horizontal, 15)
                }
            
            Spacer()
                .frame(height: 18)
            
            HStack {
                Text(StringLiterals.Intro.myFestivalTitle)
                    .font(.system(size: 15))
                    .bold()
                
                Spacer()
                
                Text(StringLiterals.Intro.discardAll)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                    .underline()
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 7) {
                    SchoolBoxView(isSelected: .constant(true), schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                    SchoolBoxView(isSelected: .constant(true), schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                    SchoolBoxView(isSelected: .constant(true), schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                    SchoolBoxView(isSelected: .constant(true), schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                    SchoolBoxView(isSelected: .constant(true), schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                }
                .padding(.horizontal)
            }
            
            HStack {
                Spacer()
                    .frame(width: .infinity, height: 7)
            }
            .background(.lightGray)
            .frame(width: .infinity, height: 7)
            .padding(.top, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(0..<7) { index in
                        Button {
                            withAnimation(.spring) {
                                regionIndex = index
                            }
                        } label: {
                            Text(regions[index])
                                .font(.system(size: 14))
                                .foregroundStyle(index == regionIndex ? .defaultBlack : .gray)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical, 10)
            
            Divider()
                .frame(width: .infinity)
                .foregroundStyle(.lightGray)
            
            HStack {
                Text(StringLiterals.Intro.number)
                    .font(.system(size: 12))
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
            
            ScrollView {
                LazyVGrid(columns: columns) {
                    SchoolBoxView(isSelected: .constant(true), schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                    SchoolBoxView(isSelected: .constant(true), schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                    SchoolBoxView(isSelected: .constant(true), schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                    SchoolBoxView(isSelected: .constant(true), schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                    SchoolBoxView(isSelected: .constant(true), schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
=======
            ScrollView {
                Spacer()
                    .frame(height: 78)
                
                Text(StringLiterals.Intro.infoTitle)
                    .font(.system(size: 18))
                    .bold()
                    .padding(.bottom, 4)
                
                Text(StringLiterals.Intro.infoSubtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                
                Spacer()
                    .frame(height: 52)
                
                Image(.searchBox)
                    .overlay {
                        HStack {
                            TextField(StringLiterals.Intro.searchPlaceholder, text: $searchText)
                                .font(.system(size: 13))
                            Image(.searchIcon)
                        }
                        .padding(.horizontal, 15)
                    }
                
                Spacer()
                    .frame(height: 18)
                
                HStack {
                    Text(StringLiterals.Intro.myFestivalTitle)
                        .font(.system(size: 15))
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Text(StringLiterals.Intro.discardAll)
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                            .underline()
                    }
                }
                .padding(.horizontal)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 7) {
                        SchoolBoxView(isSelected: .constant(true), schoolImage: .konkukLogo, schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                        SchoolBoxView(isSelected: .constant(true), schoolImage: .hongikLogo, schoolName: "홍익대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                        SchoolBoxView(isSelected: .constant(true), schoolImage: .chungangLogo, schoolName: "중앙대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                        SchoolBoxView(isSelected: .constant(true), schoolImage: .snutLogo, schoolName: "서울과기대", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                        SchoolBoxView(isSelected: .constant(true), schoolImage: .uosLogo, schoolName: "서울시립대", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    Spacer()
                        .frame(width: .infinity, height: 7)
                }
                .background(.lightGray)
                .frame(width: .infinity, height: 7)
                .padding(.top, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(0..<7) { index in
                            Button {
                                withAnimation(.spring) {
                                    regionIndex = index
                                }
                            } label: {
                                Text(regions[index])
                                    .font(.system(size: 14))
                                    .foregroundStyle(index == regionIndex ? .defaultBlack : .gray)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                
                Divider()
                    .frame(width: .infinity)
                    .foregroundStyle(.lightGray)
                
                HStack {
                    Text(StringLiterals.Intro.number)
                        .font(.system(size: 12))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                
                ScrollView {
                    LazyVGrid(columns: columns) {
                        SchoolBoxView(isSelected: .constant(false), schoolImage: .konkukLogo, schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                        SchoolBoxView(isSelected: .constant(false), schoolImage: .hongikLogo, schoolName: "홍익대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                        SchoolBoxView(isSelected: .constant(false), schoolImage: .chungangLogo, schoolName: "중앙대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                        SchoolBoxView(isSelected: .constant(false), schoolImage: .snutLogo, schoolName: "서울과기대", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                        SchoolBoxView(isSelected: .constant(false), schoolImage: .uosLogo, schoolName: "서울시립대", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                    }
                    .padding(.horizontal)
                }
            }
            
>>>>>>> Stashed changes
            Button {
                
            } label: {
                Image(.longButtonBlack)
                    .resizable()
                    .scaledToFit()
                    .frame(width: .infinity)
                    .overlay {
                        Text(StringLiterals.Intro.complete)
                            .font(.system(size: 17))
                            .bold()
                            .foregroundStyle(.white)
                    }
            }
            .padding(.horizontal)
        }
    }
}

struct SchoolBoxView: View {
    @Binding var isSelected: Bool
<<<<<<< Updated upstream
=======
    let schoolImage: ImageResource
>>>>>>> Stashed changes
    let schoolName: String
    let festivalName: String
    let startDate: String
    let endDate: String
    
    var body: some View {
        Image(isSelected ? .selectedSchoolBoxBackground : .nonselectedSchoolBoxBackground)
            .resizable()
            .scaledToFit()
            .frame(width: 113, height: 121)
            .overlay {
                VStack {
<<<<<<< Updated upstream
                    Image(.konkukLogo)
=======
                    Image(schoolImage)
>>>>>>> Stashed changes
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .padding(.bottom, 8)
                    
                    Text(schoolName)
                        .font(.system(size: 13))
                    
                    Text(festivalName)
                        .font(.system(size: 12))
                        .bold()
                    
                    Text(startDate + "-" + endDate)
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
            }
    }
}

#Preview {
    IntroView()
}

#Preview {
<<<<<<< Updated upstream
    SchoolBoxView(isSelected: .constant(true), schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
=======
    SchoolBoxView(isSelected: .constant(true), schoolImage: .konkukLogo, schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
>>>>>>> Stashed changes
}
