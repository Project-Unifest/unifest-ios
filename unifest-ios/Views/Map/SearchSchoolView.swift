//
//  SearchSchoolView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/24/24.
//

import SwiftUI

struct SearchSchoolView: View {
    @State private var searchText: String = ""
    let columns = [GridItem(.adaptive(minimum: 114))]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 30)
            
            Image(.searchBox)
                .overlay {
                    HStack {
                        TextField("학교/축제 이름을 검색해보세요", text: $searchText)
                            .font(.system(size: 13))
                        Image(.searchIcon)
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.bottom)
            
            HStack {
                Text("검색결과")
                    .font(.system(size: 12))
                    .foregroundStyle(.gray)
                Text("총 2개")
                    .font(.system(size: 12))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            VStack(spacing: 6) {
                LongSchoolBoxView(schoolName: "건국대학교", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08.")
                LongSchoolBoxView(schoolName: "건국대학교", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08.")
            }
            .padding(.horizontal, 15)
            .padding(.bottom, 6)
            
            Image(.boldLine)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
            
            HStack {
                Text("나의 관심 축제")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
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
    }
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true)) {
            SearchSchoolView()
                .presentationDragIndicator(.visible)
        }
}

struct LongSchoolBoxView: View {
    let schoolName: String
    let festivalName: String
    let startDate: String
    let endDate: String
    
    var body: some View {
        HStack {
            Image(.konkukLogo)
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 52)
                .padding(.trailing, 4)
            
            VStack(alignment: .leading) {
                Text(schoolName)
                    .font(.system(size: 13))
                
                Text(festivalName)
                    .font(.system(size: 12))
                    .bold()
                
                Text(startDate + "-" + endDate)
                    .font(.system(size: 12))
            }
            
            Spacer()
        }
    }
}

#Preview {
    LongSchoolBoxView(schoolName: "건국대학교", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08.")
}
