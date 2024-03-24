//
//  HomeView.swift
//  unifest-ios
//
//  Created by Hoeun Lee on 3/22/24.
//

import SwiftUI

struct HomeView: View {
    @State var heightValue = 300.0
    @State var downHeight = 0.0
    @GestureState var isDragging = false
    
    // isExpanded
    @State private var isExpanded: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                VStack {
                    Spacer()
                        .frame(height: 30)
                    
                    HStack {
                        Text("Uni-Fest")
                            .font(.system(size: 24))
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    Text("Calendar View")
                    
                    Divider()
                    
                    
                }
                .background(.background)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 23,
                        bottomTrailingRadius: 23,
                        topTrailingRadius: 0
                    )
                )
                .shadow(color: .black.opacity(0.12), radius: 18.5, x: 0, y: 4)
                .ignoresSafeArea(edges: .top)
                
                Spacer()
            }
        }
        
        VStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("오늘의 축제 일정")
                            .font(.system(size: 15))
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    HomeView()
}

struct CalendarView: View {
    @State var isExpanded: Bool
    @State var selectedYear: Int
    @State var selectedMonth: Int
    private let numberFormatter: NumberFormatter = NumberFormatter()
    
    init(isExpanded: Bool, year: Int, month: Int) {
        self.isExpanded = isExpanded
        numberFormatter.numberStyle = .decimal
        self.selectedYear = year
        self.selectedMonth = month
    }
    
    var body: some View {
        VStack {
            if isExpanded {
                HStack {
                    Text("\(selectedYear.formatterStyle(.none) ?? "")년 \(selectedMonth)월")
                        .font(.system(size: 14))
                        .bold()
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            if selectedMonth == 1 {
                                selectedYear -= 1
                                selectedMonth = 12
                            } else {
                                selectedMonth -= 1
                            }
                        } label: {
                            Image(.leftArrow)
                        }
                        .frame(width: 25)
                        
                        Button {
                            if selectedMonth == 12 {
                                selectedYear += 1
                                selectedMonth = 1
                            } else {
                                selectedMonth += 1
                            }
                        } label: {
                            Image(.rightArrow)
                        }
                        .frame(width: 25)
                    }
                }
                .padding()
            }
            
            HStack(spacing: 40) {
                Text("일")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .frame(width: 17)
                
                Text("월")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .frame(width: 17)
                
                Text("화")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .frame(width: 17)
                
                Text("수")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .frame(width: 17)
                
                Text("목")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .frame(width: 17)
                
                Text("금")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .frame(width: 17)
                
                Text("토")
                    .font(.system(size: 12))
                    .fontWeight(.semibold)
                    .foregroundStyle(.gray)
                    .frame(width: 17)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            VStack {
                if let dateList = makeCalendarDateList(year: selectedYear, month: selectedMonth) {
                    ForEach(0..<dateList.count / 7) { row in
                        HStack(spacing: 40) {
                            ForEach(0..<7) { col in
                                let index = row * 7 + col
                                Text("\(dateList[index].date)")
                                    .font(.system(size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundStyle(dateList[index].month == selectedMonth ? .defaultBlack : .gray)
                                    .frame(width: 17)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            
            Image(.indicator)
        }
    }
    
    func makeCalendarDateList(year: Int, month: Int) -> [CalendarDate]? {
        var dates: [CalendarDate] = []
            
        // 날짜 계산을 위한 날짜 포맷터
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // 월의 첫 번째 날짜 (1일)
        guard let firstDate = dateFormatter.date(from: "\(year)-\(String(format: "%02d", month))-01") else {
            return dates
        }
        
        // 월의 첫 번째 날짜가 무슨 요일인지 확인
        let firstWeekday = Calendar.current.component(.weekday, from: firstDate)
        
        // 첫 번째 일요일 날짜 계산
        let sundayComponents = DateComponents(year: year, month: month, day: 1 - (firstWeekday - 1))
        let firstSunday = Calendar.current.date(from: sundayComponents)!
        
        // 다음 달 첫 번째 날짜
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: firstDate)!
        
        // 첫 번째 일요일부터 다음 달 첫 번째 날짜 전까지 날짜 추가
        var currentDate = firstSunday
        
        while currentDate < nextMonth {
            let month = Calendar.current.component(.month, from: currentDate)
            let day = Calendar.current.component(.day, from: currentDate)
            dates.append(CalendarDate(month: month, date: day))
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        // 주를 맞추기 위해 빈 날짜 추가
        if dates.count % 7 != 0 {
            let count = 7 - (dates.count % 7)
            for _ in 0..<count {
                let month = Calendar.current.component(.month, from: currentDate)
                let day = Calendar.current.component(.day, from: currentDate)
                dates.append(CalendarDate(month: month, date: day))
                currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
            }
        }
        
        return dates
    }
}

extension Int {
    func formatterStyle(_ numberStyle: NumberFormatter.Style) -> String? {
        let numberFommater: NumberFormatter = NumberFormatter()
        numberFommater.numberStyle = numberStyle
        return numberFommater.string(for: self)
    }
}

struct CalendarDate: Equatable, Hashable {
    var id = UUID()
    var month: Int
    var date: Int
    var isFestival: Bool = false
}

#Preview {
    CalendarView(isExpanded: false, year: 2024, month: 3)
}

#Preview {
    CalendarView(isExpanded: true, year: 2024, month: 3)
}

extension UIApplication {
    public var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}

//public struct SafeAreaInsetKey: EnvironmentKey {
//    public static var defaultValue: EdgeInsets {
//        (UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero).insets
//    }
//}
//
//extension EnvironmentValues {
//    public var safeAreaInsets: EdgeInsets {
//        self[SafeAreaInsetKey.self]
//    }
//}
//
//extension UIEdgeInsets {
//    public var insets: EdgeInsets {
//        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
//    }
//}
