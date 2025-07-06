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
                // 부모 뷰로 터치 이벤트 propagate 차단
                // 이미지 이외의 부분을 탭해도 MenuImageView가 뜨지 않도록 보장함
            }
            
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
                                .fontWeight(.bold)
                                .padding(.bottom, 4)
                        }
                    }
                    
                    if let warning = viewModel.boothModel.selectedBooth?.warning {
                        if !warning.isEmpty {
                            Text(viewModel.boothModel.selectedBooth?.warning ?? "")
                                .font(.pretendard(weight: .p6, size: 11))
                                .foregroundStyle(.primary500)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                
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
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    HStack {
                                        Text(formattedDate(from: schedule.date))
                                            .font(.pretendard(weight: .p6, size: 13))
                                            .foregroundStyle(.grey800)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("Open Time: ")
                                            .padding(.trailing, -5)
                                        Text(openTimeString)
                                        Spacer()
                                    }
                                    
                                    HStack {
                                        Text("Close Time: ")
                                            .padding(.trailing, -5)
                                        Text(closeTimeString)
                                        Spacer()
                                    }
                                }
                                .padding(.bottom, 5)
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
        }
        .background(colorScheme == .dark ? Color.grey100 : Color.white)
        .fullScreenCover(isPresented: $isMapViewPresented, content: {
            OneMapViewiOS17(viewModel: viewModel, mapViewModel: mapViewModel, booth: viewModel.boothModel.selectedBooth)
                .onAppear {
                    GATracking.eventScreenView(GATracking.ScreenNames.oneMapView)
                }
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
        } else {
            return ""
        }
    }
    
    func formattedDate(from dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "ko_KR") // 한국어 기준
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale(identifier: "ko_KR")
        outputFormatter.dateFormat = "yyyy년 M월 d일" // 원하는 출력 형식
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString // 파싱 실패 시 원본 그대로 반환
        }
    }
}

#Preview {
    @ObservedObject var viewModel = RootViewModel()
    @ObservedObject var mapViewModel = MapViewModel(viewModel: RootViewModel())
    
    return Group {
        BoothInfoView(viewModel: viewModel, mapViewModel: mapViewModel, isReloadButtonPresent: .constant(true), isBoothThumbnailPresented: .constant(false), boothThumbnail: .constant(SelectedMenuInfo()))
            .onAppear {
                viewModel.boothModel.selectedBoothID = 119
                viewModel.boothModel.loadBoothDetail(119)
            }
    }
}
