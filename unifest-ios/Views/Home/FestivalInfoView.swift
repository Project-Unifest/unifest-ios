//
//  HomeView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 4/6/24.
//

import SwiftUI

// HomeView에서 O월O일 축제 일정, 다가오는 축제 일정 있는 이 뷰가 FestivalInfoView
struct FestivalInfoView: View {
    
    @ObservedObject var viewModel: RootViewModel
    @StateObject private var festivalInfoViewModel = FestivalInfoViewModel()
    
    @Binding var selectedMonth: Int
    @Binding var selectedDay: Int
    @Binding var showNoticeImage: Bool
    @Binding var selectedNoticeImage: String?
    
    @State private var upcomingList: [FestivalItem] = []
    @State private var maxLength: Int = 5
    
    var currentDate: Date {
        return Date()
    }
    var currentYear: Int {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        return year
    }
    var currentMonth: Int {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: currentDate)
        return month
    }
    var currentDay: Int {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: currentDate)
        return day
    }
    
    var body: some View {
        ScrollView {
            infoHeaderView
            
            if viewModel.festivalModel.isFestival(year: currentYear, month: selectedMonth, day: selectedDay) == 0 {
                emptyView
            } else {
                if !viewModel.festivalModel.todayFestivals.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(viewModel.festivalModel.todayFestivals, id: \.self) { festival in
                            let dateOfFest = getFestDate(beginDate: festival.beginDate, month: selectedMonth, day: selectedDay) + 1
                            schoolFestDetailRow(name: festival.festivalName, day: dateOfFest, location: festival.schoolName, celebs: festival.starList)
                        }
                        .padding(.bottom, 24)
                        .padding(.leading)
                        
                        tipView
                            .padding(.horizontal, 20)
                            .padding(.bottom, 35)
                        
                        festivalNoticeView
                    }
                } else {
                    VStack {
                        ProgressView()
                    }
                    .frame(height: 100)
                }
            }
        }
        .background(.ufBackground)
    }
}

// MARK: - Components

private extension FestivalInfoView {
    
    var infoHeaderView: some View {
        HStack {
            Text("\(selectedMonth)월 \(selectedDay)일 " + StringLiterals.Home.festivalSchedule)
                .font(.pretendard(weight: .p6, size: 15))
                .foregroundStyle(.grey900)
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
    }
    
    var emptyView: some View {
        VStack(alignment: .center, spacing: 9) {
            Spacer()
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 26))
                .foregroundStyle(.defaultBlack)
            
            Text(StringLiterals.Home.noFestivalSchedule)
                .font(.system(size: 16))
                .foregroundStyle(.defaultBlack)
                .fontWeight(.semibold)
            
            Text(StringLiterals.Home.noFestivalMessage)
                .font(.system(size: 12))
                .foregroundStyle(.gray)
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(height: 360)
    }
    
    var tipView: some View {
        HStack(spacing: 12) {
            Text("Tip!")
                .font(.pretendard(weight: .p6, size: 15))
                .foregroundColor(.primary500)
            
            TabView {
                ForEach(festivalInfoViewModel.homeTipList.map { $0.tipContent }, id: \.self) { tipText in
                    Text(tipText)
                        .font(.pretendard(weight: .p5, size: 14))
                        .foregroundStyle(.grey800)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .multilineTextAlignment(.leading)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            Spacer()
        }
        .padding(.leading, 16)
        .padding(.vertical, 13)
        .background(
            RoundedRectangle(cornerRadius: 7)
                .fill(.grey100)
        )
    }
    
    var festivalNoticeView: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 7) {
                Text("가천대 축제 소식")
                    .font(.pretendard(weight: .p6, size: 18))
                    .foregroundStyle(.grey900)
                
                Text("가천대 축제 소식 및 정보를 카드뉴스로 확인해보세요")
                    .font(.pretendard(weight: .p5, size: 14))
                    .foregroundStyle(.grey700)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible(minimum: 204))], spacing: 8) {
                    ForEach(festivalInfoViewModel.homeCardList, id: \.self) { homeCard in
                        AsyncImage(url: URL(string: homeCard.thumbnailImgUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 204, height: 204)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .onTapGesture {
                            selectedNoticeImage = homeCard.detailImgUrl
                            showNoticeImage = true
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - Method

private extension FestivalInfoView {
    
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
        Text("")
            .roundedButton(background: .defaultWhite, strokeColor: .defaultLightGray, height: 92, cornerRadius: 10)
        // Image(.schoolFestBox)
        // .resizable()
        // .scaledToFit()
        // .frame(maxWidth: .infinity)
            .overlay {
                HStack(spacing: 10) {
                    /* AsyncImage(url: URL(string: image)) { image in
                     image
                     .resizable()
                     .scaledToFit()
                     .frame(width: 52, height: 52)
                     } placeholder: {
                     ProgressView()
                     .frame(width: 52, height: 52)
                     }*/
                    AsyncImage(url: URL(string: image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 60, height: 60)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .cornerRadius(10)
                        case .failure(_):
                            Image(.noImagePlaceholder)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        @unknown default:
                            Image(.noImagePlaceholder)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 5)
                    // .border(.green)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(dateText)
                            .font(.system(size: 12))
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                        Text(name)
                            .font(.system(size: 12))
                            .bold()
                            .foregroundStyle(.defaultBlack)
                        HStack(spacing: 5) {
                            Image(.grayMarker)
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
    func schoolFestDetailRow(name: String, day: Int, location: String, celebs: [StarItem]? = nil) -> some View {
        
        let weekday = getWeekdayFromComponents(year: 2025, month: selectedMonth, day: selectedDay) ?? ""
        
        VStack {
            HStack {
                Image(.verticalBar)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 72)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(String(format: "%02d", selectedMonth) + "/" + String(format: "%02d", selectedDay) + "(\(weekday.prefix(1)))")
                        .bold()
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .padding(.bottom, 5)
                    
                    Text(name + " DAY \(day)")
                        .font(.system(size: 18))
                        .foregroundStyle(.defaultBlack)
                        .fontWeight(.semibold)
                        .padding(.bottom, 11)
                    
                    HStack(spacing: 5) {
                        Image(.grayMarker)
                        Text(location)
                            .font(.system(size: 11))
                            .fontWeight(.medium)
                            .foregroundStyle(.gray)
                    }
                }
                
                if let celebs = celebs {
                    ZStack(alignment: .leading) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                Spacer()
                                    .frame(width: 30)
                                
                                ForEach(celebs, id: \.self) { star in
                                    CelebCircleView(celeb: CelebProfile(name: star.name, imageURL: star.imgUrl))
                                }
                                
                                Spacer()
                                    .frame(width: 20)
                            }
                        }
                        .frame(height: 72)
                        // .border(.red)
                        
                        //                        Image(.leftRowOverlay)
                        //                            .resizable()
                        //                            .scaledToFit()
                        //                            .frame(height: 72)
                        
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.ufBackground, Color.clear]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: 30, height: 72)
                    }
                    .frame(height: 72)
                    // .border(.green)
                }
            }
            .frame(height: 72)
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
    
    func getWeekdayFromComponents(year: Int, month: Int, day: Int) -> String? {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        
        let calendar = Calendar.current
        guard let date = calendar.date(from: dateComponents) else {
            return nil
        }
        
        let weekdayFormatter = DateFormatter()
        weekdayFormatter.dateFormat = "EEEE"
        weekdayFormatter.locale = Locale(identifier: "ko_KR")
        
        return weekdayFormatter.string(from: date)
    }
}

struct CelebCircleView: View {
    let celeb: CelebProfile
    @State private var isTouched: Bool = false
    @State private var loadFailed: Bool = false
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: celeb.imageURL)) { phase in
                switch phase {
                case .empty:
                    ZStack(alignment: .center) {
                        Circle()
                            .fill(.defaultLightGray)
                            .frame(width: 72, height: 72)
                        //                         MarqueeText(text: celeb.name, font: .systemFont(ofSize: 13), leftFade: 10, rightFade: 10, startDelay: 0, alignment: .center)
                        //                             .frame(width: 50)
                        Text(celeb.name)
                            .font(.system(size: 13))
                            .fontWeight(.medium)
                            .foregroundStyle(.defaultBlack)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 72)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(Circle())
                case .failure(_):
                    ZStack(alignment: .center) {
                        Circle()
                            .fill(.defaultLightGray)
                            .frame(width: 72, height: 72)
                        
                        //                         MarqueeText(text: celeb.name, font: .systemFont(ofSize: 13), leftFade: 10, rightFade: 10, startDelay: 0, alignment: .center)
                        //                             .frame(width: 50)
                        Text(celeb.name)
                            .font(.system(size: 13))
                            .fontWeight(.medium)
                            .foregroundStyle(.defaultBlack)
                            .multilineTextAlignment(.center)
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
                        GATracking.sendLogEvent(GATracking.LogEventType.FestivalInfoView.HOME_CLICK_CELEB_PROFILE, params: ["celebName": celeb.name])
                        
                        withAnimation {
                            isTouched = true
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
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
                        //                         MarqueeText(text: celeb.name, font: .systemFont(ofSize: 13), leftFade: 10, rightFade: 10, startDelay: 0, alignment: .center)
                        Text(celeb.name)
                            .font(.system(size: 13))
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .multilineTextAlignment(.center)
                    }
            }
        }
        .frame(width: 72, height: 72)
    }
}

#Preview {
    RootView(rootViewModel: RootViewModel(), networkManager: NetworkManager())
}

struct CelebProfile: Codable, Identifiable {
    var id = UUID()
    var name: String
    var imageURL: String
}
