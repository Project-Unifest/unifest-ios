//
//  WeeklyCalendarView.swift
//  unifest-ios
//
//  Created by 임지성 on 11/30/24.
//

import SwiftUI

struct WeeklyCalendarView: View {
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
                            .foregroundStyle(isToday ? .primary500 : fontColor)
                            .fontWeight(isToday ? .bold : .semibold)
                            .overlay {
                                if selectedMonth == thisMonth && selectedDay == thisDay {
                                    Circle()
                                        .fill(Color.primary500)
                                        .frame(width: 25, height: 25)
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
                                
                                GATracking.sendLogEvent(GATracking.LogEventType.FestivalInfoView.HOME_CHANGE_DATE, params: ["month": selectedMonth, "day": selectedDay])
                                
                                if selectedMonth != month {
                                    month = selectedMonth
                                }
                                
                                viewModel.festivalModel.getFestivalByDate(year: selectedYear, month: selectedMonth, day: selectedDay)
                            }
                        
                        let festivalNum: Int = viewModel.festivalModel.isFestival(
                            year: Calendar.current.component(.year, from: day),
                            month: Calendar.current.component(.month, from: day),
                            day: Calendar.current.component(.day, from: day)
                        )
                        
                        if festivalNum >= 3 {
                            simpleDot(.ufRed)
                        } else if festivalNum == 2 {
                            simpleDot(.ufOrange)
                        } else if festivalNum == 1 {
                            simpleDot(.ufBluegreen)
                        } else {
                            simpleDot(.clear)
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(.ufWhite)
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
