//
//  BoothInfoView.swift
//  unifest-ios
//
//  Created by 임지성 on 7/21/24.
//

import SwiftUI

struct BoothInfoView: View {
    @ObservedObject var viewModel: RootViewModel
    @State private var isMapViewPresented: Bool = false
    @Binding var selectedBoothHours: Int
    @Binding var isReloadButtonPresent: Bool
    @Environment(\.dismiss) var dismiss
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
                    }
                    Spacer()
                }
            }
            .frame(height: 260)
            .frame(maxWidth: .infinity)
            
            // 주간, 야간 선택 탭바
            HStack {
                ForEach(boothHours.indices, id: \.self) { index in
                    HStack {
                        Spacer()
                        Text(boothHours[index])
                            .padding(.bottom, 12)
                            .font(.pretendard(weight: .p6, size: 15))
                            .foregroundStyle(self.selectedBoothHours == index ? .black : .grayBABABF)
                            .onTapGesture {
                                withAnimation {
                                    self.selectedBoothHours = index
                                }
                            }
                        Spacer()
                    }
                    .overlay {
                        VStack {
                            Spacer()
                            if self.selectedBoothHours == index {
                                Color.black
                                    .frame(height: 1)
                            } else {
                                Color.grayBABABF
                                    .frame(height: 1)
                            }
                        }
                    }
                }
                .padding(.top, 5)
            }
            
            // 부스 이름(쿠쿠네 분식)부터 ~
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
                                .font(.system(size: 11))
                                .fontWeight(.semibold)
                                .foregroundStyle(.accent)
                                .lineLimit(3)
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
                                .font(.system(size: 13))
                                .foregroundStyle(.darkGray)
                                .padding(.bottom)
                                .multilineTextAlignment(.leading)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                    }
                }
                
                HStack {
                    Image(.greenMarker)
                    
                    MarqueeText(text: viewModel.boothModel.selectedBooth?.location ?? "", font: .systemFont(ofSize: 13), leftFade: 10, rightFade: 10, startDelay: 2, alignment: .leading)
                    // Text(viewModel.boothModel.selectedBooth?.location ?? "")
                    // .font(.system(size: 13))
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                
                Button {
                    isMapViewPresented = true
                } label: {
                    // Image(.longPinkButton)
                    Text("")
                        .roundedButton(background: .defaultWhite, strokeColor: .accent, height: 33, cornerRadius: 10)
                        .padding(.horizontal)
                        .overlay {
                            Text(StringLiterals.Detail.openLocation)
                                .font(.system(size: 13))
                                .fontWeight(.semibold)
                                .foregroundStyle(.accent)
                        }
                }
                .padding(.bottom)
            }
            
            Text("").boldLine().padding(.bottom, 8)
            /* Image(.boldLine)
             .resizable()
             .scaledToFit()
             .frame(maxWidth: .infinity)
             .padding(.bottom, 8)*/
        }
        .fullScreenCover(isPresented: $isMapViewPresented, content: {
            if #available(iOS 17, *) {
                OneMapViewiOS17(viewModel: viewModel, booth: viewModel.boothModel.selectedBooth)
                    .onAppear {
                        GATracking.eventScreenView(GATracking.ScreenNames.oneMapView)
                    }
            } else {
                OneMapViewiOS16(viewModel: viewModel, booth: viewModel.boothModel.selectedBooth)
                    .onAppear {
                        GATracking.eventScreenView(GATracking.ScreenNames.oneMapView)
                    }
            }
        })
    }
}

#Preview {
    @ObservedObject var viewModel = RootViewModel()
    
    return Group {
        BoothInfoView(viewModel: viewModel, selectedBoothHours: .constant(0), isReloadButtonPresent: .constant(true))
            .onAppear {
                viewModel.boothModel.selectedBoothID = 119
                viewModel.boothModel.loadBoothDetail(119)
            }
    }
}
