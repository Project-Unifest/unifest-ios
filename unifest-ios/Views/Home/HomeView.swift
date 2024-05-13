//
//  HomeView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 4/6/24.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var festivalModel: FestivalModel
    @Binding var selectedMonth: Int
    @Binding var selectedDay: Int
    @State private var isIntroViewPresented: Bool = false
    
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
                Text("\(selectedMonth)월 \(selectedDay)일 축제 일정")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.horizontal)
            
            VStack {
                if (festivalModel.isFestival(year: currentYear, month: selectedMonth, day: selectedDay) == 0) {
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
                    // let festList: [FestivalItem] =
                    
                    VStack(spacing: 16) {
                        
                        ForEach(festivalModel.todayFestivals, id: \.self) { festival in
                            let dateOfFest = getFestDate(beginDate: festival.beginDate, month: selectedMonth, day: selectedDay) + 1
                            schoolFestDetailRow(dateText: formatDate(festival.beginDate), name: festival.festivalName, day: dateOfFest, location: festival.schoolName, celebs: festival.starList)
                            
                            Divider()
                                .padding(.trailing)
                        }
                        
                        /* schoolFestDetailRow(dateText: "5/21(월)", name: "녹색지대", day: 1, location: "건국대학교 서울캠퍼스")
                        
                        Divider()
                            .padding(.trailing)
                        
                        schoolFestDetailRow(dateText: "5/21(월)", name: "녹색지대", day: 1, location: "건국대학교 서울캠퍼스")
                        
                        Divider()
                            .padding(.trailing)
                        
                        schoolFestDetailRow(dateText: "5/21(월)", name: "녹색지대", day: 1, location: "건국대학교 서울캠퍼스") */
                    }
                    .padding(.vertical, 20)
                    .padding(.leading)
                    /*.onChange(of: selectedDay) {
                        print("selected Day Updated")
                        updateTodayList()
                    }
                    .onChange(of: selectedMonth) {
                        print("selected Month Updated")
                        updateTodayList()
                    }*/
                }
                
                /* 일단 제거
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
                Text("다가오는 축제 일정")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom, 4)
            
            VStack(spacing: 8) {
                
                ForEach(festivalModel.getFestivalAfter(year: currentYear, month: currentMonth, day: currentDay), id: \.self) { festival in
                    schoolFestRow(image: festival.thumbnail, dateText: formatDate(festival.beginDate) + " ~ " + formatDate(festival.endDate), name: festival.festivalName, school: festival.schoolName)
                }
                
                /* schoolFestRow(image: .konkukLogo, dateText: "5/21(화) ~ 5/23(목)", name: "녹색지대", school: "건국대학교 서울캠퍼스")
                
                schoolFestRow(image: .konkukLogo, dateText: "5/21(화) ~ 5/23(목)", name: "녹색지대", school: "건국대학교 서울캠퍼스")
                
                schoolFestRow(image: .konkukLogo, dateText: "5/21(화) ~ 5/23(목)", name: "녹색지대", school: "건국대학교 서울캠퍼스")
                
                schoolFestRow(image: .konkukLogo, dateText: "5/21(화) ~ 5/23(목)", name: "녹색지대", school: "건국대학교 서울캠퍼스")*/
            }
            .padding(.horizontal)
        }
        .sheet(isPresented: $isIntroViewPresented) {
            IntroView(viewModel: viewModel, festivalModel: festivalModel)
        }
//        .onAppear() {
//            updateTodayList()
//        }
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
    
    /* func updateTodayList() {
        viewModel.isLoading = true
        print(APIManager.shared.serverType.rawValue + "/festival/today?date=2024-\(String(format: "%02d", selectedMonth))-\(String(format: "%02d", selectedDay))")
        var request = URLRequest(url: URL(string: APIManager.shared.serverType.rawValue + "/festival/today?date=2024-\(String(format: "%02d", selectedMonth))-\(String(format: "%02d", selectedDay))")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                if let error = error {
                    print("Error: \(error)")
                } else {
                    print("No data received")
                }
                return
            }

            do {
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponseFestToday.self, from: data)
                
                if let responseData = apiResponse.data {
                    todayFestivalList = responseData
                    viewModel.isLoading = false
                }
            } catch {
                print("Error decoding JSON: \(error)")
                viewModel.isLoading = false
            }
        }

        task.resume()
        
    }*/
    
    @ViewBuilder
    func schoolFestRow(image: String, dateText: String, name: String, school: String) -> some View {
        Image(.schoolFestBox)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .overlay {
                HStack(spacing: 10) {
                    AsyncImage(url: URL(string: image)) { image in
                        image.image?
                            .resizable()
                            .scaledToFit()
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
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(celebs, id: \.self) { star in
                                CelebCircleView(celeb: CelebProfile(name: star.name, imageURL: star.imgUrl))
                            }
                            /* CelebCircleView(celeb: CelebProfile(name: "싸이", imageURL: "https://i.namu.wiki/i/oN3SnBjP-09rtyqk5FZkU4J8ojog4Me4AQXrSHcrFPlirYO3tUFgS_MODwDyawcBqwpzwkQNy_U75S_dVlYt5jJwgONlpXD90lwiEbgJmK2ooij_ktVCXrRp6LHgSrTOAweI-9zkL8gdtU__q9t37MJqBlL8x2TVeHG2QionGik.webp"))
                            
                            CelebCircleView(celeb: CelebProfile(name: "싸이", imageURL: "https://i.namu.wiki/i/1ahRPVQm5CvZEuWX-qAVkCjGpGzfQgGV1EykhbwoQ5DhlQVCMAMBgvDm3uliJMQQcTOxtLkxTQAaITqI8EXlppVK2kXtU_IEZlkVBG648L8FhJ30iT5Sn6KRvWzL5wgZYMO59mNivTOdm6PQ9nJxTkUoeH8Q_R4N17q_wVZSunc.webp"))
                            
                            CelebCircleView(celeb: CelebProfile(name: "싸이", imageURL: "https://i.namu.wiki/i/1ahRPVQm5CvZEuWX-qAVkCjGpGzfQgGV1EykhbwoQ5DhlQVCMAMBgvDm3uliJMQQcTOxtLkxTQAaITqI8EXlppVK2kXtU_IEZlkVBG648L8FhJ30iT5Sn6KRvWzL5wgZYMO59mNivTOdm6PQ9nJxTkUoeH8Q_R4N17q_wVZSunc.webp"))
                            
                            CelebCircleView(celeb: CelebProfile(name: "싸이", imageURL: "https://i.namu.wiki/i/1ahRPVQm5CvZEuWX-qAVkCjGpGzfQgGV1EykhbwoQ5DhlQVCMAMBgvDm3uliJMQQcTOxtLkxTQAaITqI8EXlppVK2kXtU_IEZlkVBG648L8FhJ30iT5Sn6KRvWzL5wgZYMO59mNivTOdm6PQ9nJxTkUoeH8Q_R4N17q_wVZSunc.webp"))
                             */
                        }
                    }
                    .frame(height: 72)
                    .padding(.leading, 40)
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
            return "Invalid Date"
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
    HomeView(viewModel: RootViewModel(), festivalModel: FestivalModel(), selectedMonth: .constant(5), selectedDay: .constant(22), isFest: false)
}

#Preview {
    HomeView(viewModel: RootViewModel(), festivalModel: FestivalModel(), selectedMonth: .constant(5), selectedDay: .constant(22), isFest: true)
}

struct CelebProfile: Codable, Identifiable {
    var id = UUID()
    var name: String
    var imageURL: String
}
