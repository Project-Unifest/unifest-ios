//
//  HomeView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 4/5/24.
//

import SwiftUI

// HomeView 안에 WeeklyCalendarView, MonthlyCalendarView, FestivalInfoView가 있음
// WeeklyCalendarView는 달력이 expanded되기 전의 뷰(한 주)
// MonthlyCalendarView는 달력이 expanded된 후의 뷰(한 달)
// FestivalInfoView는 그 밑에 O월O일 축제 일정, 다가오는 축제 일정을 보여주는 뷰

struct HomeView: View {
    @ObservedObject var viewModel: RootViewModel
    @State private var calendar: [[Date]] = []
    
    // 이니셜라이저에서 초기화
    @State private var currentYear: Int
    @State private var currentMonth: Int
    @State private var selectedYear: Int
    @State private var selectedMonth: Int
    @State private var selectedDay: Int
    @State private var firstSundayOfYear: Date // 주어진 해의 첫 번째 일요일
    @State private var currentFirstSunday: Date // 선택한 날짜가 속한 주의 첫 번쨰 일요일
    @State private var weekPageIndex: Int = 0 // 선택된 주가 연도에서 몇 번째 주인지 나타냄(WeeklyCalendarView가 표시될 때 해당 주의 데이터를 로드)
    
    @State private var isExpanded: Bool = false // week <-> month 전환
    @State private var monthPageIndex: Int = 0 // 선택된 월
    
    @State private var showNoticeImage: Bool = false
    @State private var selectedNoticeImage: String?
    
    // 캘린더를 위아래로 드래그했을 때 week <-> month 전환
    @State private var startOffsetY: CGFloat = 0.0
    @State private var lastOffsetY: CGFloat = 0.0
    
    init(viewModel: RootViewModel) {
        let date = Date()
        _currentYear = State(initialValue: Calendar.current.component(.year, from: date))
        _currentMonth = State(initialValue: Calendar.current.component(.month, from: date))
        
        _selectedYear = State(initialValue: Calendar.current.component(.year, from: date))
        _selectedMonth = State(initialValue: Calendar.current.component(.month, from: date))
        _selectedDay = State(initialValue: Calendar.current.component(.day, from: date))
        
        _firstSundayOfYear = State(initialValue: Date())
        _currentFirstSunday = State(initialValue: Date())
        
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(spacing: 0) {
            calendarView
            
            Spacer()
                .frame(height: 37)
            
            FestivalInfoView(
                viewModel: viewModel,
                selectedMonth: $selectedMonth,
                selectedDay: $selectedDay,
                showNoticeImage: $showNoticeImage,
                selectedNoticeImage: $selectedNoticeImage
            )
            .padding(.top, -17)
        }
        .fullScreenCover(isPresented: $showNoticeImage) {
            ScalableImageView(imageName: selectedNoticeImage ?? "")
        }
    }
}

// MARK: - Components

private extension HomeView {
    var calendarView: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 30)
            
            TabView(selection: isExpanded ? $monthPageIndex : $weekPageIndex) {
                if !isExpanded {
                    ForEach(0..<52, id: \.self) { weekIdx in
                        let firstSunday = Calendar.current.date(byAdding: .day, value: weekIdx * 7, to: firstSundayOfYear)!
                        let wednesday = Calendar.current.date(byAdding: .day, value: weekIdx * 7 + 3, to: firstSundayOfYear)!
                        
                        WeeklyCalendarView(
                            viewModel: viewModel,
                            year: currentYear,
                            month: $currentMonth,
                            currentFirstSunday: firstSunday,
                            selectedYear: $selectedYear,
                            selectedMonth: $selectedMonth,
                            selectedDay: $selectedDay
                        )
                        .onAppear {
                            currentMonth = Calendar.current.component(.month, from: wednesday)
                        }
                    }
                } else {
                    ForEach(1...12, id: \.self) { month in
                        MonthlyCalendarView(
                            viewModel: viewModel,
                            year: currentYear, month: month,
                            currentMonth: $currentMonth,
                            selectedYear: $selectedYear,
                            selectedMonth: $selectedMonth,
                            selectedDay: $selectedDay,
                            calendar: $calendar
                        )
                    }
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: isExpanded ? getHeightByWeekNum(self.calendar.count) : 120)
        .background(.ufWhite)
        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16))
        .shadow(
            color: Color.black.opacity(0.08),
            radius: 8,
            x: 0,
            y: 4
        )
        .mask{
            UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16)
                .padding(.bottom, -20)
        }
        .onAppear {
            firstSundayOfYear = getFirstSundayOfYear()
            currentFirstSunday = getFirstSunday(fromDate: Date())
            weekPageIndex = getWeekIndex()
            viewModel.festivalModel.getFestivalByDate(year: selectedYear, month: selectedMonth, day: selectedDay) // 축제 정보 요청 api 호출
        }
    }
    
    var monthlyCalnderHeader: some View {
        HStack {
            // 2024년 O월을 탭하면 원하는 달로 이동할 수 있는 Menu가 나타남
            Menu {
                ForEach(1 ..< 13, id: \.self) { monthIndex in
                    Button("\(monthIndex)" + StringLiterals.Calendar.month) {
                        monthPageIndex = monthIndex
                    }
                }
            } label: {
                Text("\(String(selectedYear))년 \(monthPageIndex)월")
                    .font(.system(size: 24))
                    .foregroundStyle(.defaultBlack)
                    .bold()
            }
            .padding(.trailing, 10)
            
            HStack(alignment: .center, spacing: 0) {
                simpleDot(.ufBluegreen)
                    .padding(.trailing, 3)
                Text("1개")
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
                    .padding(.trailing, 6)
                simpleDot(.ufOrange)
                    .padding(.trailing, 3)
                Text("2개")
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
                    .padding(.trailing, 6)
                simpleDot(.ufRed)
                    .padding(.trailing, 3)
                Text("3개 이상")
                    .font(.system(size: 11))
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            Button {
                GATracking.sendLogEvent(GATracking.LogEventType.FestivalInfoView.HOME_CHANGE_CALENDAR_PAGE)
                monthPageIndex -= 1
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
            .disabled(monthPageIndex == 1)
            
            Spacer()
                .frame(width: 30)
            
            Button {
                GATracking.sendLogEvent(GATracking.LogEventType.FestivalInfoView.HOME_CHANGE_CALENDAR_PAGE)
                monthPageIndex += 1
            } label: {
                Image(systemName: "chevron.right")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
            .disabled(monthPageIndex == 12)
        }
        .padding(.horizontal, 20)
        .padding(.vertical)
        .background(.ufWhite)
        .frame(maxWidth: .infinity)
    }
    
    var calenderChangeButton: some View {
        HStack {
            Button {
                // 월 -> 주
                if isExpanded {
                    GATracking.sendLogEvent(GATracking.LogEventType.FestivalInfoView.HOME_SHRINK_CALENDAR)
                    weekPageIndex = getWeekIndex()
                    withAnimation(.spring) {
                        isExpanded = false
                    }
                }
                // 주 -> 월
                else {
                    GATracking.sendLogEvent(GATracking.LogEventType.FestivalInfoView.HOME_EXPAND_CALENDAR)
                    weekPageIndex = selectedMonth
                    monthPageIndex = selectedMonth
                    withAnimation(.spring) {
                        isExpanded = true
                    }
                }
            } label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .rotationEffect(isExpanded ? .degrees(180) : .zero)
            }
            .padding(20)
            .contentShape(Rectangle())
        }
        .offset(y: isExpanded ? getViewOffsetY(self.calendar.count) - 12 : 40) // chevron 버튼의 위치 결정
    }
    
    var calenderDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                if (startOffsetY < 0) {
                    startOffsetY = value.translation.height
                }
                lastOffsetY = value.translation.height
            }
            .onEnded { _ in
                if (startOffsetY < lastOffsetY) {
                    if !isExpanded {
                        weekPageIndex = selectedMonth
                        monthPageIndex = selectedMonth
                        withAnimation(.spring) {
                            isExpanded = true
                        }
                    }
                } else {
                    if isExpanded {
                        weekPageIndex = getWeekIndex()
                        withAnimation(.spring) {
                            isExpanded = false
                        }
                    }
                }
                self.startOffsetY = -1
                self.lastOffsetY = 0
            }
    }
    
    @ViewBuilder
    func simpleDot(_ color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 7, height: 7)
    }
}

// MARK: - Methods

private extension HomeView {
    
    // 달력 탭뷰가 펼쳐지거나 접혔을 때, 달력 탭뷰 아래의 chevron.down 버튼을 포함한 이 뷰(TabView에 overlay한 뷰)의 y축 offset을 조정하기 위한 메서드
    func getViewOffsetY(_ numberOfWeeks: Int) -> CGFloat {
        // 한 달이 4주, 5주, 6주일 때 각각 y축 offset값 조절
        if numberOfWeeks == 6 { return 172 }
        else if numberOfWeeks == 5 { return 152 }
        else { return 132 } // 4주일 때는 화면 확인 안해봄
    }
    
    func getFirstSundayOfYear() -> Date {
        let date = Date()
        let year = Calendar.current.component(.year, from: date)
        let firstDayOfYear = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))!
        let weekday = Calendar.current.component(.weekday, from: firstDayOfYear)
        let firstSundayOfYear = Calendar.current.date(byAdding: .day, value: 1 - weekday, to: firstDayOfYear)!
        
        return firstSundayOfYear
    }
    
    func getFirstSunday(fromDate: Date) -> Date {
        // get the first sunday of selected day
        let weekday = Calendar.current.component(.weekday, from: fromDate)
        return Calendar.current.date(byAdding: .day, value: -weekday, to: fromDate)!
    }
    
    func getWeekIndex() -> Int {
        let selectedDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: selectedDay))!
        let firstSunday = getFirstSunday(fromDate: selectedDate)
        
        // get difference number of week between firstSunday and firstSundayOfYear
        let diff = Calendar.current.dateComponents([.weekOfYear], from: firstSundayOfYear, to: firstSunday).weekOfYear! + 1
        
        return diff
    }
    
    func getHeightByWeekNum(_ numberOfWeeks: Int) -> CGFloat {
        // getHeightByWeekNum()으로 MonthlyCalendarView의 높이를 정함(몇 주냐에 따라서)
        // 한 달이 4주, 5주, 6주일 때 각각 MonthlyCalendarView 높이 조절
        if numberOfWeeks == 6 { return 325 }
        else if numberOfWeeks == 5 { return 285 }
        else { return 245 } // 4주일 때는 화면 확인 안해봄
    }
    
    func getWeekNumOfYear() -> [Int] {
        var weekNumList: [Int] = [0]
        // calculator number of week per each month
        for month in 1...12 {
            let firstDayOfMonth = Calendar.current.date(from: DateComponents(year: currentYear, month: month, day: 1))!
            let weekday = Calendar.current.component(.weekday, from: firstDayOfMonth)
            let firstSundayOfMonth = Calendar.current.date(byAdding: .day, value: 1 - weekday, to: firstDayOfMonth)!
            
            let lastDayOfMonth = Calendar.current.date(from: DateComponents(year: currentYear, month: month + 1, day: 1))!
            let lastWeekday = Calendar.current.component(.weekday, from: lastDayOfMonth)
            let lastSaturdayOfMonth = Calendar.current.date(byAdding: .day, value: 7 - lastWeekday, to: lastDayOfMonth)!
            
            let weekNum = Calendar.current.dateComponents([.weekOfYear], from: firstSundayOfMonth, to: lastSaturdayOfMonth).weekOfYear! + 1
            
            weekNumList.append(weekNum)
        }
        return weekNumList
    }
}

// MARK: - Preview

#Preview {
    HomeView(viewModel: RootViewModel())
}
