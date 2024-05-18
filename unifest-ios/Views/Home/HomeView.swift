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
    @State private var isLoading1: Bool = true
    @State private var isLoading2: Bool = true
    @State private var upcomingList: [FestivalItem] = []
    
    // @State private var todayFestivalList: [TodayFestivalItem] = []
    
    let isFest: Bool
    
    var currentDate: Date {
        return Date()
    }
    
    var currentYear: Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        return year
    }
    
    // 현재 월을 가져오는 computed property
    var currentMonth: Int {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: currentDate)
        return month
    }
    
    // 현재 일을 가져오는 computed property
    var currentDay: Int {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: currentDate)
        return day
    }
    
    var body: some View {
        ScrollView {
            Spacer()
                .frame(height: 20)
            
            HStack {
                Text("\(selectedMonth)월 \(selectedDay)일 " + StringLiterals.Home.festivalTitle)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.horizontal)
            
            VStack {
                if (viewModel.festivalModel.isFestival(year: currentYear, month: selectedMonth, day: selectedDay) == 0) {
                    VStack(alignment: .center, spacing: 9) {
                        Spacer()
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 26))
                            .foregroundStyle(.black)
                        
                        Text(StringLiterals.Home.noFestivalTitle)
                            .font(.system(size: 16))
                            .foregroundStyle(.black)
                            .fontWeight(.semibold)
                        
                        Text(StringLiterals.Home.noFestivalMessage)
                            .font(.system(size: 12))
                            .foregroundStyle(.gray)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .frame(height: 360)
                } else {
                    if !viewModel.festivalModel.todayFestivals.isEmpty {
                        VStack(spacing: 16) {
                            
                            ForEach(viewModel.festivalModel.todayFestivals, id: \.self) { festival in
                                let dateOfFest = getFestDate(beginDate: festival.beginDate, month: selectedMonth, day: selectedDay) + 1
                                schoolFestDetailRow(dateText: formatDate(festival.beginDate), name: festival.festivalName, day: dateOfFest, location: festival.schoolName, celebs: festival.starList)
                                
                                Divider()
                                    .padding(.trailing)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.leading)
                    } else {
                        VStack {
                            ProgressView()
                        }
                        .frame(height: 100)
                    }
                }
                
                /*
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
                .padding(.horizontal)*/
            }
            
            Image(.boldLine)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            
            HStack {
                Text(StringLiterals.Home.upcomingFestivalTitle)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
            
            VStack(spacing: 8) {
                if viewModel.festivalModel.getFestivalAfter(year: currentYear, month: currentMonth, day: currentDay).isEmpty {
                    VStack(alignment: .center) {
                        Text(StringLiterals.Home.noUpcomingFestivalTitle)
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(.defaultBlack)
                            .padding(.bottom, 1)
                        
                        Text(StringLiterals.Home.noUpcomingFestivalMessage)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                            .padding(.bottom, 10)
                    }
                    .frame(height: 240)
                } else {
                    ForEach(viewModel.festivalModel.getFestivalAfter(year: currentYear, month: currentMonth, day: currentDay), id: \.self) { festival in
                        schoolFestRow(image: festival.thumbnail, dateText: formatDate(festival.beginDate) + " ~ " + formatDate(festival.endDate), name: festival.festivalName, school: festival.schoolName)
                    }
                }
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $isIntroViewPresented) {
            IntroView(viewModel: viewModel)
        }
    }
    
    func getFestDate(beginDate: String, month: Int, day: Int) -> Int {
        // Create a DateFormatter instance
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Convert beginDate string to a Date object
        guard let startDate = dateFormatter.date(from: beginDate) else {
            return 0 // Return 0 if unable to parse beginDate
        }
        
        // Create a Date object for the given month and day
        var dateComponents = DateComponents()
        dateComponents.year = Calendar.current.component(.year, from: startDate)
        dateComponents.month = month
        dateComponents.day = day
        guard let targetDate = Calendar.current.date(from: dateComponents) else {
            return 0 // Return 0 if unable to create targetDate
        }
        
        // Calculate the difference in days
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.day], from: startDate, to: targetDate)
        return difference.day ?? 0
    }
    
    @ViewBuilder
    func schoolFestRow(image: String, dateText: String, name: String, school: String) -> some View {
        Image(.schoolFestBox)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .overlay {
                HStack(spacing: 10) {
                    AsyncImage(url: URL(string: image)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 52, height: 52)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 52, height: 52)
                    }
                    
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
    func schoolFestDetailRow(dateText: String, name: String, day: Int, location: String, celebs: [StarItem]?=nil) -> some View {
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
                
                if let celebs = celebs {
                    ZStack(alignment: .leading) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                Spacer()
                                    .frame(width: 30)
                                
                                ForEach(celebs, id: \.self) { star in
                                    CelebCircleView(celeb: CelebProfile(name: star.name, imageURL: star.imgUrl))
                                }
                            }
                        }
                        .frame(height: 72)
                        // .border(.red)
                        
                        Image(.leftRowOverlay)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 72)
                    }
                    .frame(height: 72)
                    // .border(.green)
                }
            }
            .frame(height: 72)
            
            /* 일단 제거
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
            .padding(.top, 6)*/
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
        
        // Get the day of the week
        let weekday = Calendar.current.component(.weekday, from: date)
        let weekdays = ["", "일", "월", "화", "수", "목", "금", "토"]
        
        return "\(month)/\(day)(\(weekdays[weekday]))"
    }
}

struct CelebCircleView: View {
    let celeb: CelebProfile
    @State private var isTouched: Bool = false
    @State private var loadFailed: Bool = false
    
    var body: some View {
        ZStack {
            /* AsyncImage(url: URL(string: celeb.imageURL)) { image in
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
            }*/
            AsyncImage(url: URL(string: celeb.imageURL)) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Circle()
                            .fill(.lightGray)
                            .frame(width: 72, height: 72)
                            // .shadow(color: .black.opacity(0.1), radius: 6.67, x: 0, y: 1)
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }
                    .frame(width: 72, height: 72)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                        // .shadow(color: .black.opacity(0.1), radius: 6.67, x: 0, y: 1)
                case .failure(let error):
                    ZStack(alignment: .center) {
                        Circle()
                            .fill(.lightGray)
                            .frame(width: 72, height: 72)
                            // .shadow(color: .black.opacity(0.1), radius: 6.67, x: 0, y: 1)
                        
                        MarqueeText(text: celeb.name, font: .systemFont(ofSize: 13), leftFade: 10, rightFade: 10, startDelay: 0, alignment: .center)
                            .frame(width: 50)
                        // Text(celeb.name)
                            // .font(.system(size: 13))
                            .fontWeight(.medium)
                            .foregroundStyle(.defaultBlack)
                            // .multilineTextAlignment(.center)
                            
                    }
                    .frame(width: 72)
                    .onAppear {
                        loadFailed = true
                    }
                }
            }
            .onTapGesture {
                if !loadFailed {
                    if !isTouched {
                        GATracking.sendLogEvent(GATracking.LogEventType.HomeView.HOME_CLICK_CELEB_PROFILE, params: ["celebName": celeb.name])
                        
                        withAnimation {
                            isTouched = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                self.isTouched = false
                            }
                        }
                    }
                }
            }
            
            if isTouched {
                Circle()
                    .fill(.black.opacity(0.5))
                    .overlay {
                        MarqueeText(text: celeb.name, font: .systemFont(ofSize: 13), leftFade: 10, rightFade: 10, startDelay: 0, alignment: .center)
                        // Text(celeb.name)
                            // .font(.system(size: 13))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            // .multilineTextAlignment(.center)
                    }
            }
        }
        .frame(width: 72, height: 72)
    }
}

#Preview {
    RootView(rootViewModel: RootViewModel())
}

struct CelebProfile: Codable, Identifiable {
    var id = UUID()
    var name: String
    var imageURL: String
}
