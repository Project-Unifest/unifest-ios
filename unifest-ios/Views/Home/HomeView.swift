//
//  HomeView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 4/6/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: RootViewModel
    @Binding var selectedMonth: Int
    @Binding var selectedDay: Int
    @State private var isIntroViewPresented: Bool = false
    
    let isFest: Bool
    
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 20)
            
            HStack {
                Text("\(selectedMonth)월 \(selectedDay)일 축제 일정")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.horizontal)
            
            VStack {
                if !isFest {
                    VStack(alignment: .center, spacing: 9) {
                        Spacer()
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 26))
                            .foregroundStyle(.black)
                        
                        Text("축제 일정 없음")
                            .font(.system(size: 18))
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                        
                        Text("오늘은 축제가 열리는 학교가 없어요")
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(height: 360)
                } else {
                    VStack(spacing: 16) {
                        schoolFestDetailRow(dateText: "5/21(월)", name: "녹색지대", day: 1, location: "건국대학교 서울캠퍼스")
                        
                        Divider()
                            .padding(.trailing)
                        
                        schoolFestDetailRow(dateText: "5/21(월)", name: "녹색지대", day: 1, location: "건국대학교 서울캠퍼스")
                        
                        Divider()
                            .padding(.trailing)
                        
                        schoolFestDetailRow(dateText: "5/21(월)", name: "녹색지대", day: 1, location: "건국대학교 서울캠퍼스")
                    }
                    .padding(.vertical, 20)
                    .padding(.leading)
                }
                
                Button {
                    isIntroViewPresented.toggle()
                } label: {
                    Image(.longButtonGray)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Text("관심 축제 추가하기")
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                                .foregroundStyle(.gray)
                        }
                }
                .padding(.horizontal)
            }
            
            Image(.boldLine)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            
            HStack {
                Text("다가오는 축제 일정")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
            
            VStack(spacing: 8) {
                schoolFestRow(image: .konkukLogo, dateText: "5/21(화) ~ 5/23(목)", name: "녹색지대", school: "건국대학교 서울캠퍼스")
                
                schoolFestRow(image: .konkukLogo, dateText: "5/21(화) ~ 5/23(목)", name: "녹색지대", school: "건국대학교 서울캠퍼스")
                
                schoolFestRow(image: .konkukLogo, dateText: "5/21(화) ~ 5/23(목)", name: "녹색지대", school: "건국대학교 서울캠퍼스")
                
                schoolFestRow(image: .konkukLogo, dateText: "5/21(화) ~ 5/23(목)", name: "녹색지대", school: "건국대학교 서울캠퍼스")
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $isIntroViewPresented) {
            IntroView(viewModel: viewModel)
        }
    }
    
    @ViewBuilder
    func schoolFestRow(image: ImageResource, dateText: String, name: String, school: String) -> some View {
        Image(.schoolFestBox)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .overlay {
                HStack(spacing: 10) {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(dateText)
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                        Text(name)
                            .font(.system(size: 12))
                            .bold()
                            .foregroundStyle(.black)
                        HStack(spacing: 5) {
                            Image(.blackMarker)
                            Text(school)
                                .font(.system(size: 12))
                                .fontWeight(.medium)
                                .foregroundStyle(.gray)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
    }
    
    @ViewBuilder
    func schoolFestDetailRow(dateText: String, name: String, day: Int, location: String, celebs: [CelebProfile]?=nil) -> some View {
        VStack {
            HStack {
                Image(.verticalBar)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 72)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(dateText)
                        .bold()
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 5)
                    
                    Text(name + " DAY \(day)")
                        .font(.system(size: 18))
                        .foregroundStyle(.black)
                        .fontWeight(.semibold)
                        .padding(.bottom, 11)
                    
                    HStack(spacing: 5) {
                        Image(.blackMarker)
                        Text(location)
                            .font(.system(size: 11))
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                    }
                }
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        CelebCircleView(celeb: CelebProfile(name: "싸이", imageURL: "https://i.namu.wiki/i/oN3SnBjP-09rtyqk5FZkU4J8ojog4Me4AQXrSHcrFPlirYO3tUFgS_MODwDyawcBqwpzwkQNy_U75S_dVlYt5jJwgONlpXD90lwiEbgJmK2ooij_ktVCXrRp6LHgSrTOAweI-9zkL8gdtU__q9t37MJqBlL8x2TVeHG2QionGik.webp"))
                        
                        CelebCircleView(celeb: CelebProfile(name: "싸이", imageURL: "https://i.namu.wiki/i/1ahRPVQm5CvZEuWX-qAVkCjGpGzfQgGV1EykhbwoQ5DhlQVCMAMBgvDm3uliJMQQcTOxtLkxTQAaITqI8EXlppVK2kXtU_IEZlkVBG648L8FhJ30iT5Sn6KRvWzL5wgZYMO59mNivTOdm6PQ9nJxTkUoeH8Q_R4N17q_wVZSunc.webp"))
                        
                        CelebCircleView(celeb: CelebProfile(name: "싸이", imageURL: "https://i.namu.wiki/i/1ahRPVQm5CvZEuWX-qAVkCjGpGzfQgGV1EykhbwoQ5DhlQVCMAMBgvDm3uliJMQQcTOxtLkxTQAaITqI8EXlppVK2kXtU_IEZlkVBG648L8FhJ30iT5Sn6KRvWzL5wgZYMO59mNivTOdm6PQ9nJxTkUoeH8Q_R4N17q_wVZSunc.webp"))
                        
                        CelebCircleView(celeb: CelebProfile(name: "싸이", imageURL: "https://i.namu.wiki/i/1ahRPVQm5CvZEuWX-qAVkCjGpGzfQgGV1EykhbwoQ5DhlQVCMAMBgvDm3uliJMQQcTOxtLkxTQAaITqI8EXlppVK2kXtU_IEZlkVBG648L8FhJ30iT5Sn6KRvWzL5wgZYMO59mNivTOdm6PQ9nJxTkUoeH8Q_R4N17q_wVZSunc.webp"))
                    }
                }
                .frame(height: 72)
                .padding(.leading, 40)
            }
            .frame(height: 72)
            
            Button {
                
            } label: {
                Image(.narrowLongButtonPink)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .overlay {
                        Text("관심 축제로 추가")
                            .font(.system(size: 13))
                            .foregroundStyle(.accent)
                            .fontWeight(.medium)
                    }
            }
            .padding(.trailing)
            .padding(.top, 6)
        }
    }
}

struct CelebCircleView: View {
    let celeb: CelebProfile
    @State private var isTouched: Bool = false
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: celeb.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 6.67, x: 0, y: 1)
            } placeholder: {
                ZStack {
                    Circle()
                        .fill(.lightGray)
                        .frame(width: 72, height: 72)
                        .shadow(color: .black.opacity(0.1), radius: 6.67, x: 0, y: 1)
                    ProgressView()
                        .frame(maxWidth: .infinity)
                }
                .frame(width: 72, height: 72)
            }
            .onTapGesture {
                if !isTouched {
                    withAnimation {
                        isTouched = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.isTouched = false
                    }
                }
            }
            
            if isTouched {
                Circle()
                    .fill(.black.opacity(0.5))
                    .overlay {
                        Text(celeb.name)
                            .font(.system(size: 14))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                    }
            }
        }
        .frame(width: 72, height: 72)
    }
}

#Preview {
    HomeView(viewModel: RootViewModel(), selectedMonth: .constant(5), selectedDay: .constant(1), isFest: false)
}

#Preview {
    HomeView(viewModel: RootViewModel(), selectedMonth: .constant(5), selectedDay: .constant(1), isFest: true)
}

struct CelebProfile: Codable, Identifiable {
    var id = UUID()
    var name: String
    var imageURL: String
}
