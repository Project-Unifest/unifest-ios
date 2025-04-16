//
//  BoothInfoView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/21/24.
//

import SwiftUI

struct BoothInfoView: View {
    @ObservedObject var viewModel: RootViewModel
    @ObservedObject var mapViewModel: MapViewModel
    @State private var isMapViewPresented: Bool = false
    @State private var isOperatingHoursExpanded: Bool = false
    @Binding var selectedBoothHours: Int
    @Binding var isReloadButtonPresent: Bool
    @Binding var isBoothThumbnailPresented: Bool
    @Binding var boothThumbnail: SelectedMenuInfo
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    let boothHours = ["주간부스", "야간부스"]
    
    enum BoothHours: String, CaseIterable {
        case day = "주간부스"
        case night = "야간부스"
    }
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.boothModel.selectedBooth?.thumbnail ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 260)
                    .clipped()
                    .onTapGesture {
                        boothThumbnail.selectedMenuURL = viewModel.boothModel.selectedBooth?.thumbnail ?? ""
                        boothThumbnail.selectedMenuName = ""
                        boothThumbnail.selectedMenuPrice = ""
                        withAnimation(.spring(duration: 0.1)) {
                            isBoothThumbnailPresented = true
                        }
                    }
                
                // * 추후 코드 수정
                // 화면의 가로 길이를 UIScreen 말고 GeometryReader로 가져오는 게 권장되는데,
                // DetailView가 ScrollView고 그 하위 뷰에 GeometryReader가 있으니까 뷰 배치가 이상해져서 일단 이걸로 가져옴
                
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.defaultLightGray)
                    
                    Image(.noImagePlaceholder)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
            .overlay {
                VStack {
                    HStack {
                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            ZStack {
                                Circle()
                                    .frame(width: 26, height: 26)
                                    .tint(.defaultWhite.opacity(0.5))
                                
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundColor(.defaultBlack)
                            }
                        }
                        .padding()
                        .contentShape(Rectangle().inset(by: -30)) // 터치 영역 확장
                    }
                    
                    Spacer()
                }
            }
            .frame(height: 260)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle()) // contentShape: 원하는 터치 영역을 정확히 설정 가능
            .onTapGesture {
                // 부모 뷰로 터치 이벤트가 전달되지 않도록 차단
                // 이미지 이외의 부분을 탭해도 MenuImageView가 뜨지 않도록 보장함
            }
            
            // 주간, 야간 선택 탭바
            //            HStack {
            //                ForEach(boothHours.indices, id: \.self) { index in
            //                    HStack {
            //                        Spacer()
            //                        Text(boothHours[index])
            //                            .padding(.bottom, 12)
            //                            .font(self.selectedBoothHours == index ? .pretendard(weight: .p7, size: 13) : .pretendard(weight: .p5, size: 13))
            //                            .foregroundStyle(self.selectedBoothHours == index ? .grey900 : .grey600)
            //                            .onTapGesture {
            //                                withAnimation {
            //                                    self.selectedBoothHours = index
            //                                }
            //                            }
            //                        Spacer()
            //                    }
            //                    .overlay {
            //                        VStack {
            //                            Spacer()
            //                            if self.selectedBoothHours == index {
            //                                Color.grey900
            //                                    .frame(height: 1)
            //                            } else {
            //                                Color.grey200
            //                                    .frame(height: 1)
            //                            }
            //                        }
            //                    }
            //                }
            //                .padding(.top, 5)
            //            }
            
            // 부스 이름(쿠쿠네 분식)부터 '위치 확인하기' 버튼까지
            if viewModel.boothModel.selectedBooth == nil {
                VStack {
                    if !isReloadButtonPresent {
                        ProgressView()
                    }
                }
                .frame(height: 160)
            } else {
                VStack(alignment: .leading) {
                    /* MarqueeText(text: viewModel.boothModel.selectedBooth?.name ?? "", font: .systemFont(ofSize: 22), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .leading)
                     .frame(maxWidth: 160)
                     .bold()
                     .border(.green)*/
                    /* Text(viewModel.boothModel.selectedBooth?.name ?? "")
                     .font(.system(size: 22))
                     .bold()
                     .lineLimit(1)
                     */
                    // Text(viewModel.boothModel.selectedBooth?.name ?? "")
                    
                    
                    
                    if let name = viewModel.boothModel.selectedBooth?.name {
                        if !name.isEmpty {
                            MarqueeText(text: name, font: .systemFont(ofSize: 24), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .leading)
                            // .font(.system(size: 24))
                                .fontWeight(.bold)
                                .padding(.bottom, 4)
                            // .border(.green)
                        }
                    }
                    
                    if let warning = viewModel.boothModel.selectedBooth?.warning {
                        if !warning.isEmpty {
                            Text(viewModel.boothModel.selectedBooth?.warning ?? "")
                                .font(.pretendard(weight: .p6, size: 11))
                                .foregroundStyle(.primary500)
                            // .lineLimit(3)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                // .border(.red)
                
                if let description = viewModel.boothModel.selectedBooth?.description {
                    if !description.isEmpty {
                        VStack {
                            Text(viewModel.boothModel.selectedBooth?.description ?? "")
                                .font(.pretendard(weight: .p4, size: 13))
                                .foregroundStyle(.grey700)
                                .padding(.bottom)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                }
                
                HStack {
                    Button {
                        withAnimation {
                            isOperatingHoursExpanded.toggle()
                        }
                    } label: {
                        HStack {
                            Image(systemName: "clock")
                                .foregroundStyle(.ufBluegreen)
                                .font(.system(size: 15))
                            
                            Text("운영시간")
                                .font(.pretendard(weight: .p5, size: 13))
                                .foregroundStyle(.grey900)
                                .padding(.leading, -2)
                            
                            Image(systemName: "chevron.down")
                                .resizable()
                                .frame(width: 10, height: 6)
                                .foregroundStyle(.grey600)
                                .padding(.leading, -1)
                                .rotationEffect(isOperatingHoursExpanded ? .degrees(180) : .zero)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 14)
                
                if isOperatingHoursExpanded {
                    if let scheduleList = viewModel.boothModel.selectedBooth?.scheduleList, !scheduleList.isEmpty {
                        VStack {
                            ForEach(scheduleList, id: \.date) { schedule in
                                let openTimeString = formatTime(schedule.openTime)
                                let closeTimeString = formatTime(schedule.closeTime)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text("날짜: ")
                                        Text(schedule.date)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("Open Time: ")
                                        Text(openTimeString)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("Close Time: ")
                                        Text(closeTimeString)
                                        Spacer()
                                    }
                                }
                            }
                        }
                        .font(.pretendard(weight: .p5, size: 13))
                        .foregroundStyle(.grey700)
                        .padding(.leading, 40)
                        .padding(.top, -1)
                        .padding(.bottom, 5)
                    } else {
                        VStack {
                            HStack {
                                Text("Open Time: ")
                                    .padding(.trailing, -5)
                                Text("등록된 정보가 없습니다")
                                
                                Spacer()
                            }
                            .padding(.bottom, 2)
                            
                            HStack {
                                Text("Close Time: ")
                                    .padding(.trailing, -5)
                                Text("등록된 정보가 없습니다")
                                Spacer()
                            }
                        }
                        .font(.pretendard(weight: .p5, size: 13))
                        .foregroundStyle(.grey700)
                        .padding(.leading, 40)
                        .padding(.top, -1)
                        .padding(.bottom, 5)
                    }
                    
                    //                    VStack {
                    //                        HStack {
                    //                            Text("Open Time: ")
                    //                                .padding(.trailing, -5)
                    //
                    //                            if let openTime = viewModel.boothModel.selectedBooth?.openTime {
                    //                                let timeString = formatTime(openTime)
                    //                                Text(timeString)
                    //                            } else {
                    //                                Text("등록된 정보가 없습니다")
                    //                            }
                    //
                    //                            Spacer()
                    //                        }
                    //                        .padding(.bottom, 2)
                    //
                    //                        HStack {
                    //                            Text("Close Time: ")
                    //                                .padding(.trailing, -5)
                    //
                    //                            if let closeTime = viewModel.boothModel.selectedBooth?.closeTime {
                    //                                let timeString = formatTime(closeTime)
                    //                                Text(timeString)
                    //                            } else {
                    //                                Text("등록된 정보가 없습니다")
                    //                            }
                    //
                    //                            Spacer()
                    //                        }
                    //                    }
                    //                    .font(.pretendard(weight: .p5, size: 13))
                    //                    .foregroundStyle(.grey700)
                    //                    .padding(.leading, 40)
                    //                    .padding(.top, -1)
                    //                    .padding(.bottom, 5)
                }
                
                HStack {
                    Image(.marker)
                    
                    if let location = viewModel.boothModel.selectedBooth?.location {
                        Text(location.isEmpty ? "등록된 위치 설명이 없습니다" : location)
                            .font(.pretendard(weight: .p5, size: 13))
                            .foregroundStyle(.grey900)
                    } else {
                        Text("등록된 위치 설명이 없습니다")
                            .font(.pretendard(weight: .p5, size: 13))
                            .foregroundStyle(.grey900)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                Button {
                    isMapViewPresented = true
                } label: {
                    // Image(.longPinkButton)
                    Text("")
                        .roundedButton(background: colorScheme == .dark ? Color.grey100 : Color.white, strokeColor: .primary500, height: 33, cornerRadius: 10)
                        .padding(.horizontal)
                        .overlay {
                            Text(StringLiterals.Detail.openLocation)
                                .font(.pretendard(weight: .p6, size: 13))
                                .foregroundStyle(.primary500)
                        }
                }
                .padding(.bottom)
            }
            
            Text("").boldLine()
            /* Image(.boldLine)
             .resizable()
             .scaledToFit()
             .frame(maxWidth: .infinity)
             .padding(.bottom, 8)*/
        }
        .background(colorScheme == .dark ? Color.grey100 : Color.white)
        .fullScreenCover(isPresented: $isMapViewPresented, content: {
            //            if #available(iOS 17, *) {
            OneMapViewiOS17(viewModel: viewModel, mapViewModel: mapViewModel, booth: viewModel.boothModel.selectedBooth)
                .onAppear {
                    GATracking.eventScreenView(GATracking.ScreenNames.oneMapView)
                }
            //            } else {
            //                OneMapViewiOS16(viewModel: viewModel, booth: viewModel.boothModel.selectedBooth)
            //                    .onAppear {
            //                        GATracking.eventScreenView(GATracking.ScreenNames.oneMapView)
            //                    }
            //            }
        })
    }
    
    func formatTime(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        
        if let date = dateFormatter.date(from: time) {
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            return String(format: "%02d시 %02d분", hour, minute) // 00을 포함한 형식으로 출력
            //            // OO:OO 형식으로 format하는 코드
            //            dateFormatter.dateFormat = "HH:mm"
            //            let formattedTime = dateFormatter.string(from: date)
            //            return formattedTime
        } else {
            return ""
        }
    }
}

#Preview {
    @ObservedObject var viewModel = RootViewModel()
    @ObservedObject var mapViewModel = MapViewModel(viewModel: RootViewModel())
    
    return Group {
        BoothInfoView(viewModel: viewModel, mapViewModel: mapViewModel, selectedBoothHours: .constant(0), isReloadButtonPresent: .constant(true), isBoothThumbnailPresented: .constant(false), boothThumbnail: .constant(SelectedMenuInfo()))
            .onAppear {
                viewModel.boothModel.selectedBoothID = 119
                viewModel.boothModel.loadBoothDetail(119)
            }
    }
}
