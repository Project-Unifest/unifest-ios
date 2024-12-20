//
//  SearchSchoolView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/24/24.
//

import SwiftUI

// MapPageHeaderView에서 학교이름을 탭했을 떄 나타나는 뷰
// 검색을 하지 않았을 때는 '나의 관심축제' 뷰 <- SchoolBoxView
// 검색을 했을 때는 '검색 결과' 뷰가 보이게 만듦 <- LongSchoolBoxView

struct SearchSchoolView: View {
    @State private var searchText: String = ""
    let columns = [GridItem(.adaptive(minimum: 114))]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                    .frame(height: 30)
                
                // 학교/축제 데이터는 FestivalModel의 이니셜라이저에서 앱이 처음 실행될 때 저장됨
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
                
                VStack(spacing: 10) {
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
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                        SchoolBoxView(isSelected: .constant(false), schoolImageURL: "https://i.namu.wiki/i/frJ2JwLkp_Ts8Le-AVmISJdC2wkhYUte4N5YZ0j-nB_aT_CagQLTOjNDeXMW_kFBeXIe5-pAXDE4CGNVGJ5FMGuS1HUqUTYGfL3AUVJBzum3Ppq5wIUej0v10WuSuOWDT2KIEQwKqA4qiWm3EzS123Uj1gyShvzqaaScOgNsnPg.svg", schoolName: "건국대 서울캠", festivalName: "녹색지대", startDate: "2024-06-24", endDate: "2024-06-27" )
                        SchoolBoxView(isSelected: .constant(false), schoolImageURL: "https://i.namu.wiki/i/frJ2JwLkp_Ts8Le-AVmISOJycKA-weZiZnZjURRWrVUG1b_6EwEV_XC-T4m0L4tkaLMTrYTt-rg9NsoFAvLcaensvvbxtHJniiJ1ozZQASIXrFBKslQibGRszyoIcpf3Amebt_bZ5rNEYbYSQfkbq21wvQuDNQ5jTqtP1RO3V1g.svg", schoolName: "홍익대 서울캠", festivalName: "녹색지대", startDate: "2024-05-20", endDate: "2024-05-24")
                        SchoolBoxView(isSelected: .constant(false), schoolImageURL: "https://i.namu.wiki/i/frJ2JwLkp_Ts8Le-AVmISFfwnU-dlgVpQbZ03CrSG0G0U1cfjhp8ygrXEpeJ_s7b0p6hOl8NgkZyZBV-0dSGl1pKcPaPxpTXHqETtFYKDL_QG8Pu1Qa5-79V0ks6ABzw0eOMDa68Hfpunt1HWPZ17GlqMo8zFONfTmVx7HJGfa4.webp", schoolName: "서울대 관악캠", festivalName: "녹색지대", startDate: "2024-06-01", endDate: "2024-06-04")
                        /* SchoolBoxView(isSelected: .constant(false), schoolImage: .snutLogo, schoolName: "서울과기대", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )
                         SchoolBoxView(isSelected: .constant(false), schoolImage: .uosLogo, schoolName: "서울시립대", festivalName: "녹색지대", startDate: "05.06.", endDate: "05.08." )*/
                    }
                    .padding(.horizontal)
                }
            }
        }
        .dynamicTypeSize(.large)
    }
}

#Preview {
    Text("")
        .sheet(isPresented: .constant(true)) {
            SearchSchoolView()
                .presentationDragIndicator(.visible)
        }
}
