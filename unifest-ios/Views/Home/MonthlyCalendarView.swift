//
//  MonthlyCalendarView.swift
//  unifest-ios
//
//  Created by 임지성 on 11/30/24.
//

import SwiftUI

struct MonthlyCalendarView: View {
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
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .background(.ufWhite)
        .onAppear {
            calendar = getCalendar(calMonth: month)
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
    
    /// 주어진 달의 모든 날짜를 주 단위로 나누어 배열로 반환함
    /// 한 주씩 날짜를 계산해서 주 단위 배열(week)에 추가
    /// 각 주 배열을 calendar에 추가
    /// 따라서 calendar.count는 선택한 달의 주의 개수를 나타냄
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
