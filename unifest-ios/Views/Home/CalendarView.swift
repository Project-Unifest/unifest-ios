//
//  CalendarView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 4/5/24.
//

import SwiftUI

// CalendarTabView 안에 CalendarView, HomeView가 있음
// CalendarView는 이 preview에서 위에 뜨는 달력
// HomeView는 그 밑에 O월O일 축제 일정, 다가오는 축제 일정을 보여주는 뷰
// CalendarWeekView는 ..?

struct CalendarView: View {
    @ObservedObject var viewModel: RootViewModel
    
    let year: Int
    let month: Int
    
    @Binding var currentMonth: Int
    
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int
    @Binding var selectedDay: Int
    
    @Binding var calendar: [[Date]]
    
    let weekTextList: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 20) {
                
                ForEach(weekTextList, id: \.self) { weekText in
                    Text(weekText)
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .fontWeight(.medium)
                }
                
                ForEach(calendar, id: \.self) { week in
                    ForEach(week, id: \.self) { day in
                        let thisMonth = Calendar.current.component(.month, from: day)
                        let thisDay = Calendar.current.component(.day, from: day)
                        
                        let fontColor = getFontColor(thisMonth: thisMonth)
                        let isToday = checkToday(thisMonth: thisMonth, thisDay: thisDay)
                        
                        VStack {
                            Text("\(thisDay)")
                                .font(.system(size: 13))
                                .foregroundStyle(isToday ? .accentColor : fontColor)
                                .fontWeight(isToday ? .bold : .semibold)
                                .overlay {
                                    if selectedMonth == thisMonth && selectedDay == thisDay {
                                        Circle()
                                            .fill(Color.accentColor)
                                            .frame(width: 20, height: 20)
                                            .overlay {
                                                Text("\(thisDay)")
                                                    .font(.system(size: 13))
                                                    .foregroundStyle(.white)
                                                    .fontWeight(.semibold)
                                            }
                                    }
                                }
                                .onTapGesture {
                                    selectedYear = Calendar.current.component(.year, from: day)
                                    selectedMonth = Calendar.current.component(.month, from: day)
                                    selectedDay = Calendar.current.component(.day, from: day)
                                    
                                    if selectedMonth != month {
                                        currentMonth = selectedMonth
                                    }
                                    
                                    viewModel.festivalModel.getFestivalByDate(year: selectedYear, month: selectedMonth, day: selectedDay)
                                }
                            
                            let festivalNum: Int = viewModel.festivalModel.isFestival(year: Calendar.current.component(.year, from: day), month: Calendar.current.component(.month, from: day), day: Calendar.current.component(.day, from: day))
                            /* if (festivalNum > 0) {
                                simpleDot(.defaultGreen)
                            } else {
                                simpleDot(.clear)
                            }*/
                            if festivalNum >= 3 {
                                simpleDot(.accent)
                            } else if festivalNum == 2 {
                                simpleDot(.defaultOrange)
                            } else if festivalNum == 1 {
                                simpleDot(.defaultGreen)
                            } else {
                                simpleDot(.clear)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            calendar = getCalendar(calMonth: month)
            print("num of week: \(calendar.count)")
        }
    }
    
    func checkToday(thisMonth: Int, thisDay: Int) -> Bool {
        let today = Calendar.current.dateComponents([.month, .day], from: Date())
        return today.month == thisMonth && today.day == thisDay
    }
    
    func getFontColor(thisMonth: Int) -> Color {
        if thisMonth == month {
            return .defaultBlack
        } else {
            return .gray
        }
    }
    
    func getCalendar(calMonth: Int) -> [[Date]] {
        // get the first day of the month
        let firstDayComponents = DateComponents(year: year, month: calMonth, day: 1)
        
        // get weekdays of the first day
        let firstDay = Calendar.current.date(from: firstDayComponents)!
        
        // get the sunday of this week
        let firstSunday = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: firstDay))!

        var calendar: [[Date]] = []
        for i in 0..<6 {
            // 해당 주의 첫날 끝날이 모두 해당 월에 포함하지 않을 경우 break
            if Calendar.current.component(.month, from: Calendar.current.date(byAdding: .day, value: i * 7, to: firstSunday)!) != calMonth && Calendar.current.component(.month, from: Calendar.current.date(byAdding: .day, value: i * 7 + 6, to: firstSunday)!) != calMonth {
                break
            }
            // 새로운 칼럼 추가
            calendar.append([])
            for j in 0..<7 {
                let index = i * 7 + j
                let day = Calendar.current.date(byAdding: .day, value: index, to: firstSunday)!
                calendar[i].append(day)
            }
        }
        
        return calendar
    }
    
    func checkInWeek(days: [Date]) -> Bool {
        // check selected year, month, day in this week
        for day in days {
            if selectedYear == Calendar.current.component(.year, from: day) && selectedMonth == Calendar.current.component(.month, from: day) && selectedDay == Calendar.current.component(.day, from: day) {
                return true
            }
        }
        return false
    }
    
    func selectedDayInMonth() -> Bool {
        for week in calendar {
            for day in week {
                if selectedYear == Calendar.current.component(.year, from: day) && selectedMonth == Calendar.current.component(.month, from: day) && selectedDay == Calendar.current.component(.day, from: day) {
                    return true
                }
            }
        }
        return false
    }
    
    @ViewBuilder
    func simpleDot(_ color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 7, height: 7)
    }
}

struct CalendarWeekView: View {
    @ObservedObject var viewModel: RootViewModel
    let year: Int
    @Binding var month: Int
    let currentFirstSunday: Date
    
    @Binding var selectedYear: Int
    @Binding var selectedMonth: Int
    @Binding var selectedDay: Int
    
    @State private var calendar: [Date] = []
    
    let weekTextList: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 7), spacing: 20) {
                
                ForEach(weekTextList, id: \.self) { weekText in
                    Text(weekText)
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                        .fontWeight(.medium)
                }
                
                ForEach(getWeekCalendar(firstSunday: currentFirstSunday), id: \.self) { day in
                    let thisMonth = Calendar.current.component(.month, from: day)
                    let thisDay = Calendar.current.component(.day, from: day)
                    
                    let fontColor = getFontColor(thisMonth: thisMonth)
                    let isToday = checkToday(thisMonth: thisMonth, thisDay: thisDay)
                    
                    VStack {
                        Text("\(thisDay)")
                            .font(.system(size: 13))
                            .foregroundStyle(isToday ? .accentColor : fontColor)
                            .fontWeight(isToday ? .bold : .semibold)
                            .overlay {
                                if selectedMonth == thisMonth && selectedDay == thisDay {
                                    Circle()
                                        .fill(Color.accentColor)
                                        .frame(width: 20, height: 20)
                                        .overlay {
                                            Text("\(thisDay)")
                                                .font(.system(size: 13))
                                                .foregroundStyle(.white)
                                                .fontWeight(.semibold)
                                        }
                                }
                            }
                            .onTapGesture {
                                selectedYear = Calendar.current.component(.year, from: day)
                                selectedMonth = Calendar.current.component(.month, from: day)
                                selectedDay = Calendar.current.component(.day, from: day)
                                
                                GATracking.sendLogEvent(GATracking.LogEventType.HomeView.HOME_CHANGE_DATE, params: ["month": selectedMonth, "day": selectedDay])
                                
                                if selectedMonth != month {
                                    month = selectedMonth
                                }
                                
                                viewModel.festivalModel.getFestivalByDate(year: 2024, month: selectedMonth, day: selectedDay)
                            }
                        
                        let festivalNum: Int = viewModel.festivalModel.isFestival(year: Calendar.current.component(.year, from: day), month: Calendar.current.component(.month, from: day), day: Calendar.current.component(.day, from: day))
                        /* if (festivalNum > 0) {
                            simpleDot(.defaultGreen)
                        } else {
                            simpleDot(.clear)
                        }*/
                        
                        if festivalNum >= 3 {
                            simpleDot(.accent)
                        } else if festivalNum == 2 {
                            simpleDot(.defaultOrange)
                        } else if festivalNum == 1 {
                            simpleDot(.defaultGreen)
                        } else {
                            simpleDot(.clear)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
//            calendar =
//            print(calendar)
        }
    }
    
    func getFirstSunday(fromDate: Date) -> Date {
        // get the first sunday of selected day
        let weekday = Calendar.current.component(.weekday, from: fromDate)
        return Calendar.current.date(byAdding: .day, value: -weekday, to: fromDate)!
    }
    
    func checkToday(thisMonth: Int, thisDay: Int) -> Bool {
        let today = Calendar.current.dateComponents([.month, .day], from: Date())
        return today.month == thisMonth && today.day == thisDay
    }
    
    func getFontColor(thisMonth: Int) -> Color {
        if thisMonth == month {
            return .defaultBlack
        } else {
            return .gray
        }
    }
    
    func getWeekCalendar(firstSunday: Date) -> [Date] {
        var calendar: [Date] = []
        
        for i in 0..<7 {
            let day = Calendar.current.date(byAdding: .day, value: i, to: firstSunday)!
            calendar.append(day)
        }
        
        return calendar
    }
    
    @ViewBuilder
    func simpleDot(_ color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 7, height: 7)
    }
}

extension Int {
    func formatterStyle(_ numberStyle: NumberFormatter.Style) -> String? {
        let numberFommater: NumberFormatter = NumberFormatter()
        numberFommater.numberStyle = numberStyle
        return numberFommater.string(for: self)
    }
}

struct CalendarTabView: View {
    @ObservedObject var viewModel: RootViewModel
    
    @State private var currentYear: Int
    @State private var currentMonth: Int
    @State private var isExpanded: Bool = false
    
    @State private var firstSundayOfYear: Date
    @State private var currentFirstSunday: Date
    @State private var currentWeekIdx: Int = 0
    
    @State private var selectedYear: Int
    @State private var selectedMonth: Int
    @State private var selectedDay: Int
    
    @State private var monthPageIndex: Int = 0
    @State private var weekPageIndex: Int = 0
    
    @State private var startOffsetY: CGFloat = 0.0
    @State private var lastOffsetY: CGFloat = 0.0
    
    @State private var calendar: [[Date]] = []
    
    @State private var isInfoPresented: Bool = false

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
            VStack(spacing: 0) {
                if isExpanded {
                    HStack {
                        Menu {
                            ForEach(1..<13, id: \.self) { monthIndex in
                                Button("\(monthIndex)" + StringLiterals.Calendar.month) {
                                    monthPageIndex = monthIndex
                                }
                            }
                        } label: {
                            Text("\(selectedYear)년 \(monthPageIndex)" + StringLiterals.Calendar.month)
                                .font(.system(size: 24))
                                .foregroundStyle(.defaultBlack)
                                .bold()
                        }
                        .padding(.trailing, 10)
                        
                        if isInfoPresented {
                            HStack(alignment: .center, spacing: 0) {
                                simpleDot(.defaultGreen)
                                    .padding(.trailing, 3)
                                Text("1개")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                                    .padding(.trailing, 8)
                                simpleDot(.defaultOrange)
                                    .padding(.trailing, 3)
                                Text("2개")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                                    .padding(.trailing, 8)
                                simpleDot(.accent)
                                    .padding(.trailing, 3)
                                Text("3개 이상")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        Button {
                            GATracking.sendLogEvent(GATracking.LogEventType.HomeView.HOME_CHANGE_CALENDAR_PAGE)
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
                            GATracking.sendLogEvent(GATracking.LogEventType.HomeView.HOME_CHANGE_CALENDAR_PAGE)
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
                    .background(.background)
                    .frame(maxWidth: .infinity)
                }
                
                TabView(selection: isExpanded ? $monthPageIndex : $weekPageIndex) {
                    if !isExpanded {
                        ForEach(0..<52, id: \.self) { weekIdx in
                            let firstSunday = Calendar.current.date(byAdding: .day, value: weekIdx * 7, to: firstSundayOfYear)!
                            let wednesday = Calendar.current.date(byAdding: .day, value: weekIdx * 7 + 3, to: firstSundayOfYear)!
                            
                            CalendarWeekView(viewModel: viewModel, year: currentYear, month: $currentMonth, currentFirstSunday: firstSunday, selectedYear: $selectedYear, selectedMonth: $selectedMonth, selectedDay: $selectedDay)
                                .onAppear {
                                    currentMonth = Calendar.current.component(.month, from: wednesday)
                                }
                        }
                    } else {
                        ForEach(1...12, id: \.self) { month in
                            CalendarView(viewModel: viewModel, year: currentYear, month: month, currentMonth: $currentMonth, selectedYear: $selectedYear, selectedMonth: $selectedMonth, selectedDay: $selectedDay, calendar: $calendar)
                        }
                    }
                }
                .background(.background)
                .tabViewStyle(.page(indexDisplayMode: .never))
                // .border(.red)
                .frame(height: isExpanded ? getHeightByWeekNum(self.calendar.count) : 80) // 6주 340 5주 290 4주 240 1주 80
                .overlay {
                    Image(.navBottom)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .offset(y: isExpanded ? getViewOffsetY() : 62)
                        .overlay {
                            HStack {
                                Button {
                                    // 월 -> 주
                                    if isExpanded {
                                        GATracking.sendLogEvent(GATracking.LogEventType.HomeView.HOME_SHRINK_CALENDAR)
                                        weekPageIndex = getWeekIndex()
                                        withAnimation(.spring) {
                                            isExpanded = false
                                        }
                                    }
                                    // 주 -> 월
                                    else {
                                        GATracking.sendLogEvent(GATracking.LogEventType.HomeView.HOME_EXPAND_CALENDAR)
                                        weekPageIndex = selectedMonth
                                        monthPageIndex = selectedMonth
                                        withAnimation(.spring) {
                                            isExpanded = true
                                            isInfoPresented = true
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                isInfoPresented = false
                                            }
                                        }
                                    }
                                } label: {
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 20))
                                        .foregroundColor(.gray)
                                        .rotationEffect(isExpanded ? .degrees(180) : .zero)
                                }
                            }
                            .offset(y: isExpanded ? getViewOffsetY() - 12 : 50)
                            // .border(.green)
                        }
                    // .border(.blue)
                }
                
                /* TabView(selection: $currentMonth) {
                 ForEach(1...12, id: \.self) { month in
                 CalendarView(year: currentYear, month: month, currentMonth: $currentMonth, selectedYear: $selectedYear, selectedMonth: $selectedMonth, selectedDay: $selectedDay)
                 }
                 }
                 .background(.background)
                 .tabViewStyle(.page)
                 .frame(height: 340)*/
            }
            .onAppear {
                firstSundayOfYear = getFirstSundayOfYear()
                currentFirstSunday = getFirstSunday(fromDate: Date())
                weekPageIndex = getWeekIndex()
                // print(firstSundayOfYear)
                // print(currentFirstSunday)
                // getViewHeight()
                viewModel.festivalModel.getFestivalByDate(year: 2024, month: selectedMonth, day: selectedDay)
            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if (startOffsetY < 0) {
                            startOffsetY = value.translation.height
                        }
                        lastOffsetY = value.translation.height
                        // print("Y offset: \(self.lastOffsetY)")
                    }
                    .onEnded { _ in
                        if (startOffsetY < lastOffsetY) {
                            if !isExpanded {
                                weekPageIndex = selectedMonth
                                monthPageIndex = selectedMonth
                                withAnimation(.spring) {
                                    isExpanded = true
                                    isInfoPresented = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        isInfoPresented = false
                                    }
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
            )
            
            Spacer()
                .frame(height: 24)
            
            HomeView(viewModel: viewModel, selectedMonth: $selectedMonth, selectedDay: $selectedDay, isFest: true)
        }
    }
    
    @ViewBuilder
    func simpleDot(_ color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 7, height: 7)
    }
    
    func getViewHeight() -> CGFloat {
        let heightList: [CGFloat] = [80, 90, 140, 190, 240, 290, 340, 390, 440]
        let weekNumList = getWeekNumOfYear()
        let weekNum = weekNumList[currentMonth]
        return heightList[weekNum]
    }
    
    func getViewOffsetY() -> CGFloat {
        let offsetYList: [CGFloat] = [0, 0, 0, 117, 142, 167, 192, 217, 0]
        let weekNumList = getWeekNumOfYear()
        let weekNum = weekNumList[currentMonth]
        return offsetYList[weekNum]
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
        
        // print("diff: \(diff)")
        return diff
    }
    
    func getHeightByWeekNum(_ numWeek: Int) -> CGFloat {
        // 6주 340 5주 290 4주 240 1주 80
        if numWeek >= 7 {
            return 490
        } else if numWeek == 6 {
            return 390
        } else if numWeek == 5 {
            return 290
        } else if numWeek == 4 {
            return 240
        } else if numWeek == 3 {
            return 190
        } else {
            return 80
        }
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
        print(weekNumList)
        return weekNumList
    }
}

#Preview {
    CalendarTabView(viewModel: RootViewModel())
}
